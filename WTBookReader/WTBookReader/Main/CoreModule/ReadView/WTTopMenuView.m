//
//  WTTopMenuView.m
//  WTBookReader
//
//  Created by xueban on 2017/8/16.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTTopMenuView.h"
#import "WTMenuView.h"
#import "WTReadUtilites.h"
@interface WTTopMenuView ()
@property (nonatomic,strong) UIButton *back;
@property (nonatomic,strong) UIButton *more;
@end
@implementation WTTopMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self addSubview:self.back];
    [self addSubview:self.more];
}
-(void)setState:(BOOL)state
{
    _state = state;
    if (state) {
        [_more setImage:[[UIImage imageNamed:@"sale_discount_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        return;
    }
    [_more setImage:[[UIImage imageNamed:@"sale_discount_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
}
-(UIButton *)back
{
    if (!_back) {
        _back = [WTReadUtilites commonButtonSEL:@selector(backView) target:self];
        [_back setImage:[UIImage imageNamed:@"bg_back_white"] forState:UIControlStateNormal];
    }
    return _back;
}
-(UIButton *)more
{
    if (!_more) {
        _more = [WTReadUtilites commonButtonSEL:@selector(moreOption) target:self];
        [_more setImage:[[UIImage imageNamed:@"sale_discount_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
        [_more setImageEdgeInsets:UIEdgeInsetsMake(7.5, 12.5, 7.5, 12.5)];
    }
    return _more;
}
-(void)moreOption
{
    if ([self.delegate respondsToSelector:@selector(menuViewMark:)]) {
        [self.delegate menuViewMark:self];
    }
}
-(void)backView
{
    if ([self.delegate respondsToSelector:@selector(menuViewClickReturnBtn:)]) {
        [self.delegate menuViewClickReturnBtn:self];
    }
//    [[WTReadUtilites getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _back.frame = CGRectMake(0, 24, 40, 40);
    _more.frame = CGRectMake(ViewSize(self).width-50, 24, 40, 40);
}
@end
