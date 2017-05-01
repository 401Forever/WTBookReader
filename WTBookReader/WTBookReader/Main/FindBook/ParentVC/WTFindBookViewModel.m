//
//  WTFindBookViewModel.m
//  WTBookReader
//
//  Created by xueban on 2017/4/24.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTFindBookViewModel.h"
#import "NSObject+MJKeyValue.h"

@implementation WTFindBookViewModel
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [WTFindBookModel objectArrayWithKeyValuesArray:@[@{@"title":@"排行榜",@"imageName":@"d_ranking"},@{@"title":@"分类",@"imageName":@"d_cate"}]];
    }
    return _dataSource;
}
@end
