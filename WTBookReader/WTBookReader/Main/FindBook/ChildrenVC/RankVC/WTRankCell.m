//
//  WTRankCell.m
//  WTBookReader
//
//  Created by xueban on 2017/5/6.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTRankCell.h"

@implementation WTRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    RAC(self.rankTitleLabel, text) = RACObserve(self, model.title);
//    RAC(self.rankArrowView,hidden) = [RACObserve(self, model.collapse) not];
}

@end

@implementation WTRankHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.opaque = YES;
        titleLabel.clipsToBounds = YES;
        titleLabel.layer.masksToBounds = YES;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.backgroundColor = self.contentView.backgroundColor;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        RAC(self.titleLabel, text) = RACObserve(self, sectionModel.sectionTitle);
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(15, 0, self.frame.size.width - 15, self.frame.size.height);
}
@end
