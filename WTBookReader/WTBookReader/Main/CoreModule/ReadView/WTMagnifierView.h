//
//  WTMagnifierView.h
//  WTBookReader
//  放大镜
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTMagnifierView : UIView
@property (nonatomic,weak) UIView *readView;
@property (nonatomic) CGPoint touchPoint;
@end
