//
//  WTRankModel.h
//  WTBookReader
//
//  Created by xueban on 2017/5/6.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTRankItemModel : NSObject
@property(nonatomic,copy) NSString *_id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *cover;
@property(nonatomic,assign) BOOL collapse;
@property(nonatomic,copy) NSString *monthRank;
@property(nonatomic,copy) NSString *totalRank;
@property(nonatomic,copy) NSString *shortTitle;



- (RACSignal *)fetchImageSignal;
@end

@interface WTRankModel : NSObject
@property(nonatomic,strong) NSArray<WTRankItemModel *> *male;
@property(nonatomic,strong) NSArray<WTRankItemModel *> *female;


@property(nonatomic,copy) NSString *ok;
@end



@interface WTRankDataSource:NSObject
@property(nonatomic,strong) NSArray<WTRankItemModel *> *sectionData;
@property(nonatomic,copy) NSString *sectionTitle;
@property(nonatomic,copy) NSString *key;
- (instancetype)initWithData:(NSArray *)data title:(NSString *)title key:(NSString *)key;
@end
