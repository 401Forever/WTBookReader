//
//  WTReadView.h
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTReadParser.h"
#import "WTReadUtilites.h"

@class WTReadView;
@protocol WTReadViewDelegate <NSObject>
-(void)readViewEditeding:(WTReadView *)readView;
-(void)readViewEndEdit:(WTReadView *)readView;
@end

@interface WTReadView : UIView
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,weak) id<WTReadViewDelegate>delegate;
-(void)cancelSelected;
@end
