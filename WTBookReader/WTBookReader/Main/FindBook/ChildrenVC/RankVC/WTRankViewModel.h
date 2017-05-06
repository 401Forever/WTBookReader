//
//  WTRankViewModel.h
//  WTBookReader
//
//  Created by xueban on 2017/5/6.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTRankModel.h"
@interface WTRankViewModel : NSObject
@property(nonatomic,strong) NSArray<WTRankDataSource *> *dataSource;
@property(nonatomic,strong,readonly) RACCommand *reuqesCommand;
@end
