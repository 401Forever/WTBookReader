//
//  WTBookCatalogueModel.m
//  WTBookReader
//
//  Created by xueban on 2017/8/10.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTBookCatalogueModel.h"

@implementation WTBookCatalogueModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"chapters" : @"WTBookChapterModel"
             };
}
@end

@implementation WTBookChapterModel
@end

@implementation WTBookChapterContentModel
@end
