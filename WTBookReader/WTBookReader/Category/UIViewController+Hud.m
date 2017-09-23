//
//  UIViewController+Hud.m
//  WTBookReader
//
//  Created by liyuwen on 2017/8/17.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "UIViewController+Hud.h"

@implementation UIViewController (Hud)
/* 为分类拓展属性 */
char* const ASSOCIATION_MBProgressHUD = "ASSOCIATION_MBProgressHUD";
- (void)setHud:(MBProgressHUD *)hud{
    objc_setAssociatedObject(self, ASSOCIATION_MBProgressHUD, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)hud{
    MBProgressHUD *hud = objc_getAssociatedObject(self, ASSOCIATION_MBProgressHUD);
    if (!hud) {
        hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self setHud:hud];
        hud.removeFromSuperViewOnHide = YES;
        hud.labelText = @"Loading";
    }
    [self.view addSubview:hud];
    return hud;
}

- (void)showProgressHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud show:YES];
    });
}

- (void)hideProgressHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hide:YES];
    });

}

- (void)showMessage:(NSString *)message{
    [MBProgressHUD showTextMessageInWindow:message hideAfterDelay:1.0];
}
@end
