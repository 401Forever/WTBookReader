//
//  WTRankDetailViewModel.h
//  WTBookReader
//
//  Created by xueban on 2017/5/8.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTRankModel.h"
#import "WTRankDetailModel.h"

#define WTRankDetailViewModel_FetchStatus_Header @"FetchStatus_Header"
#define WTRankDetailViewModel_FetchStatus_Bottom @"FetchStatus_Bottom"

@interface WTRankDetailViewModel : NSObject
@property(nonatomic,assign) NSInteger pageIndex;
@property(nonatomic,strong,readonly) WTRankItemModel *model;
@property(nonatomic,strong,readonly) RACCommand *reuqesCommand;
@property(nonatomic,strong,readonly) RACSignal *canFetchHeaderDataSignal;

- (NSInteger)numberOfRowsInSection:(NSInteger) pageIndex;
- (WTSortDetailItemModel *)modelAtIndexPath:(NSIndexPath *)indexPath;
- (void)cleanDataAtPageIndex:(NSInteger)pageIndex;

- (instancetype)initWithModel:(WTRankItemModel *)model;
@end
