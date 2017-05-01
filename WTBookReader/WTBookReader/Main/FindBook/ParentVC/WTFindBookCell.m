//
//  WTFindBookCell.m
//  WTBookReader
//
//  Created by xueban on 2017/4/22.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTFindBookCell.h"

@implementation WTFindBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    RAC(self.iconView, image) = RACObserve(self, model.image);
    RAC(self.titleLabel, text) = RACObserve(self, model.title);
}

@end
