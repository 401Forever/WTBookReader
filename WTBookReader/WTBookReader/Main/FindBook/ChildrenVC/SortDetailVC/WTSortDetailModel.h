//
//  WTSortDetailModel.h
//  WTBookReader
//
//  Created by xueban on 2017/4/27.
//  Copyright © 2017年 lyw. All rights reserved.
//
@class WTStoredBookModel;
#import <Foundation/Foundation.h>
@class WTSortDetailItemModel;

@interface WTSortDetailModel : NSObject
@property(nonatomic,copy) NSString *total;
@property(nonatomic,strong) NSArray<WTSortDetailItemModel *> *books;
@property(nonatomic,assign) BOOL ok;
@end


@interface WTSortDetailItemModel : NSObject
@property(nonatomic,copy) NSString *_id;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *banned;
@property(nonatomic,copy) NSString *cover;
@property(nonatomic,copy) NSString *lastChapter;
@property(nonatomic,copy) NSString *latelyFollower;
@property(nonatomic,copy) NSString *majorCate;
@property(nonatomic,copy) NSString *retentionRatio;
@property(nonatomic,copy) NSString *shortIntro;
@property(nonatomic,copy) NSString *site;
@property(nonatomic,copy) NSString *title;
/** 字段已被删除 */
@property(nonatomic,strong) NSArray *tags;


@property(nonatomic,copy) NSString *authorAndMajorCate;
@property(nonatomic,copy) NSString *latelyFollowerAndretentionRatio;

- (RACSignal *)fetchImageSignal;

+ (instancetype)itemWithModel:(WTStoredBookModel *)model;
@end
