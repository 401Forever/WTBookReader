//
//  WTChapterCell.m
//  WTBookReader
//
//  Created by liyuwen on 2017/8/20.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTChapterCell.h"
@interface WTChapterCell()
@property (nonatomic, strong) UIView *coverView;
@end
@implementation WTChapterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.1];
        [self.contentView addSubview:_coverView];
        self.selectedView = NO;
    }
    return self;
}

- (void)setSelectedView:(BOOL)selectedView{
    _selectedView = selectedView;
    _coverView.hidden = !selectedView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _coverView.frame = self.bounds;
}
@end
