//
//  WTBookViewModel.m
//  WTBookReader
//
//  Created by xueban on 2017/8/10.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTBookViewModel.h"


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
            return model;
        }];
    }];
    
    
    _fetchBookChapterData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
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
            return model;
        }];
    }];
}


@end
