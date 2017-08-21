//
//  WTStoredChapterModel.m
//  WTBookReader
//
//  Created by liyuwen on 2017/8/20.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTStoredChapterModel.h"

@implementation WTStoredChapterModel
@synthesize chapterId = _chapterId;
- (instancetype)initWithModel:(WTChapterModel *)model{
    if (self = [super init]) {
        self.title = model.title;
        self.link = model.link;
    }
    return self;
}

+ (NSArray<NSString *> *)indexedProperties{
    return @[@"chapterIndex",@"bookId"];
}

+ (NSString *)primaryKey{
    return @"chapterId";
}

- (NSString *)chapterId{
    if (!_chapterId) {
        _chapterId = [NSUUID UUID].UUIDString;
        NSLog(@"UUID == %@",_chapterId);
    }
    return _chapterId;
}

- (void)setChapterId:(NSString *)chapterId{
    _chapterId = chapterId;
}
@end
