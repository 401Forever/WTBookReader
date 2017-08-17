//
//  WTBookDownloader.h
//  WTBookReader
//
//  Created by xueban on 2017/8/17.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTSortDetailModel.h"
#import "WTBookSourceModel.h"
#import "WTBookCatalogueModel.h"
#import "NSString+Common.h"

@interface WTBookDownloader : NSObject
+(instancetype)downloader;

/** 获取书源 */
@property(nonatomic,strong,readonly) RACCommand *requestBookSourceCommand;
/** 获取数据目录 */
@property(nonatomic,strong) RACCommand *fetchBookCatalogue;
/** 获取指定章节的数据 */
@property(nonatomic,strong) RACCommand *fetchBookChapterData;
@end
