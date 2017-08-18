//
//  WTStoredBookModel.m
//  WTBookReader
//
//  Created by xueban on 2017/8/18.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTStoredBookModel.h"

@implementation WTStoredBookModel
+ (NSString *)primaryKey{
    return @"bookId";
}

+ (NSDictionary *)defaultPropertyValues{
    return @{
             @"lateReadDate":[NSDate new]
             };
}

+ (NSArray<NSString *> *)indexedProperties{
    return @[@"bookId"];
}
@end
