//
//  WTTopMenuView.h
//  WTBookReader
//
//  Created by xueban on 2017/8/16.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTMenuViewDelegate;
@interface WTTopMenuView : UIView
@property (nonatomic,assign) BOOL state; //(0--未保存过，1-－保存过)
@property (nonatomic,weak) id<WTMenuViewDelegate>delegate;
@end
