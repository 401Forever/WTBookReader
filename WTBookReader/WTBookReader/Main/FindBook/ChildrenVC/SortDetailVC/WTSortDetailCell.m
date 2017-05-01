//
//  WTSortDetailCell.m
//  WTBookReader
//
//  Created by xueban on 2017/4/27.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTSortDetailCell.h"

@implementation WTSortDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    RAC(self.bookTitleLabel, text) = RACObserve(self, model.title);
    RAC(self.bookAuthorLabel, text) = RACObserve(self, model.authorAndMajorCate);
    RAC(self.bookDescriptionLabel, text) = RACObserve(self, model.shortIntro);
    RAC(self.bookFollowLabel, text) = RACObserve(self, model.latelyFollowerAndretentionRatio);
}
@end
