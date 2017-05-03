//
//  WTSortDetailVC.h
//  WTBookReader
//
//  Created by xueban on 2017/4/26.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTSortDetailViewModel.h"

@interface WTSortDetailVC : UIViewController
+ (instancetype)sortDetailVC;
+ (instancetype)sortDetailVCWithViewModel:(WTSortDetailViewModel *)viewModel;
@end
