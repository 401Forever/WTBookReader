//
//  WTBookshelfViewModel.m
//  WTBookReader
//
//  Created by liyuwen on 2017/8/19.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTBookshelfViewModel.h"
#import "WTStoredBookModel.h"
#import "WTSortDetailModel.h"
@interface WTBookshelfViewModel()
@property(nonatomic,strong) NSMutableArray *dataArray;
@end
@implementation WTBookshelfViewModel
- (instancetype)init{
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}

- (void)initialBind{
    @weakify(self);
    _reuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);

        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                RLMResults *result = [WTStoredBookModel allObjects];
                NSMutableArray *models = [NSMutableArray array];
                for (NSInteger index = 0; index < result.count; index++) {
                    [models addObject:[WTSortDetailItemModel itemWithModel:result[index]]];
                }
                [subscriber sendNext:models];
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(id value) {
            self.dataArray = value;
            return value;
        }];
    }];
    
}



- (NSInteger)numberOfRowsInSection:(NSInteger)pageIndex{
    return self.dataArray.count;
}
- (WTSortDetailItemModel *)modelAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count < indexPath.row) {
        return nil;
    }
    WTSortDetailItemModel *model = self.dataArray[indexPath.row];
    return model;
}

- (void)deleteBookAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count < indexPath.row) {
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    WTSortDetailItemModel *model = self.dataArray[indexPath.row];
    WTStoredBookModel *bookModel = [[WTStoredBookModel alloc] initWithModel:model];
    [realm beginWriteTransaction];
    bookModel = [WTStoredBookModel createOrUpdateInRealm:realm withValue:bookModel];
    [realm deleteObject:bookModel];
    [realm commitWriteTransaction];
    
    [self.dataArray removeObject:model];
}

@end
