//
//  WTSortViewModel.m
//  WTBookReader
//
//  Created by xueban on 2017/4/25.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTSortViewModel.h"

@implementation WTSortViewModel

- (instancetype)init{
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}

- (void)initialBind{
    _reuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           NSString *url = [NSString stringWithFormat:@"%@/%@/%@",HostString,Route_Sort,Interface_Sort];
           [[WTNetworkManager shareNetworkManager] getWithURLString:url
                                                          postValue:nil
                                                   withRequestBlock:^(id resultDictionary, NSError *error) {
               [subscriber sendNext:resultDictionary];
               [subscriber sendCompleted];
           }];
           return nil;
       }];
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(NSDictionary *value) {
            WTSortModel *model = [WTSortModel objectWithKeyValues:value];
            NSArray *dataSource = @[
                        [[WTSortDataSource alloc] initWithData:model.male title:@"男生" key:@"male"],
                        [[WTSortDataSource alloc] initWithData:model.female title:@"女生" key:@"female"],
                        [[WTSortDataSource alloc] initWithData:model.press title:@"出版" key:@"press"],
                            ];
            return dataSource;
        }];
    }];
}


@end



