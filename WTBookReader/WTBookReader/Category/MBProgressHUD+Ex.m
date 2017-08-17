//
//  MBProgressHUD+Ex.m
//  wuyouBanZhuRen
//
//  Created by xueban on 15/9/7.
//  Copyright (c) 2015年 Robin Zhang. All rights reserved.
//

#import "MBProgressHUD+Ex.h"
//#import "NSString+Extension.h"

@implementation MBProgressHUD (Ex)

+ (void)showTextMessage:(NSString *)message withYOffset:(CGFloat)yOffset{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:keyWindow];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.opacity = 0.7;
    hud.margin = 6.0;
    hud.yOffset = yOffset;
    hud.cornerRadius = 2.0;
    hud.labelFont = [UIFont systemFontOfSize:16];
    
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
}

+ (void)showTextMessageInWindow:(NSString *)message hideAfterDelay:(NSTimeInterval)delay{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if(!keyWindow)return;
    [MBProgressHUD showTextInView:keyWindow Message:message hideAfterDelay:delay];
}

+ (void)showTextInView:(UIView *)showView Message:(NSString *)message{
    [MBProgressHUD showTextInView:showView Message:message hideAfterDelay:1.5];
}

+ (void)showTextInView:(UIView *)showView Message:(NSString *)message hideAfterDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:showView];
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = 0.7;
    hud.margin = 6.0;
    hud.cornerRadius = 2.0;
    hud.labelFont = [UIFont systemFontOfSize:16];;
    if (message.length > 18) {
        hud.mode = MBProgressHUDModeCustomView;
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.text = message;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:16];;
        textLabel.backgroundColor = [UIColor clearColor];
        CGFloat fontHeight = [MBProgressHUD sizeOfStringWithFont:textLabel.font expectWidth:MainScreenWidth - 20 target:message];
        textLabel.frame = CGRectMake(0, 0, MainScreenWidth - 20, fontHeight + 5);
        hud.customView = textLabel;
        delay = 2.0;
        
    }else{
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
    }
   
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
}


+ (CGFloat)sizeOfStringWithFont:(UIFont *)font expectWidth:(CGFloat)width target:(NSString *)target{
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:target];
    
    NSRange allRange = [target rangeOfString:target];
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:allRange];
    CGFloat titleHeight;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:options
                                        context:nil];
    
    titleHeight = ceilf(rect.size.height);
    return titleHeight+2;  // 加两个像素,防止emoji被切掉.
}

@end
