//
//  WTChapterModel.m
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTChapterModel.h"
#import "WTReadConfig.h"
#import "WTReadParser.h"

@implementation WTChapterModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageArray = [NSMutableArray array];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    WTChapterModel *model = [[WTChapterModel allocWithZone:zone] init];
    model.content = self.content;
    model.title = self.title;
    model.pageCount = self.pageCount;
    return model;
    
}
-(void)setContent:(NSString *)content
{
    _content = content;
    [self paginateWithBounds:CGRectMake(LeftSpacing, TopSpacing, [UIScreen mainScreen].bounds.size.width-LeftSpacing-RightSpacing, [UIScreen mainScreen].bounds.size.height-TopSpacing-BottomSpacing)];
}
-(void)updateFont
{
    [self paginateWithBounds:CGRectMake(LeftSpacing, TopSpacing, [UIScreen mainScreen].bounds.size.width-LeftSpacing-RightSpacing, [UIScreen mainScreen].bounds.size.height-TopSpacing-BottomSpacing)];
}
-(void)paginateWithBounds:(CGRect)bounds
{
    //    _pages.clear();
    [_pageArray removeAllObjects];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:self.content];
    NSDictionary *attribute = [WTReadParser parserAttribute:[WTReadConfig shareInstance]];
    [attrString setAttributes:attribute range:NSMakeRange(0, attrString.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            
            ++samePlaceRepeatCount;
            
        } else {
            
            samePlaceRepeatCount = 0;
        }
        
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (_pageArray.count == 0) {
                [_pageArray addObject:@(currentOffset)];
            }
            else {
                
                //                NSUInteger lastOffset = _pages.back();
                NSUInteger lastOffset = [[_pageArray lastObject] integerValue];
                
                if (lastOffset != currentOffset) {
                    
                    [_pageArray addObject:@(currentOffset)];
                }
            }
            break;
        }
        
        [_pageArray addObject:@(currentOffset)];
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        
        if ((range.location + range.length) != attrString.length) {
            
            currentOffset += range.length;
            currentInnerOffset += range.length;
            
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
    _pageCount = _pageArray.count;
}
-(NSString *)stringOfPage:(NSUInteger)index
{
    NSUInteger local = [_pageArray[index] integerValue];
    NSUInteger length;
    if (index<self.pageCount-1) {
        length=  [_pageArray[index+1] integerValue] - [_pageArray[index] integerValue];
    }
    else{
        length = _content.length - [_pageArray[index] integerValue];
    }
    return [_content substringWithRange:NSMakeRange(local, length)];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.pageCount forKey:@"pageCount"];
    [aCoder encodeObject:self.pageArray forKey:@"pageArray"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _content = [aDecoder decodeObjectForKey:@"content"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.pageCount = [aDecoder decodeIntegerForKey:@"pageCount"];
        self.pageArray = [aDecoder decodeObjectForKey:@"pageArray"];
    }
    return self;
}

@end
