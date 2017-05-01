//
//  WTSortDetailCell.h
//  WTBookReader
//
//  Created by xueban on 2017/4/27.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTSortDetailModel.h"
@interface WTSortDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookFollowLabel;


@property(nonatomic,strong) WTSortDetailItemModel *model;
@end
