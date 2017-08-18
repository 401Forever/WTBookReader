//
//  WTMenuView.m
//  WTBookReader
//
//  Created by xueban on 2017/8/16.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTMenuView.h"

#import "WTBottomMenuView.h"
#define AnimationDelay 0.3f
#define TopViewHeight 64.0f
#define BottomViewHeight 200.0f
@interface WTMenuView ()<WTMenuViewDelegate>

@end
@implementation WTMenuView
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
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)]];
}
-(WTTopMenuView *)topView
{
    if (!_topView) {
        _topView = [[WTTopMenuView alloc] init];
        _topView.delegate = self;
    }
    return _topView;
}
-(WTBottomMenuView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[WTBottomMenuView alloc] init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
-(void)setRecordModel:(WTRecordModel *)recordModel
{
    _recordModel = recordModel;
    _bottomView.readModel = recordModel;
}
#pragma mark - WTMenuViewDelegate

-(void)menuViewInvokeCatalog:(WTBottomMenuView *)bottomMenu
{
    if ([self.delegate respondsToSelector:@selector(menuViewInvokeCatalog:)]) {
        [self.delegate menuViewInvokeCatalog:bottomMenu];
    }
}

- (void)menuViewClickDownloadBtn:(WTBottomMenuView *)bottomMenu{
    if ([self.delegate respondsToSelector:@selector(menuViewClickDownloadBtn:)]) {
        [self.delegate menuViewClickDownloadBtn:bottomMenu];
    }
    
}

-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
        [self.delegate menuViewJumpChapter:chapter page:page];
    }
}
-(void)menuViewFontSize:(WTBottomMenuView *)bottomMenu
{
    if ([self.delegate respondsToSelector:@selector(menuViewFontSize:)]) {
        [self.delegate menuViewFontSize:bottomMenu];
    }
}
-(void)menuViewMark:(WTTopMenuView *)topMenu
{
    if ([self.delegate respondsToSelector:@selector(menuViewMark:)]) {
        [self.delegate menuViewMark:topMenu];
    }
}

- (void)menuViewClickReturnBtn:(WTTopMenuView *)topMenu{
    if ([self.delegate respondsToSelector:@selector(menuViewClickReturnBtn:)]) {
        [self.delegate menuViewClickReturnBtn:topMenu];
    }
}
#pragma mark -
-(void)hiddenSelf
{
    [self hiddenAnimation:YES];
}
-(void)showAnimation:(BOOL)animation
{
    self.hidden = NO;
    [UIView animateWithDuration:animation?AnimationDelay:0 animations:^{
        _topView.frame = CGRectMake(0, 0, ViewSize(self).width, TopViewHeight);
        _bottomView.frame = CGRectMake(0, ViewSize(self).height-BottomViewHeight, ViewSize(self).width,BottomViewHeight);
    } completion:^(BOOL finished) {
        
    }];
    if ([self.delegate respondsToSelector:@selector(menuViewDidAppear:)]) {
        [self.delegate menuViewDidAppear:self];
    }
}
-(void)hiddenAnimation:(BOOL)animation
{
    [UIView animateWithDuration:animation?AnimationDelay:0 animations:^{
        _topView.frame = CGRectMake(0, -TopViewHeight, ViewSize(self).width, TopViewHeight);
        _bottomView.frame = CGRectMake(0, ViewSize(self).height, ViewSize(self).width,BottomViewHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    if ([self.delegate respondsToSelector:@selector(menuViewDidHidden:)]) {
        [self.delegate menuViewDidHidden:self];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, -TopViewHeight, ViewSize(self).width,TopViewHeight);
    _bottomView.frame = CGRectMake(0, ViewSize(self).height, ViewSize(self).width,BottomViewHeight);
}
@end
