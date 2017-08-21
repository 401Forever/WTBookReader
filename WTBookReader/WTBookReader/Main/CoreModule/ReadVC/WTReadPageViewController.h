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
#import "WTBookCache.h"
#import "WTStoredBookModel.h"

@interface WTReadPageViewController : UIViewController
/** 列表传入的书籍信息 */
@property(nonatomic,strong) WTSortDetailItemModel *bookModel;

@end
