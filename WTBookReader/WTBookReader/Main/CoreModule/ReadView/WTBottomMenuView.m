//
//  WTBottomMenuView.m
//  WTBookReader
//
//  Created by xueban on 2017/8/16.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTBottomMenuView.h"
#import "WTReadUtilites.h"
#import "WTMenuView.h"
#import "WTReadConfig.h"

#define MinFontSize 11.0f
#define MaxFontSize 20.0f
#define DistanceFromTopGuiden(view) (view.frame.origin.y + view.frame.size.height)
#define DistanceFromLeftGuiden(view) (view.frame.origin.x + view.frame.size.width)

@interface WTBottomMenuView ()
@property (nonatomic,strong) WTReadProgressView *progressView;
@property (nonatomic,strong) WTThemeView *themeView;
@property (nonatomic,strong) UIButton *minSpacing;
@property (nonatomic,strong) UIButton *mediuSpacing;
@property (nonatomic,strong) UIButton *maxSpacing;
@property (nonatomic,strong) UIButton *catalog;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UIButton *lastChapter;
@property (nonatomic,strong) UIButton *nextChapter;
@property (nonatomic,strong) UIButton *increaseFont;
@property (nonatomic,strong) UIButton *decreaseFont;
@property (nonatomic,strong) UILabel *fontLabel;

@property(nonatomic,strong)  UIButton *downloadBtn;
@property(nonatomic,strong)  UILabel *downloadProgressLabel;
@end
@implementation WTBottomMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self addSubview:self.slider];
    [self addSubview:self.catalog];
    [self addSubview:self.downloadBtn];
    [self addSubview:self.downloadProgressLabel];
    [self addSubview:self.progressView];
    [self addSubview:self.lastChapter];
    [self addSubview:self.nextChapter];
    [self addSubview:self.increaseFont];
    [self addSubview:self.decreaseFont];
    [self addSubview:self.fontLabel];
    [self addSubview:self.themeView];
    [self addObserver:self forKeyPath:@"readModel.chapter" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"readModel.page" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"readModel.downloadProgressText" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"readModel.isDownloading" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[WTReadConfig shareInstance] addObserver:self forKeyPath:@"fontSize" options:NSKeyValueObservingOptionNew context:NULL];
}
-(UIButton *)catalog
{
    if (!_catalog) {
        _catalog = [WTReadUtilites commonButtonSEL:@selector(showCatalog) target:self];
        [_catalog setImage:[UIImage imageNamed:@"reader_cover"] forState:UIControlStateNormal];
    }
    return _catalog;
}

- (UIButton *)downloadBtn{
    if (!_downloadBtn) {
        _downloadBtn = [WTReadUtilites commonButtonSEL:@selector(downloadBtnClick:) target:self];
        _downloadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _downloadBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _downloadBtn.layer.borderWidth = 1;
        [_downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downloadBtn setTitle:@"下载本书" forState:UIControlStateNormal];
    }
    return _downloadBtn;
}

- (UILabel *)downloadProgressLabel{
    if (!_downloadProgressLabel) {
        _downloadProgressLabel = [[UILabel alloc] init];
        _downloadProgressLabel.text = self.readModel.downloadProgressText;
        _downloadProgressLabel.textColor = [UIColor whiteColor];
        _downloadProgressLabel.font = [UIFont systemFontOfSize:14];
    }
    return _downloadProgressLabel;
}

