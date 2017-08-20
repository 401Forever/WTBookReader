//
//  WTStoredChapterModel.h
//  WTBookReader
//
//  Created by liyuwen on 2017/8/20.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Realm/Realm.h>

@interface WTStoredChapterModel : RLMObject
/** 章节索引 */
@property NSInteger chapterIndex;
/** 章节标题 */
@property NSString *title;
/** 书籍id 外键 */
@property NSString *bookId;
/** 章节下载地址 */
@property NSString *link;
/** 章节内容 */
@property NSString *body;
/** 最后一次更新的时间 */
@property NSDate *updateTime;
/** 章节是否被下载 */
@property BOOL isDownloaded;

@end
