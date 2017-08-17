//
//  WTReadModel.m
//  WTBookReader
//
//  Created by xueban on 2017/8/17.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTReadModel.h"
#import "WTReadConfig.h"
#import "WTReadUtilites.h"

@implementation WTReadModel
MJCodingImplementation
-(instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
        _notes = [NSMutableArray array];
        _marks = [NSMutableArray array];
        _record = [[WTRecordModel alloc] init];
//        _record.chapterModel = _chapters.firstObject;
        _record.chapterCount = _chapters.count;
        _marksRecord = [NSMutableDictionary dictionary];
        _font = [NSNumber numberWithFloat:[WTReadConfig shareInstance].fontSize];
    }
    return self;
}

+(void)updateLocalModel:(WTReadModel *)readModel url:(NSURL *)url
{
    
    NSString *key = [url.path lastPathComponent];
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:readModel forKey:key];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}

- (NSUInteger)getPageIndexByOffset:(NSUInteger)offset Chapter:(NSUInteger)chapterIndex {
    WTChapterModel *chapterModel = _chapters[chapterIndex];
    NSArray *pageArray = chapterModel.pageArray;
    
    for (int i = 0; i < pageArray.count - 1; i++) {
        if (offset >= [pageArray[i] integerValue] && offset < [pageArray[i + 1] integerValue]) {
            return i;
        }
    }
    
    if (offset >= [pageArray[pageArray.count - 1] integerValue]) {
        return pageArray.count - 1;
    } else {
        return 0;
    }
}

@end
