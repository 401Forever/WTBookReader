//
//  WTRecordModel.h
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTChapterModel.h"
@interface WTRecordModel : NSObject
@property (nonatomic,strong) WTChapterModel *chapterModel;  //阅读的章节
@property (nonatomic) NSUInteger page;  //阅读的页数
@property (nonatomic) NSUInteger chapter;    //阅读的章节数
@property (nonatomic) NSUInteger chapterCount;  //总章节数


@property(nonatomic,copy) NSString *downloadProgressText;//下载的进度提示
@property(nonatomic,assign) BOOL isDownloading; //是否在下载中
@end
