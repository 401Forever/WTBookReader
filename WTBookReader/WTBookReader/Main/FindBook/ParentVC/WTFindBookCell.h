//
//  WTFindBookCell.h
//  WTBookReader
//
//  Created by xueban on 2017/4/22.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTFindBookModel.h"
@interface WTFindBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,strong) WTFindBookModel *model;
@end
