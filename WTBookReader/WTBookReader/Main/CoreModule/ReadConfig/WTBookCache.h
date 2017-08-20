//
//  WTBookCache.h
//  WTBookReader
//
//  Created by liyuwen on 2017/8/20.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTStoredChapterModel.h"
@interface WTBookCache : NSObject
+ (instancetype)bookCache;

- (WTStoredChapterModel *)getChapterWithBookId:(NSString *)bookId
                                currentChapter:(NSUInteger)currentChapter;
@end
