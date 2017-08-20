//
//  WTBookCache.m
//  WTBookReader
//
//  Created by liyuwen on 2017/8/20.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTBookCache.h"
@interface WTBookCache()
@property (nonatomic, copy) NSString *currentBookId;

@property (nonatomic, assign) NSUInteger cacheBeginIndex;
@property (nonatomic, assign) NSUInteger cacheEndIndex;
/** 仅仅缓存本章节前面的5章 后面20章 总共缓存26章 */
@property (nonatomic, strong) NSMutableDictionary *cacheDict;
@end
@implementation WTBookCache
static WTBookCache *bookCache = nil;
+(instancetype)bookCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bookCache = [[self alloc] init];
        
    });
    return bookCache;
}

- (instancetype)init{
    if (self = [super init]) {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (WTStoredChapterModel *)getChapterWithBookId:(NSString *)bookId currentChapter:(NSUInteger)currentChapter{
    if (![bookId isEqualToString:self.currentBookId]) {
        [self.cacheDict removeAllObjects];
    }
    if (currentChapter >= self.cacheBeginIndex && currentChapter <= self.cacheEndIndex) {
        return self.cacheDict[@(currentChapter)];
    }
    NSUInteger beginIndex = currentChapter - 5;
    NSUInteger endIndex = currentChapter + 20;
    if (beginIndex <= 0) beginIndex = 1;
    NSString *condition = [NSString stringWithFormat:@"chapterIndex >= %ld AND chapterIndex <= %ld",beginIndex,endIndex];
    RLMResults *results = [WTStoredChapterModel objectsWhere:condition];
    [self.cacheDict removeAllObjects];
    for (WTStoredChapterModel *chapter in results) {
        [self.cacheDict setObject:chapter forKey:@(chapter.chapterIndex)];
    }
    return self.cacheDict[@(currentChapter)];
}


@end
