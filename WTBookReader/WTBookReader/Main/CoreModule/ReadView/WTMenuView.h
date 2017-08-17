//
//  WTMenuView.h
//  WTBookReader
//
//  Created by xueban on 2017/8/16.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRecordModel.h"
#import "WTTopMenuView.h"
#import "WTBottomMenuView.h"
@class WTMenuView;
@class WTBottomMenuView;
@protocol WTMenuViewDelegate <NSObject>
@optional
-(void)menuViewDidHidden:(WTMenuView *)menu;
-(void)menuViewDidAppear:(WTMenuView *)menu;
-(void)menuViewMark:(WTTopMenuView *)topMenu;
-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page;

-(void)menuViewFontSize:(WTBottomMenuView *)bottomMenu;
-(void)menuViewInvokeCatalog:(WTBottomMenuView *)bottomMenu;
-(void)menuViewClickDownloadBtn:(WTBottomMenuView *)bottomMenu;

@end
@interface WTMenuView : UIView
@property (nonatomic,weak) id<WTMenuViewDelegate> delegate;
@property (nonatomic,strong) WTRecordModel *recordModel;
@property (nonatomic,strong) WTTopMenuView *topView;
@property (nonatomic,strong) WTBottomMenuView *bottomView;
-(void)showAnimation:(BOOL)animation;
-(void)hiddenAnimation:(BOOL)animation;
@end
