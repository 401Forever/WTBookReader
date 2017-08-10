//
//  WTTempBookVC.h
//  WTBookReader
//
//  Created by xueban on 2017/8/10.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBookViewModel.h"

@interface WTTempBookVC : UIViewController
+ (instancetype)bookVCWithViewModel:(WTBookViewModel *)viewModel;
@end
