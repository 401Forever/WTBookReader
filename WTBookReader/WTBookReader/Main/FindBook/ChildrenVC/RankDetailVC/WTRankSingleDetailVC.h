//
//  WTRankSingleDetailVC.h
//  WTBookReader
//
//  Created by xueban on 2017/5/8.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRankDetailViewModel.h"
#import "WTSortDetailCell.h"
#import "WTReadPageViewController.h"

@interface WTRankSingleDetailVC : UIViewController
+ (instancetype)rankDetailVC;
+ (instancetype)rankDetailVCWithViewModel:(WTRankDetailViewModel *)viewModel;
@end
