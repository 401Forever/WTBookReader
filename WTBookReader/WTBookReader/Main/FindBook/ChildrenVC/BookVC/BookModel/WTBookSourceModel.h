//
//  WTBookSourceModel.h
//  WTBookReader
//  书源模型
//  Created by xueban on 2017/8/10.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTBookSourceModel : NSObject
/** 书籍ID */
@property(nonatomic,copy) NSString *_id;
/** 书籍源 例如zhuishuvip */
@property(nonatomic,copy) NSString *source;
/** 最后一章 */
@property(nonatomic,copy) NSString *lastChapter;
/** 是否做了修改 */
@property(nonatomic,copy) NSString *isCharge;
/** 更新时间 2017-08-09T09:32:16.810Z,*/
@property(nonatomic,copy) NSString *updated;
/** 例如 1  估计是bool */
@property(nonatomic,copy) NSString *starting;
/** 书籍数据链接地址 */
@property(nonatomic,copy) NSString *link;
/** 章节数量 */
@property(nonatomic,copy) NSString *chaptersCount;
/** 书源地址Host */
@property(nonatomic,copy) NSString *host;
/** 书源名称 */
@property(nonatomic,copy) NSString *name;
@end
