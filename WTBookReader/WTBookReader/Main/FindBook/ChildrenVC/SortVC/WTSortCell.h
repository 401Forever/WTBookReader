//
//  WTSortCell.h
//  WTBookReader
//
//  Created by xueban on 2017/4/25.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTSortModel.h"

@interface WTSortCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *sortNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookCountLabel;

@property(nonatomic,strong) WTSortItemModel *model;
@end


@interface WTSortHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,strong) WTSortDataSource *model;
@end
