//
//  WTReadPageViewController.m
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTReadPageViewController.h"
#define AnimationDelay 0.3

@interface WTReadPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,WTMenuViewDelegate,UIGestureRecognizerDelegate,WTCatalogViewControllerDelegate,WTReadViewControllerDelegate>
{
    NSUInteger _chapter;    //当前显示的章节
    NSUInteger _page;       //当前显示的页数
    NSUInteger _chapterChange;  //将要变化的章节
    NSUInteger _pageChange;     //将要变化的页数
    BOOL _isTransition;     //是否开始翻页
}
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏
@property (nonatomic,strong) WTMenuView *menuView; //菜单栏
@property (nonatomic,strong) WTCatalogViewController *catalogVC;   //侧边栏
@property (nonatomic,strong) UIView * catalogView;  //侧边栏背景
@property (nonatomic,strong) WTReadViewController *readView;   //当前阅读视图
@property(nonatomic,strong) UITapGestureRecognizer *tapGesture; //展示菜单的手势

@property(nonatomic,strong) WTReadModel *model;
@end

@implementation WTReadPageViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
}


#pragma mark - Private Function
- (void)prepareUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:self.pageViewController];
    //    [self.pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)];
        self.tapGesture = tap;
        tap.delegate = self;
        tap;
    })];
    [self.view addSubview:self.menuView];
    
    [self addChildViewController:self.catalogVC];
    [self.view addSubview:self.catalogView];
    [self.catalogView addSubview:self.catalogVC.view];
    //添加笔记
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotes:) name:WTNoteNotification object:nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)setupUI{
    [self.pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.menuView.recordModel = _model.record;
    self.catalogVC.readModel = _model;
}

-(void)catalogShowState:(BOOL)show
{
    show?({
        _catalogView.hidden = !show;
        [UIView animateWithDuration:AnimationDelay animations:^{
            _catalogView.frame = CGRectMake(0, 0,2*ViewSize(self.view).width, ViewSize(self.view).height);
            
        } completion:^(BOOL finished) {
            [_catalogView insertSubview:[[UIImageView alloc] initWithImage:[self blurredSnapshot]] atIndex:0];
        }];
    }):({
        if ([_catalogView.subviews.firstObject isKindOfClass:[UIImageView class]]) {
            [_catalogView.subviews.firstObject removeFromSuperview];
        }
        [UIView animateWithDuration:AnimationDelay animations:^{
            _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
        } completion:^(BOOL finished) {
            _catalogView.hidden = !show;
            
        }];
    });
}



- (UIImage *)blurredSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 1.0f);
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}


-(WTReadViewController *)readViewWithChapter:(NSUInteger)chapter page:(NSUInteger)page{
    
    
    if (_model.record.chapter != chapter) {
        [self updateReadModelWithChapter:chapter page:page];
        [_model.record.chapterModel updateFont];
    }
    _readView = [[WTReadViewController alloc] init];
    _readView.content = [_model.chapters[chapter] stringOfPage:page];
    _readView.delegate = self;
    return _readView;
}
-(void)updateReadModelWithChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    _chapter = chapter;
    _page = page;
    _model.record.chapterModel = _model.chapters[chapter];
    _model.record.chapter = chapter;
    _model.record.page = page;
    _model.font = [NSNumber numberWithFloat:[WTReadConfig shareInstance].fontSize];
    //    [WTReadModel updateLocalModel:_model url:_resourceURL];
}

