//
//  WTBookDownloader.m
//  WTBookReader
//
//  Created by xueban on 2017/8/17.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTBookDownloader.h"
@interface WTBookDownloader()
{
    dispatch_semaphore_t _semaphore;
}
@end
@implementation WTBookDownloader
static WTBookDownloader *downloader = nil;
+(instancetype)downloader
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[self alloc] init];
        
    });
    return downloader;
}

- (instancetype)init{
    if (self = [super init]) {
        _semaphore = dispatch_semaphore_create(1);
        [self initialBind];
    }
    return self;
}


- (void)initialBind{
    @weakify(self);
    _requestBookSourceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            RACTupleUnpack(NSString *bookId) = input;
            NSString *paramStr = [NSString stringWithFormat:@"?view=summary&book=%@",bookId];
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",HostString,Interface_BookSource,paramStr];
            [[WTNetworkManager shareNetworkManager] getWithURLString:url
                                                           postValue:nil
                                                    withRequestBlock:^(id resultDictionary, NSError *error) {
                                                        if (error) {
                                                            [subscriber sendError:error];
                                                            return;
                                                        }
                                                        if (resultDictionary) {
                                                            NSLog(@"%@",resultDictionary);
                                                            [subscriber sendNext:resultDictionary];
                                                            [subscriber sendCompleted];
                                                        }
                                                    }];
            return nil;
        }];
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(RACTuple *value) {
            NSMutableArray *models = [WTBookSourceModel objectArrayWithKeyValuesArray:value];
            return models;
        }];
    }];
    
    
    _fetchBookCatalogue = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            RACTupleUnpack(NSString *bookId) = input;
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",HostString,Interface_Catalogue,bookId];
            [[WTNetworkManager shareNetworkManager] getWithURLString:url
                                                           postValue:nil
                                                    withRequestBlock:^(id resultDictionary, NSError *error) {
                                                        if (error) {
                                                            [subscriber sendError:error];
                                                            return;
                                                        }
                                                        if (resultDictionary) {
                                                            NSLog(@"%@",resultDictionary);
                                                            [subscriber sendNext:resultDictionary];
                                                            [subscriber sendCompleted];
                                                        }
                                                    }];
            return nil;
        }];
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(id value) {
            WTBookCatalogueModel *model = [WTBookCatalogueModel objectWithKeyValues:value[@"mixToc"]];
            return model;
        }];
    }];
    
    
    _fetchBookChapterData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            RACTupleUnpack(WTChapterModel *chapter) = input;
            if (!chapter) return nil;
            [self fetChapterWithModel:chapter withComplete:^(id resultDictionary, NSError *error) {
                if (error) {
                    [subscriber sendError:error];
                    return;
                }
                if (resultDictionary) {
                    NSLog(@"%@",resultDictionary);
                    [subscriber sendNext:resultDictionary];
                    [subscriber sendCompleted];
                }
            }];
            return nil;
        }];
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(id value) {
            WTBookChapterContentModel *model = [WTBookChapterContentModel objectWithKeyValues:value[@"chapter"]];
            return model;
        }];
    }];
}

- (void)fetChapterWithModel:(WTChapterModel *)model withComplete:(RequestResult) complete{
    if (!model) {
        complete(nil,nil);
        return ;
    }
    NSString *timestamp = [NSString stringWithFormat:@"%ld",(NSUInteger)[[NSDate new] timeIntervalSince1970]];
    NSString *kStr = [self getMd5StringWith:model];
    NSString *urlStr = [model.link URLEncodedString];
    NSString *url = [NSString stringWithFormat:@"%@/%@?k=%@&t=%@",Interface_Chapter,urlStr,kStr,timestamp];
    [[WTNetworkManager shareNetworkManager] getWithURLString:url
                                                   postValue:nil
                                            withRequestBlock:^(id resultDictionary, NSError *error) {
                                                if (error) {
                                                    complete(nil,error);
                                                    return;
                                                }
                                                if (resultDictionary) {
                                                    complete(resultDictionary,nil);
                                                }
                                            }];

}

- (NSString *)getMd5StringWith:(WTChapterModel *)model{
    NSString *timestamp = [NSString stringWithFormat:@"%ld",(NSUInteger)[[NSDate new] timeIntervalSince1970] + 2 * 60 * 60];
    NSString *targetStr = [NSString stringWithFormat:@"%@/chapter/%@%@",BookSecretKey,[model.link URLEncodedString],timestamp];
    targetStr = [NSString MD5ForLower16Bate:targetStr];
    //http://chapter2.zhuishushenqi.com/chapter/http%3A%2F%2Fbook.my716.com%2FgetBooks.aspx%3Fmethod%3Dcontent%26bookId%3D634203%26chapterFile%3DU_719138_201607181024156331_0132_1.txt?k=9298f825cbdbfe38&t=1493717028
    return targetStr;
}

- (void)downloadAllChapterInBackgrounpWithCatalogue:(NSArray<WTChapterModel *> *)catalogues
                                             bookId:(NSString *)bookId{
    if (!catalogues || !bookId)return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger index = 0;index < catalogues.count; index++) {
            WTChapterModel *currentChapter = catalogues[index];
            NSLog(@"阻塞 %ld",index);
            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
            
            //如果已经下载的 就不再下载
            NSString *condition = [NSString stringWithFormat:@"bookId = '%@' AND chapterIndex = %ld",bookId, index];
            RLMResults *results = [WTStoredChapterModel objectsWhere:condition];
            if (results.count) {
                WTStoredChapterModel *result = results.firstObject;
                if (result.isDownloaded) {
                    NSLog(@"本章节已经下载  不再下载 %ld",index);
                    dispatch_semaphore_signal(_semaphore);
                    continue;
                }
            }
            
            [self fetChapterWithModel:currentChapter withComplete:^(id resultDictionary, NSError *error) {
                WTStoredChapterModel *storeChapter = [[WTStoredChapterModel alloc] initWithModel:currentChapter];
                RLMRealm *realm = [RLMRealm defaultRealm];
                if (error) {
                    NSLog(@"错误 == = = =%@",error);
                    storeChapter.isDownloaded = NO;
                    storeChapter.bookId = bookId;
                    storeChapter.chapterIndex = index;
                    storeChapter.updateTime = [NSDate new];
                    [realm beginWriteTransaction];
                    [WTStoredChapterModel createOrUpdateInRealm:realm withValue:storeChapter];
                    [realm commitWriteTransaction];
                    return;
                }else if (resultDictionary) {
                    WTBookChapterContentModel *chapterModel = [WTBookChapterContentModel objectWithKeyValues:resultDictionary[@"chapter"]];
                    storeChapter.bookId = bookId;
                    storeChapter.chapterIndex = index;
                    storeChapter.updateTime = [NSDate new];
                    storeChapter.body = chapterModel.body;
                    storeChapter.isDownloaded = YES;
                    [realm beginWriteTransaction];
                    [WTStoredChapterModel createOrUpdateInRealm:realm withValue:storeChapter];
                    [realm commitWriteTransaction];
                }
                dispatch_semaphore_signal(_semaphore);
            }];
        }
    });
}

@end
