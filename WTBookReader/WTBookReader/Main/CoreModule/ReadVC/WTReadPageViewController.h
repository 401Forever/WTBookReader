//
//  WTReadPageViewController.h
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTReadViewController.h"
#import "WTReadPageViewModel.h"

@interface WTReadPageViewController : UIViewController
@property(nonatomic,strong) WTReadPageViewModel *viewModel;
@end
