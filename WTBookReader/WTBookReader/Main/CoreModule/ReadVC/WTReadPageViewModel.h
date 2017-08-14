//
//  WTReadPageViewModel.h
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTRecordModel.h"
@interface WTReadPageViewModel : NSObject
@property(nonatomic,strong) WTRecordModel *recordModel;
@property(nonatomic,strong) WTChapterModel *tempChapter;
@end
