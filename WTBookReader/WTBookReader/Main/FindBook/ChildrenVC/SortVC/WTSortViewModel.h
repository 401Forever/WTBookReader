//
//  WTSortViewModel.h
//  WTBookReader
//
//  Created by xueban on 2017/4/25.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTSortModel.h"
@class WTSortDataSource;
@interface WTSortViewModel : NSObject
@property(nonatomic,strong) NSArray<WTSortDataSource *> *dataSource;
@property(nonatomic,strong,readonly) RACCommand *reuqesCommand;
@end