- (void)fetchChapterWithModel:(WTChapterModel *)chapterModel //需要获取的章节信息
                       isNext:(BOOL)isNext //是否为下一章节
                targetChapter:(NSUInteger)targetChapter{ // 目标章节索引
    @weakify(self);
    [self showProgressHUD];
    self.tapGesture.enabled = NO;
    RACTuple *chapter = RACTuplePack(chapterModel);
    [[[WTBookDownloader downloader].fetchBookChapterData execute:chapter]
     subscribeNext:^(WTBookChapterContentModel *chapter) {
         @strongify(self);
         chapterModel.isDownloadChapter = YES;
         chapterModel.content = chapter.body;
         isNext ? (_model.record.page = 0 ) : (_model.record.page = chapterModel.pageArray.count - 1);
//         isNext ? (_model.record.chapter = targetChapter + 1 ) : (_model.record.chapter = targetChapter - 1);
         _model.record.chapter = targetChapter;
         _page = _model.record.page;
         _chapter = _model.record.chapter;
         [self.pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
         self.tapGesture.enabled = YES;
         [self hideProgressHUD];
     }];
}

#pragma mark - Target Action

-(void)showToolMenu
{
    BOOL isMarked = FALSE;
    
    WTRecordModel *recordModel = _model.record;
    WTChapterModel *chapterModel = recordModel.chapterModel;
    
    NSUInteger startIndex = [chapterModel.pageArray[recordModel.page] integerValue];
    
    NSUInteger endIndex = NSUIntegerMax;
    NSUInteger chapter = recordModel.chapter;
    
    if (recordModel.page < chapterModel.pageCount - 1) {
        endIndex = [chapterModel.pageArray[recordModel.page + 1] integerValue];
    }
    
    for (int i = 0; i < _model.marks.count; i++) {
        WTMarkModel *markModel = _model.marks[i];
        if (markModel.chapter == chapter && markModel.location >= startIndex && markModel.location < endIndex) {
            isMarked = YES;
            break;
        }
    }
    
    isMarked?(_menuView.topView.state=1): (_menuView.topView.state=0);
    [self.menuView showAnimation:YES];
    
}

-(void)addNotes:(NSNotification *)no
{
    WTNoteModel *noteModel = no.object;
    WTChapterModel *chapterModel = _model.record.chapterModel;
    noteModel.location += [chapterModel.pageArray[_model.record.page] integerValue];
    noteModel.chapter = _model.record.chapter;
    noteModel.recordModel = [_model.record copy];
    [[_model mutableArrayValueForKey:@"notes"] addObject:noteModel];    //这样写才能KVO数组变化
    [WTReadUtilites showAlertTitle:nil content:@"保存笔记成功"];
}

-(void)hiddenCatalog
{
    [self catalogShowState:NO];
}

#pragma mark - CatalogViewController Delegate
-(void)catalog:(WTCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    if (!_model.chapters[chapter].isDownloadChapter) {
        [self fetchChapterWithModel:_model.chapters[chapter] isNext:YES targetChapter:chapter];
        return;
    }

    [self.pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
    [self hiddenCatalog];
    
}

#pragma mark -  UIGestureRecognizer Delegate
//解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - Menu View Delegate
-(void)menuViewDidHidden:(WTMenuView *)menu
{
    _showBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)menuViewDidAppear:(WTMenuView *)menu
{
    _showBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)menuViewInvokeCatalog:(WTBottomMenuView *)bottomMenu
{
    [_menuView hiddenAnimation:NO];
    [self catalogShowState:YES];
    
}

- (void)menuViewClickDownloadBtn:(WTBottomMenuView *)bottomMenu{
    bottomMenu.readModel.isDownloading = YES;
    NSLog(@"点击下载按钮");
}

-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    [self.pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
}
-(void)menuViewFontSize:(WTBottomMenuView *)bottomMenu
{
    
    [_model.record.chapterModel updateFont];
    
//    for (int i = 0; i < _model.chapters.count; i++) {
//        [_model.chapters[i] updateFont];
//    }
    
    [self.pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateReadModelWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page];
}

-(void)menuViewMark:(WTTopMenuView *)topMenu
{
    
    BOOL isMarked = FALSE;
    
    WTRecordModel *recordModel = _model.record;
    WTChapterModel *chapterModel = recordModel.chapterModel;
    
    NSUInteger startIndex = [chapterModel.pageArray[recordModel.page] integerValue];
    
    NSUInteger endIndex = NSUIntegerMax;
    
    if (recordModel.page < chapterModel.pageCount - 1) {
        endIndex = [chapterModel.pageArray[recordModel.page + 1] integerValue];
    }
    
    NSMutableArray *markedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _model.marks.count; i++) {
        WTMarkModel *markModel = _model.marks[i];
        if (markModel.location >= startIndex && markModel.location <= endIndex) {
            isMarked = YES;
            [markedArray addObject:markModel];
        }
    }
    
    if (isMarked) {
        [[_model mutableArrayValueForKey:@"marks"] removeObjectsInArray:markedArray];
    } else {
        WTRecordModel *recordModel = _model.record;
        WTMarkModel *markModel = [[WTMarkModel alloc] init];
        markModel.date = [NSDate date];
        markModel.location = [recordModel.chapterModel.pageArray[recordModel.page] integerValue];
        markModel.length = 0;
        markModel.chapter = recordModel.chapter;
        markModel.recordModel = [_model.record copy];
        [[_model mutableArrayValueForKey:@"marks"] addObject:markModel];
    }
    
    _menuView.topView.state = !isMarked;
}

- (void)menuViewClickReturnBtn:(WTTopMenuView *)topMenu{
    WTStoredBookModel *model = [WTStoredBookModel objectsWhere:@"ID = '%@'" args:(__bridge struct __va_list_tag *)(self.bookModel._id)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WTReadViewControllerDelegate
-(void)readViewEndEdit:(WTReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = YES;
            break;
        }
    }
}
-(void)readViewEditeding:(WTReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
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
    
    _pageViewController.view.frame = self.view.frame;
    _menuView.frame = self.view.frame;
    _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
    _catalogVC.view.frame = CGRectMake(0, 0, ViewSize(self.view).width-100, ViewSize(self.view).height);
    [_catalogVC reload];
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    _pageChange = _page;
    _chapterChange = _chapter;
    
    if (_chapterChange==0 &&_pageChange == 0) {
        [MBProgressHUD showTextMessageInWindow:@"当前已经是第一章节" hideAfterDelay:1.0];
        return nil;
    }
    
    if (_pageChange==0) {
        _chapterChange--;
        _pageChange = _model.chapters[_chapterChange].pageCount-1;
    }
    else{
        _pageChange--;
    }
    
    if (!_model.chapters[_chapterChange].isDownloadChapter) {
        [self fetchChapterWithModel:_model.chapters[_chapterChange] isNext:NO targetChapter:_chapterChange];
        return nil;
    }
    return [self readViewWithChapter:_chapterChange page:_pageChange];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    _pageChange = _page;
    _chapterChange = _chapter;
    if (_pageChange == _model.chapters.lastObject.pageCount-1 && _chapterChange == _model.chapters.count-1) {
        [MBProgressHUD showTextMessageInWindow:@"当前已经是最后章节" hideAfterDelay:1.0];
        return nil;//最后一个章节的最后一页
    }
    if (_pageChange == _model.chapters[_chapterChange].pageCount-1) {
        _chapterChange++;
        _pageChange = 0; //当前章节最后一页时，跳章节
    }
    else{
        _pageChange++;
    }
    
    if (!_model.chapters[_chapterChange].isDownloadChapter) {
        [self fetchChapterWithModel:_model.chapters[_chapterChange] isNext:YES targetChapter:_chapterChange];
        return nil;
    }
    
    return [self readViewWithChapter:_chapterChange page:_pageChange];
}
#pragma mark - Override

-(BOOL)prefersStatusBarHidden
{
    return !_showBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Setter And Getter
-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}
-(WTMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[WTMenuView alloc] init];
        _menuView.hidden = YES;
        _menuView.delegate = self;
    }
    return _menuView;
}

