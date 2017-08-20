//
//  WTStoredBookModel.m
//  WTBookReader
//
//  Created by xueban on 2017/8/18.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTStoredBookModel.h"
#import "WTBookStoreManager.h"
@implementation WTStoredBookModel
- (instancetype)initWithModel:(WTSortDetailItemModel *)model{
    if (self = [super init]) {
        self.bookId = model._id;
        self.author = model.author;
        self.banned = model.banned;
        self.cover = model.cover;
        self.shortIntro = model.shortIntro;
        self.site = model.site;
        self.title = model.title;
    }
    return self;
}

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
