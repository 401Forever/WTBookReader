//
//  WTReadPageViewController.m
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTReadPageViewController.h"

@interface WTReadPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,WTReadViewControllerDelegate>
{
    NSUInteger _chapter;    //当前显示的章节
    NSUInteger _page;       //当前显示的页数
    NSUInteger _chapterChange;  //将要变化的章节
    NSUInteger _pageChange;     //将要变化的页数
    BOOL _isTransition;     //是否开始翻页
}
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏
//@property (nonatomic,strong) LSYMenuView *menuView; //菜单栏
//@property (nonatomic,strong) LSYCatalogViewController *catalogVC;   //侧边栏
@property (nonatomic,strong) UIView * catalogView;  //侧边栏背景
@property (nonatomic,strong) WTReadViewController *readView;   //当前阅读视图
@end

@implementation WTReadPageViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
}

#pragma mark - Private Function
- (void)prepareUI{
    self.dataSource = self;
    self.delegate   = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setViewControllers:@[[self readViewWithChapter:_viewModel.recordModel.chapter page:_viewModel.recordModel.page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

-(WTReadViewController *)readViewWithChapter:(NSUInteger)chapter page:(NSUInteger)page{
    
    
    if (_viewModel.recordModel.chapter != chapter) {
        [self updateReadModelWithChapter:chapter page:page];
        [_viewModel.recordModel.chapterModel updateFont];
    }
    _readView = [[WTReadViewController alloc] init];
    _readView.recordModel = _viewModel.recordModel;
    _readView.content = [_viewModel.tempChapter stringOfPage:page];
//    _readView.content = [_model.chapters[chapter] stringOfPage:page];
    _readView.delegate = self;
    NSLog(@"_readGreate");
    
    return _readView;
}
-(void)updateReadModelWithChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    _chapter = chapter;
    _page = page;
//    _model.record.chapterModel = _model.chapters[chapter];
    _viewModel.recordModel.chapter = chapter;
    _viewModel.recordModel.page = page;
//    _model.font = [NSNumber numberWithFloat:[WTReadConfig shareInstance].fontSize];
//    [LSYReadModel updateLocalModel:_model url:_resourceURL];
}

-(BOOL)prefersStatusBarHidden
{
    return !_showBar;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - WTReadViewControllerDelegate
-(void)readViewEndEdit:(WTReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = YES;
            break;
        }
    }
}
-(void)readViewEditeding:(WTReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = NO;
            break;
        }
    }
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        WTReadViewController *readView = previousViewControllers.firstObject;
        _readView = readView;
        _page = readView.recordModel.page;
        _chapter = readView.recordModel.chapter;
    }
    else{
        [self updateReadModelWithChapter:_chapter page:_page];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    _chapter = _chapterChange;
    _page = _pageChange;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    _pageViewController.view.frame = self.view.frame;
//    _menuView.frame = self.view.frame;
//    _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
//    _catalogVC.view.frame = CGRectMake(0, 0, ViewSize(self.view).width-100, ViewSize(self.view).height);
//    [_catalogVC reload];
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    _pageChange = _page;
    _chapterChange = _chapter;
    
    if (_chapterChange==0 &&_pageChange == 0) {
        return nil;
    }
    if (_pageChange==0) {
        _chapterChange--;
//        _pageChange = _model.chapters[_chapterChange].pageCount-1;
    }
    else{
        _pageChange--;
    }
    
    return [self readViewWithChapter:_chapterChange page:_pageChange];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    _pageChange = _page;
    _chapterChange = _chapter;
//    if (_pageChange == _model.chapters.lastObject.pageCount-1 && _chapterChange == _model.chapters.count-1) {
//        return nil;//最后一个章节的最后一页
//    }
//    if (_pageChange == _model.chapters[_chapterChange].pageCount-1) {
//        _chapterChange++;
//        _pageChange = 0; //当前章节最后一页时，跳章节
//    }
//    else{
        _pageChange++;
//    }
    return [self readViewWithChapter:_chapterChange page:_pageChange];
}

@end