-(WTReadProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[WTReadProgressView alloc] init];
        _progressView.hidden = YES;
        
    }
    return _progressView;
}
-(UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 100;
        _slider.minimumTrackTintColor = RGBA(227, 0, 0, 1);
        _slider.maximumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:[self thumbImage] forState:UIControlStateNormal];
        [_slider setThumbImage:[self thumbImage] forState:UIControlStateHighlighted];
        [_slider addTarget:self action:@selector(changeMsg:) forControlEvents:UIControlEventValueChanged];
        [_slider addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
    }
    return _slider;
}
-(UIButton *)nextChapter
{
    if (!_nextChapter) {
        _nextChapter = [WTReadUtilites commonButtonSEL:@selector(jumpChapter:) target:self];
        [_nextChapter setTitle:@"下一章" forState:UIControlStateNormal];
    }
    return _nextChapter;
}
-(UIButton *)lastChapter
{
    if (!_lastChapter) {
        _lastChapter = [WTReadUtilites commonButtonSEL:@selector(jumpChapter:) target:self];
        [_lastChapter setTitle:@"上一章" forState:UIControlStateNormal];
    }
    return _lastChapter;
}
-(UIButton *)increaseFont
{
    if (!_increaseFont) {
        _increaseFont = [WTReadUtilites commonButtonSEL:@selector(changeFont:) target:self];
        [_increaseFont setTitle:@"A+" forState:UIControlStateNormal];
        [_increaseFont.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _increaseFont.layer.borderWidth = 1;
        _increaseFont.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _increaseFont;
}
-(UIButton *)decreaseFont
{
    if (!_decreaseFont) {
        _decreaseFont = [WTReadUtilites commonButtonSEL:@selector(changeFont:) target:self];
        [_decreaseFont setTitle:@"A-" forState:UIControlStateNormal];
        [_decreaseFont.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _decreaseFont.layer.borderWidth = 1;
        _decreaseFont.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _decreaseFont;
}
-(UILabel *)fontLabel
{
    if (!_fontLabel) {
        _fontLabel = [[UILabel alloc] init];
        _fontLabel.font = [UIFont systemFontOfSize:14];
        _fontLabel.textColor = [UIColor whiteColor];
        _fontLabel.textAlignment = NSTextAlignmentCenter;
        _fontLabel.text = [NSString stringWithFormat:@"%d",(int)[WTReadConfig shareInstance].fontSize];
    }
    return _fontLabel;
}
-(WTThemeView *)themeView
{
    if (!_themeView) {
        _themeView = [[WTThemeView alloc] init];
    }
    return _themeView;
}
#pragma mark - Button Click
-(void)jumpChapter:(UIButton *)sender
{
    if (sender == _nextChapter) {
        if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
            [self.delegate menuViewJumpChapter:(_readModel.chapter == _readModel.chapterCount-1)?_readModel.chapter:_readModel.chapter+1 page:0];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
            [self.delegate menuViewJumpChapter:_readModel.chapter?_readModel.chapter-1:0 page:0];
        }
        
    }
}
-(void)changeFont:(UIButton *)sender
{
    
    if (sender == _increaseFont) {
        
        if (floor([WTReadConfig shareInstance].fontSize) == floor(MaxFontSize)) {
            return;
        }
        [WTReadConfig shareInstance].fontSize++;
    }
    else{
        if (floor([WTReadConfig shareInstance].fontSize) == floor(MinFontSize)){
            return;
        }
        [WTReadConfig shareInstance].fontSize--;
    }
    
    if ([self.delegate respondsToSelector:@selector(menuViewFontSize:)]) {
        [self.delegate menuViewFontSize:self];
    }
}
#pragma mark showMsg

-(void)changeMsg:(UISlider *)sender
{
    NSUInteger page =ceil((_readModel.chapterModel.pageCount-1)*sender.value/100.00);
    if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
        [self.delegate menuViewJumpChapter:_readModel.chapter page:page];
    }
    
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"readModel.chapter"]
        || [keyPath isEqualToString:@"readModel.page"]
        || [keyPath isEqualToString:@"readModel.downloadProgressText"]
        || [keyPath isEqualToString:@"readModel.isDownloading"]) {
        
        _slider.value = _readModel.page/((float)(_readModel.chapterModel.pageCount-1))*100;
        [_progressView title:_readModel.chapterModel.title progress:[NSString stringWithFormat:@"%.1f%%",_slider.value]];
        _downloadProgressLabel.text = _readModel.downloadProgressText;
        _downloadBtn.enabled = !_readModel.isDownloading;
    }
    else if ([keyPath isEqualToString:@"fontSize"]){
        _fontLabel.text = [NSString stringWithFormat:@"%d",(int)[WTReadConfig shareInstance].fontSize];
    }
    else{
        if (_slider.state == UIControlStateNormal) {
            _progressView.hidden = YES;
        }
        else if(_slider.state == UIControlStateHighlighted){
            _progressView.hidden = NO;
        }
    }
    
}
-(UIImage *)thumbImage
{
    CGRect rect = CGRectMake(0, 0, 15,15);
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5;
    [path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:7.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    {
        [[UIColor whiteColor] setFill];
        [path fill];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
}
-(void)showCatalog
{
    if ([self.delegate respondsToSelector:@selector(menuViewInvokeCatalog:)]) {
        [self.delegate menuViewInvokeCatalog:self];
    }
}

- (void)downloadBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(menuViewClickDownloadBtn:)]) {
        [self.delegate menuViewClickDownloadBtn:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _slider.frame = CGRectMake(50, 20, ViewSize(self).width-100, 30);
    _lastChapter.frame = CGRectMake(5, 20, 40, 30);
    _nextChapter.frame = CGRectMake(DistanceFromLeftGuiden(_slider)+5, 20, 40, 30);
    _decreaseFont.frame = CGRectMake(10, DistanceFromTopGuiden(_slider)+10, (ViewSize(self).width-20)/3, 30);
    _fontLabel.frame = CGRectMake(DistanceFromLeftGuiden(_decreaseFont), DistanceFromTopGuiden(_slider)+10, (ViewSize(self).width-20)/3,  30);
    _increaseFont.frame = CGRectMake(DistanceFromLeftGuiden(_fontLabel), DistanceFromTopGuiden(_slider)+10,  (ViewSize(self).width-20)/3, 30);
    _themeView.frame = CGRectMake(0, DistanceFromTopGuiden(_increaseFont)+10, ViewSize(self).width, 40);
    _catalog.frame = CGRectMake(10, DistanceFromTopGuiden(_themeView) + 15, 30, 30);
    _downloadBtn.frame = CGRectMake(ViewSize(self).width - 80 - 10, DistanceFromTopGuiden(_themeView) + 15, 80, 30);
    _downloadProgressLabel.frame = CGRectMake(DistanceFromLeftGuiden(_catalog) + 10, DistanceFromTopGuiden(_themeView) + 15, 80, 30);
    _progressView.frame = CGRectMake(60, -60, ViewSize(self).width-120, 50);
    
}
-(void)dealloc
{
    [_slider removeObserver:self forKeyPath:@"highlighted"];
    [self removeObserver:self forKeyPath:@"readModel.chapter"];
    [self removeObserver:self forKeyPath:@"readModel.page"];
    [self removeObserver:self forKeyPath:@"readModel.downloadProgressText"];
    [self removeObserver:self forKeyPath:@"readModel.isDownloading"];
    [[WTReadConfig shareInstance] removeObserver:self forKeyPath:@"fontSize"];
}
@end
@interface WTThemeView ()
@property (nonatomic,strong) UIView *theme1;
@property (nonatomic,strong) UIView *theme2;
@property (nonatomic,strong) UIView *theme3;
@end
@implementation WTThemeView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup{
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.theme1];
    [self addSubview:self.theme2];
    [self addSubview:self.theme3];
}
-(UIView *)theme1
{
    if (!_theme1) {
        _theme1 = [[UIView alloc] init];
        _theme1.backgroundColor = [UIColor whiteColor];
        [_theme1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme1;
}
-(UIView *)theme2
{
    if (!_theme2) {
        _theme2 = [[UIView alloc] init];
        _theme2.backgroundColor = RGBA(188, 178, 190, 1);
        [_theme2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme2;
}
-(UIView *)theme3
{
    if (!_theme3) {
        _theme3 = [[UIView alloc] init];
        _theme3.backgroundColor = RGBA(190, 182, 162, 1);
        [_theme3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme3;
}
-(void)changeTheme:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WTThemeNotification object:tap.view.backgroundColor];
}
-(void)layoutSubviews
{
    CGFloat spacing = (ViewSize(self).width-40*3)/4;
    _theme1.frame = CGRectMake(spacing, 0, 40, 40);
    _theme2.frame = CGRectMake(DistanceFromLeftGuiden(_theme1)+spacing, 0, 40, 40);
    _theme3.frame = CGRectMake(DistanceFromLeftGuiden(_theme2)+spacing, 0, 40, 40);
}
@end
@interface WTReadProgressView ()
@property (nonatomic,strong) UILabel *label;
@end
@implementation WTReadProgressView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        [self addSubview:self.label];
    }
    return self;
}
-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:[WTReadConfig shareInstance].fontSize];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
    }
    return _label;
}
-(void)title:(NSString *)title progress:(NSString *)progress
{
    _label.text = [NSString stringWithFormat:@"%@\n%@",title,progress];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = self.bounds;
}
@end
