//
//  WTMarkModel.h
//  WTBookReader
//
//  Created by xueban on 2017/8/17.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTRecordModel.h"
@interface WTMarkModel : NSObject
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,assign) NSUInteger location;
@property (nonatomic,assign) NSUInteger length;
@property (nonatomic,assign) NSUInteger chapter;
@property (nonatomic,strong) WTRecordModel *recordModel;
@end
