//
//  WTRankViewModel.m
//  WTBookReader
//
//  Created by xueban on 2017/5/6.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTRankViewModel.h"

@implementation WTRankViewModel

- (instancetype)init{
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}

- (void)initialBind{
    _reuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",HostString,Route_Rank,Interface_Rank_All];
            [[WTNetworkManager shareNetworkManager] getWithURLString:url
                                                           postValue:nil
                                                    withRequestBlock:^(id resultDictionary, NSError *error) {
                                                        NSLog(@"%@",resultDictionary);
                                                        [subscriber sendNext:resultDictionary];
                                                        [subscriber sendCompleted];
                                                    }];
            return nil;
        }];
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(NSDictionary *value) {
            WTRankModel *model = [WTRankModel objectWithKeyValues:value];
            NSArray *dataSource = @[
                                    [[WTRankDataSource alloc] initWithData:model.male title:@"男生" key:@"male"],
                                    [[WTRankDataSource alloc] initWithData:model.female title:@"女生" key:@"female"],
                                    ];
            return dataSource;
        }];
    }];
}


@end
