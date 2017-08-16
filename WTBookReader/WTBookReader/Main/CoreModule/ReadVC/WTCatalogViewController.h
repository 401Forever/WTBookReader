//
//  WTCatalogViewController.h
//  WTBookReader
//
//  Created by xueban on 2017/8/16.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WTViewPagerVC.h"
@class WTCatalogViewController;
@protocol WTCatalogViewControllerDelegate <NSObject>
@optional
-(void)catalog:(WTCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page;
@end
@interface WTCatalogViewController : WTViewPagerVC
//@property (nonatomic,strong) WTReadModel *readModel;
@property (nonatomic,weak) id<WTCatalogViewControllerDelegate>catalogDelegate;
@end
