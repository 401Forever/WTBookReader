//
//  UIViewController+Hud.h
//  WTBookReader
//
//  Created by liyuwen on 2017/8/17.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface UIViewController (Hud)
/** 需要移除的手势 */
@property(nonatomic,strong) MBProgressHUD *hud;

- (void)showProgressHUD;
- (void)hideProgressHUD;
@end
