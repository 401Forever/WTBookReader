//
//  WTRankCell.h
//  WTBookReader
//
//  Created by xueban on 2017/5/6.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRankModel.h"
@interface WTRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rankArrowView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankTitleLabel;
@property(nonatomic,strong) WTRankItemModel *model;
@end


@interface WTRankHeaderView : UITableViewHeaderFooterView
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,strong) WTRankDataSource *sectionModel;
@end
