//
//  WTViewPagerVC.h
//  WTBookReader
//
//  Created by xueban on 2017/8/16.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTViewPagerVC;
#pragma mark View Pager Delegate
@protocol  WTViewPagerVCDelegate <NSObject>
@optional
/**
 控制器结束滑动时调用该方法，返回当前显示的视图控制器
 */
-(void)viewPagerViewController:(WTViewPagerVC *)viewPager didFinishScrollWithCurrentViewController:(UIViewController *)viewController;
/**
 控制器将要开始滑动时调用该方法，返回当前将要滑动的视图控制器
 */
-(void)viewPagerViewController:(WTViewPagerVC *)viewPager willScrollerWithCurrentViewController:(UIViewController *)ViewController;

@end

#pragma mark View Pager DataSource
@protocol WTViewPagerVCDataSource <NSObject>

@required
/**
 设置返回需要滑动的控制器数量
 */
-(NSInteger)numberOfViewControllersInViewPager:(WTViewPagerVC *)viewPager;
/**
 用来设置当前索引下返回的控制器
 */
-(UIViewController *)viewPager:(WTViewPagerVC *)viewPager indexOfViewControllers:(NSInteger)index;
/**
 给每一个控制器设置一个标题
 */
-(NSString *)viewPager:(WTViewPagerVC *)viewPager titleWithIndexOfViewControllers:(NSInteger)index;

@optional
/**
 设置控制器标题按钮的样式，如果不设置将使用默认的样式，选择为红色，不选中为黑色带有选中下划线
 */
-(UIButton *)viewPager:(WTViewPagerVC *)viewPager titleButtonStyle:(NSInteger)index;
/**
 设置控制器上面标题的高度
 */
-(CGFloat)heightForTitleOfViewPager:(WTViewPagerVC *)viewPager;
/**
 如果有需要还要在控制器标题顶上添加视图。用来设置控制器标题上面的头部视图
 */
-(UIView *)headerViewForInViewPager:(WTViewPagerVC *)viewPager;
/**
 设置头部视图的高度
 */
-(CGFloat)heightForHeaderOfViewPager:(WTViewPagerVC *)viewPager;
@end

@interface WTViewPagerVC : UIViewController
@property (nonatomic,weak) id<WTViewPagerVCDataSource>dataSource;
@property (nonatomic,weak) id<WTViewPagerVCDelegate>delegate;
@property (nonatomic) BOOL forbidGesture;
/**
 用来刷新ViewPager
 */
-(void)reload;
@end


#pragma mark View Controller Title Button

@interface WTViewPagerTitleButton : UIButton

@end
