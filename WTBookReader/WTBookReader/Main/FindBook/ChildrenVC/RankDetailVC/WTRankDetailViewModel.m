//
//  WTRankDetailViewModel.m
//  WTBookReader
//
//  Created by xueban on 2017/5/8.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTRankDetailViewModel.h"
@interface WTRankDetailViewModel()
@property(nonatomic,strong) NSArray *bookTypes;

@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSMutableArray *weekDataSource;
@property(nonatomic,strong) NSMutableArray *monthDataSource;
@property(nonatomic,strong) NSMutableArray *allDataSource;
@end

@implementation WTRankDetailViewModel
- (instancetype)init{
    if (self = [super init]) {
        _weekDataSource = [NSMutableArray array];
        _monthDataSource = [NSMutableArray array];
        _allDataSource = [NSMutableArray array];
        _dataArray = @[_weekDataSource, _monthDataSource, _allDataSource];
        [self initialBind];
    }
    return self;
}

- (instancetype)initWithModel:(WTRankItemModel *)model{
    if (self = [self init]) {
        _model = model;
    }
    return self;
}

- (void)initialBind{
    @weakify(self);
    _reuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        RACTupleUnpack(NSNumber *pageIndex,NSString *fetchStatus) = input;
        NSLog(@"%@ = ",fetchStatus);
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *idStr = self.pageIndex == 0 ? self.model._id : (self.pageIndex == 1 ? self.model.monthRank : self.model.totalRank);
            idStr = idStr.length ? idStr : @"";
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",HostString,Route_Rank,idStr];
            [[WTNetworkManager shareNetworkManager] getWithURLString:url
                                                           postValue:nil
                                                    withRequestBlock:^(id resultDictionary, NSError *error) {
                                                        if (error) {
                                                            [subscriber sendError:error];
                                                            return;
                                                        }
                                                        if (resultDictionary) {
                                                            NSLog(@"%@",resultDictionary);
                                                            [subscriber sendNext:RACTuplePack(pageIndex, resultDictionary)];
                                                            [subscriber sendCompleted];
                                                        }
                                                    }];
            return nil;
        }];
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(RACTuple *value) {
            RACTupleUnpack(NSNumber *pageIndex,id data) = value;
            WTRankDetailModel *model = [WTRankDetailModel objectWithKeyValues:data[@"ranking"]];
            NSMutableArray *currentData = self.dataArray[[pageIndex intValue]];
            [currentData addObjectsFromArray:model.books];
            return RACTuplePack(pageIndex, model.books);
        }];
    }];
    
    
    _canFetchHeaderDataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSArray *currentDataSource = self.dataArray[self.pageIndex];
        BOOL canHeaderFetch = currentDataSource.count ? NO : YES;
        [subscriber sendNext:@(canHeaderFetch)];
        return nil;
    }];
}



- (NSInteger)numberOfRowsInSection:(NSInteger)pageIndex{
    NSMutableArray *currentData = self.dataArray[pageIndex];
    return currentData.count;
}
- (WTSortDetailItemModel *)modelAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *currentData = self.dataArray[self.pageIndex];
    return currentData[indexPath.row];
}

- (void)cleanDataAtPageIndex:(NSInteger)pageIndex{
    if (pageIndex < 0 || pageIndex >= 4)return;
    NSMutableArray *cleanData = _dataArray[pageIndex];
    [cleanData removeAllObjects];
}

#pragma mark - Setter And Getter
- (NSArray *)bookTypes{
    if (!_bookTypes) {
        _bookTypes = @[@"hot",@"new",@"reputation",@"over"];
    }
    return _bookTypes;
}

- (void)setPageIndex:(NSInteger)pageIndex{
    if (pageIndex < 0 || pageIndex >= 4) {
        NSLog(@"页码出现错误.....pageIndex超出范围:%ld" ,pageIndex);
        return;
    }
    _pageIndex = pageIndex;
}


@end
