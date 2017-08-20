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
//@property (nonatomic,assign) NSUInteger chapterIndex;
@property (nonatomic) NSUInteger pageCount;
-(NSString *)stringOfPage:(NSUInteger)index;
-(void)updateFont;



/** 章节报错 */
@property(nonatomic,copy) NSString *title;
/** 章节链接地址 */
@property(nonatomic,copy) NSString *link;
/** 未知？ 例如0 估计为bool */
@property(nonatomic,copy) NSString *unreadble;
/** 本章节内容是否已经下载 */
@property(nonatomic,assign) BOOL isDownloadChapter;
@end
