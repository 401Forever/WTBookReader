//
//  WTBookshelfViewModel.h
//  WTBookReader
//
//  Created by liyuwen on 2017/8/19.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTSortDetailModel.h"
@interface WTBookshelfViewModel : NSObject
@property(nonatomic,strong,readonly) RACCommand *reuqesCommand;
- (WTSortDetailItemModel *)modelAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfRowsInSection:(NSInteger) section;

- (void)deleteBookAtIndexPath:(NSIndexPath *)indexPath;
@end
