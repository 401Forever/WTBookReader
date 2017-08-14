//
//  WTReadViewController.h
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTReadParser.h"
#import "WTReadConfig.h"
#import "WTReadView.h"

@class WTReadViewController;
@protocol WTReadViewControllerDelegate <NSObject>
-(void)readViewEditeding:(WTReadViewController *)readView;
-(void)readViewEndEdit:(WTReadViewController *)readView;
@end

@interface WTReadViewController : UIViewController
@property (nonatomic,strong) NSString *content; //显示的内容
//@property (nonatomic,strong) LSYRecordModel *recordModel;   //阅读进度
@property (nonatomic,strong) WTReadView *readView;
@property (nonatomic,weak) id<WTReadViewControllerDelegate>delegate;
@end
