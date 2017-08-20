//
//  WTChapterVC.h
//  WTBookReader
//
//  Created by xueban on 2017/8/16.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WTReadModel.h"
#import "WTChapterCell.h"
#import "WTBookCatalogueModel.h"
@protocol WTCatalogViewControllerDelegate;
@interface WTChapterVC : UIViewController
@property (nonatomic,strong) WTReadModel *readModel;
@property (nonatomic,weak) id<WTCatalogViewControllerDelegate>delegate;

@end
