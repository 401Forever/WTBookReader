//
//  WTBookViewModel.m
//  WTBookReader
//
//  Created by xueban on 2017/8/10.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTBookViewModel.h"
#import "NSString+Common.h"
@interface WTBookViewModel()
@property(nonatomic,strong) WTBookCatalogueModel *catalogueModel;
@end

@implementation WTBookViewModel
- (instancetype)init{
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}
- (instancetype)initWithModel:(WTSortDetailItemModel *)model{
    if (self = [self init]) {
        _model = model;
    }
    return self;
}

- (void)initialBind{
    @weakify(self);
    _requestBookSourceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *paramStr = [NSString stringWithFormat:@"?view=summary&book=%@",self.model._id];
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
        @strongify(self);
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",HostString,Interface_Catalogue,self.model._id];
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
            self.catalogueModel = model;
            return model;
        }];
    }];
    
    
    _fetchBookChapterData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            RACTupleUnpack(WTBookChapterModel *chapter) = input;
            if (!chapter) chapter = self.catalogueModel.chapters.firstObject;
            NSString *timestamp = [NSString stringWithFormat:@"%ld",(NSUInteger)[[NSDate new] timeIntervalSince1970]];
            NSString *kStr = [self getMd5StringWith:chapter];
            NSString *urlStr = [chapter.link URLEncodedString];
            NSString *url = [NSString stringWithFormat:@"%@/%@?k=%@&t=%@",Interface_Chapter,urlStr,kStr,timestamp];
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
            WTBookChapterContentModel *model = [WTBookChapterContentModel objectWithKeyValues:value[@"chapter"]];
            return model;
        }];
    }];
}

- (NSString *)getMd5StringWith:(WTBookChapterModel *)model{
    NSString *timestamp = [NSString stringWithFormat:@"%ld",(NSUInteger)[[NSDate new] timeIntervalSince1970] + 2 * 60 * 60];
    NSString *targetStr = [NSString stringWithFormat:@"%@/chapter/%@%@",BookSecretKey,[model.link URLEncodedString],timestamp];
    targetStr = [NSString MD5ForLower16Bate:targetStr];
    //http://chapter2.zhuishushenqi.com/chapter/http%3A%2F%2Fbook.my716.com%2FgetBooks.aspx%3Fmethod%3Dcontent%26bookId%3D634203%26chapterFile%3DU_719138_201607181024156331_0132_1.txt?k=9298f825cbdbfe38&t=1493717028
    return targetStr;
}

@end
