//
//  WTSortModel.m
//  WTBookReader
//
//  Created by xueban on 2017/4/25.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTSortModel.h"


@implementation WTSortItemModel

@end

@implementation WTSortModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"male":@"WTSortItemModel",
             @"female":@"WTSortItemModel",
             @"press":@"WTSortItemModel",
             };
}
@end


@implementation WTSortDataSource
- (instancetype)initWithData:(NSArray *)data title:(NSString *)title key:(NSString *)key{
    if (self = [super init]) {
        _sectionData = data;
        _sectionTitle = title;
        _key = key;
    }
    return self;
}
@end
