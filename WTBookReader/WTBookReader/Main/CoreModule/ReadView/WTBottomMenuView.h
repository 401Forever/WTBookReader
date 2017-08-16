//
//  WTBottomMenuView.h
//  WTBookReader
//
//  Created by xueban on 2017/8/16.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WTRecordModel.h"
@protocol WTMenuViewDelegate;

@interface WTBottomMenuView : UIView
@property (nonatomic,weak) id<WTMenuViewDelegate>delegate;
@property (nonatomic,strong) WTRecordModel *readModel;
@end

@interface WTThemeView : UIView

@end

@interface WTReadProgressView : UIView
-(void)title:(NSString *)title progress:(NSString *)progress;
@end
