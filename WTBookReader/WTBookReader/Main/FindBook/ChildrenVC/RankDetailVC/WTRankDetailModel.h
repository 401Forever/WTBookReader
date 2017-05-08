//
//  WTRankDetailModel.h
//  WTBookReader
//
//  Created by xueban on 2017/5/8.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTSortDetailModel.h"
@interface WTRankDetailModel : NSObject
@property(nonatomic,copy) NSString *_id;
@property(nonatomic,copy) NSString *updated;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,copy) NSString *cover;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *__v;
@property(nonatomic,copy) NSString *monthRank;
@property(nonatomic,copy) NSString *totalRank;
@property(nonatomic,copy) NSString *shortTitle;
@property(nonatomic,copy) NSString *created;
@property(nonatomic,copy) NSString *isSub;
@property(nonatomic,copy) NSString *collapse;
@property(nonatomic,copy) NSString *newestField;
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString *priority;
@property(nonatomic,copy) NSString *total;

@property(nonatomic,strong) NSArray<WTSortDetailItemModel *> *books;
@property(nonatomic,assign) BOOL ok;
@end
