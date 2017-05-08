//
//  WTRankDetailModel.m
//  WTBookReader
//
//  Created by xueban on 2017/5/8.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTRankDetailModel.h"

@implementation WTRankDetailModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"books":@"WTSortDetailItemModel",
             };
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"newestField":@"new"};
}
@end
