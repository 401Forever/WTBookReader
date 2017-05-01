//
//  WTSortModel.h
//  WTBookReader
//
//  Created by xueban on 2017/4/25.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTSortItemModel : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *bookCount;
@end

@interface WTSortModel : NSObject
@property(nonatomic,strong) NSArray<WTSortItemModel *> *male;
@property(nonatomic,strong) NSArray<WTSortItemModel *> *female;
@property(nonatomic,strong) NSArray<WTSortItemModel *> *press;


@property(nonatomic,copy) NSString *ok;
@end



@interface WTSortDataSource:NSObject
@property(nonatomic,strong) NSArray<WTSortItemModel *> *sectionData;
@property(nonatomic,copy) NSString *sectionTitle;
@property(nonatomic,copy) NSString *key;
- (instancetype)initWithData:(NSArray *)data title:(NSString *)title key:(NSString *)key;
@end
