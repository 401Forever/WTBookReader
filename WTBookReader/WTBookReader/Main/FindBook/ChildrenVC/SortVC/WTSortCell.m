//
//  WTSortCell.m
//  WTBookReader
//
//  Created by xueban on 2017/4/25.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTSortCell.h"

@implementation WTSortCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderColor = [UIColor colorWithWhite:200/255.0 alpha:0.4].CGColor;
    self.layer.borderWidth = 0.5;
    
    RAC(self.sortNameLabel, text) = RACObserve(self, model.name);
    RAC(self.bookCountLabel, text) = RACObserve(self, model.bookCount);
}
@end



@implementation WTSortHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
    RAC(self.titleLabel, text) = RACObserve(self, model.sectionTitle);
}
@end
