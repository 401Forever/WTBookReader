//
//  WTReadViewController.m
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTReadViewController.h"


@interface WTReadViewController ()<WTReadViewDelegate>

@end

@implementation WTReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self.view setBackgroundColor:[WTReadConfig shareInstance].theme];
    [self.view addSubview:self.readView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:WTThemeNotification object:nil];
}
-(void)changeTheme:(NSNotification *)no
{
    NSArray *fontColors = @[ReadConfig_FontColor_1,ReadConfig_FontColor_2,ReadConfig_FontColor_3,ReadConfig_FontColor_4];
    [WTReadConfig shareInstance].theme = no.object[@"BackgroupColor"];
    [WTReadConfig shareInstance].fontColor = fontColors[[no.object[@"FontColorIndex"] integerValue]];
    [self.view setBackgroundColor:[WTReadConfig shareInstance].theme];
    [self reloadReadView];
}

- (void)reloadReadView{
    WTReadConfig *config = [WTReadConfig shareInstance];
    _readView.frameRef = [WTReadParser parserContent:_content config:config bouds:CGRectMake(0,0, _readView.frame.size.width, _readView.frame.size.height)];
    [_readView setNeedsDisplay];
}

-(WTReadView *)readView
{
    if (!_readView) {
        _readView = [[WTReadView alloc] initWithFrame:CGRectMake(LeftSpacing,TopSpacing, self.view.frame.size.width-LeftSpacing-RightSpacing, self.view.frame.size.height-TopSpacing-BottomSpacing)];
        WTReadConfig *config = [WTReadConfig shareInstance];
        _readView.frameRef = [WTReadParser parserContent:_content config:config bouds:CGRectMake(0,0, _readView.frame.size.width, _readView.frame.size.height)];
        _readView.content = _content;
        _readView.delegate = self;
    }
    return _readView;
}
-(void)readViewEditeding:(WTReadView *)readView
{
    if ([self.delegate respondsToSelector:@selector(readViewEditeding:)]) {
        [self.delegate readViewEditeding:self];
    }
}
-(void)readViewEndEdit:(WTReadView *)readView
{
    if ([self.delegate respondsToSelector:@selector(readViewEndEdit:)]) {
        [self.delegate readViewEndEdit:self];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
