//
//  WTReadPageViewModel.m
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTReadPageViewModel.h"

@implementation WTReadPageViewModel


- (WTRecordModel *)recordModel{
    if (!_recordModel) {
        _recordModel = [[WTRecordModel alloc] init];
        _recordModel.downloadProgressText = @"测试下....";
    }
    return _recordModel;
}
@end
