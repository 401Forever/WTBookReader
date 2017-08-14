//
//  WTChapterModel.h
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTChapterModel : NSObject<NSCopying,NSCoding>
@property (nonatomic,strong) NSMutableArray *pageArray;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign) NSUInteger chapterIndex;
@property (nonatomic) NSUInteger pageCount;
-(NSString *)stringOfPage:(NSUInteger)index;
-(void)updateFont;
@end
