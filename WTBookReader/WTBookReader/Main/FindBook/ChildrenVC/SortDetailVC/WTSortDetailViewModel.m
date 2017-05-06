//
//  WTSortDetailViewModel.m
//  WTBookReader
//
//  Created by xueban on 2017/4/27.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTSortDetailViewModel.h"

@interface WTSortDetailViewModel()
@property(nonatomic,strong) NSArray *bookTypes;

@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSMutableArray *hotDataSource;
@property(nonatomic,strong) NSMutableArray *newestDataSource;
@property(nonatomic,strong) NSMutableArray *praiseDataSource;
@property(nonatomic,strong) NSMutableArray *endDataSource;
@end



@implementation WTSortDetailViewModel

- (instancetype)init{
    if (self = [super init]) {
        _hotDataSource = [NSMutableArray array];
        _newestDataSource = [NSMutableArray array];
        _praiseDataSource = [NSMutableArray array];
        _endDataSource = [NSMutableArray array];
        _dataArray = @[_hotDataSource, _newestDataSource, _praiseDataSource, _endDataSource];
        [self initialBind];
    }
    return self;
}

- (instancetype)initWithModel:(WTSortItemModel *)model{
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
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableArray *currentData = self.dataArray[[pageIndex intValue]];
            NSInteger startCount = currentData.count;
            if ([fetchStatus isEqualToString:WTSortDetailViewModel_FetchStatus_Header]) {
                startCount = 0;
            }
            NSDictionary *requestDict = @{
                                          @"gender":@"male",//第一级分组 男、女、出版类
                                          @"type":self.bookTypes[self.pageIndex], // 书籍状态等
                                          @"major":self.model.name.length ? self.model.name : @"",// 第二级分组 都市
                                          @"minor":@"", // 第三级分组 都市生活
                                          @"start":@(startCount),// 起始获取节点
                                          @"limit":@"20", //每次获取数量
                                          };
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",HostString,Route_Book,Interface_Book_Category];
            [[WTNetworkManager shareNetworkManager] getWithURLString:url
                                                           postValue:requestDict
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
            WTSortDetailModel *model = [WTSortDetailModel objectWithKeyValues:data];
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
