//
//  WTBookCatalogueModel.h
//  WTBookReader
//  书籍目录模型
//  Created by xueban on 2017/8/10.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTBookChapterModel;
@interface WTBookCatalogueModel : NSObject
/** 未知ID */
@property(nonatomic,copy) NSString *_id;
/** 章节最后更新时间 2017-08-09T09:38:20.996Z */
@property(nonatomic,copy) NSString *chaptersUpdated;
/** 书籍ID 接口传递过去的 */
@property(nonatomic,copy) NSString *book;
@property(nonatomic,strong) NSArray<WTBookChapterModel *> *chapters;
@end


@interface WTBookChapterModel : NSObject
/** 章节报错 */
@property(nonatomic,copy) NSString *title;
/** 章节链接地址 
    http://book.my716.com/getBooks.aspx?method=content&bookId=1450502&chapterFile=U_1535862_201703072120407628_9273_1.txt, 
 */
@property(nonatomic,copy) NSString *link;
/** 未知？ 例如0 估计为bool */
@property(nonatomic,copy) NSString *unreadble;
@end


@interface WTBookChapterContentModel : NSObject
/** 章节标题 */
@property(nonatomic,copy) NSString *title;
/** 章节内容 */
@property(nonatomic,copy) NSString *body;
/** 是否加载成功 */
@property(nonatomic,copy) NSString *ok;

@end
