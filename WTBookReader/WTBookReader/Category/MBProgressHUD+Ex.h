//
//  MBProgressHUD+Ex.h
//  wuyouBanZhuRen
//
//  Created by xueban on 15/9/7.
//  Copyright (c) 2015年 Robin Zhang. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Ex)
/**
 *  在keyWindow中显示文本提示
 *
 *  @param message 文本
 *  @param delay   延迟隐藏时间
 */
+ (void)showTextMessageInWindow:(NSString *)message hideAfterDelay:(NSTimeInterval)delay;

/**
 *  快捷方式显示一个提示
 *
 *  @param showView 展示View
 *  @param message  message
 */
+ (void)showTextInView:(UIView *)showView Message:(NSString *)message;
/**
 *  同上
 */
+ (void)showTextInView:(UIView *)showView Message:(NSString *)message hideAfterDelay:(NSTimeInterval)delay;

/** 显示窗口Y轴偏移 */
+ (void)showTextMessage:(NSString *)message withYOffset:(CGFloat)yOffset;

@end