-(WTCatalogViewController *)catalogVC
{
    if (!_catalogVC) {
        _catalogVC = [[WTCatalogViewController alloc] init];
        _catalogVC.catalogDelegate = self;
    }
    return _catalogVC;
}
-(UIView *)catalogView
{
    if (!_catalogView) {
        _catalogView = [[UIView alloc] init];
        _catalogView.backgroundColor = [UIColor clearColor];
        _catalogView.hidden = YES;
        [_catalogView addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCatalog)];
            tap.delegate = self;
            tap;
        })];
    }
    return _catalogView;
}

- (void)setBookModel:(WTSortDetailItemModel *)bookModel{
    _bookModel = bookModel;
    
    [self showProgressHUD];
    @weakify(self);
    RACTuple *tuple = RACTuplePack(bookModel._id);
    [[[WTBookDownloader downloader].fetchBookCatalogue execute:tuple]
     subscribeNext:^(WTBookCatalogueModel *catalogue) {
         @strongify(self);
         WTReadModel *readModel = [[WTReadModel alloc] initWithContent:nil];
         readModel.chapters = [NSMutableArray arrayWithArray:catalogue.chapters];
         self.model = readModel;
         RACTuple *chapter = RACTuplePack(catalogue.chapters.firstObject);
         [[[WTBookDownloader downloader].fetchBookChapterData execute:chapter]
          subscribeNext:^(WTBookChapterContentModel *chapter) {
              WTChapterModel *chapterModel = readModel.chapters.firstObject;
              chapterModel.isDownloadChapter = YES;
              chapterModel.content = chapter.body;
              [self setupUI];
              [self hideProgressHUD];
          }];
         
     }];
}


@end
