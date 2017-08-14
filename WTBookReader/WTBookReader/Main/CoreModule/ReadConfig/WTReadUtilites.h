//
//  WTReadUtilites.h
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTReadUtilites : NSObject
+(void)showAlertTitle:(NSString *)title content:(NSString *)string;
+(NSString *)encodeWithURL:(NSURL *)url;
+(UIButton *)commonButtonSEL:(SEL)sel target:(id)target;
+(UIViewController *)getCurrentVC;
@end
