//
//  WTReadPageViewController.h
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTReadViewController.h"
#import "WTReadModel.h"
#import "WTSortDetailModel.h"
#import "WTMenuView.h"
#import "WTCatalogViewController.h"
#import "UIImage+ImageEffects.h"
#import "WTBookDownloader.h"

@interface WTReadPageViewController : UIViewController
@property(nonatomic,strong) WTSortDetailItemModel *bookModel;

@property(nonatomic,strong) WTReadModel *model;
@end
