//
//  WTReadPageViewController.m
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTReadPageViewController.h"
#define AnimationDelay 0.3

@interface WTReadPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,WTMenuViewDelegate,UIGestureRecognizerDelegate,WTCatalogViewControllerDelegate,WTReadViewControllerDelegate,UIAlertViewDelegate>
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
@property(nonatomic,assign) BOOL canDownload; //是否可以下载章节 当全部缓存到本地的时候 不可以下载

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
         _model.record.chapter = targetChapter;
         _page = _model.record.page;
         _chapter = _model.record.chapter;
         UIPageViewControllerNavigationDirection direction = isNext ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
         self.tapGesture.enabled = YES;
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:direction animated:YES completion:nil];
             });
             [self hideProgressHUD];
         });
     }];
}

- (BOOL)fetchChapterFromDatabaseWithChapterIndex:(NSInteger)chapterIndex{
    BOOL isSearchSuccess = NO;
    if (chapterIndex < 0 || chapterIndex > self.model.chapters.count) {
        return isSearchSuccess;
    }
    //先从数据库查找
    NSString *condition = [NSString stringWithFormat:@"bookId = '%@' AND chapterIndex = %ld",self.bookModel._id, chapterIndex];
    RLMResults *results = [WTStoredChapterModel objectsWhere:condition];
    if (results.count) {
        WTStoredChapterModel *storedChapter = results.firstObject;
        WTChapterModel *currentChapter = [self.model.chapters objectAtIndex:chapterIndex];
        currentChapter.isDownloadChapter = YES;
        currentChapter.content = storedChapter.body;
        isSearchSuccess = YES;
    }
    return isSearchSuccess;
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
        if (![self fetchChapterFromDatabaseWithChapterIndex:chapter]) {
            [self fetchChapterWithModel:_model.chapters[chapter] isNext:YES targetChapter:chapter];
            return;
        }
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
    [[WTBookDownloader downloader] downloadAllChapterInBackgrounpWithCatalogue:self.model.chapters
                                                                        bookId:self.bookModel._id];
    NSLog(@"点击下载按钮");
}

-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    if ([self fetchChapterFromDatabaseWithChapterIndex:chapter]) {
        [self.pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self updateReadModelWithChapter:chapter page:page];
        return;
    }
    if (chapter < self.model.chapters.count) {
        [self fetchChapterWithModel:self.model.chapters[chapter] isNext:YES targetChapter:chapter];
    }
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
    
    NSString *condition = [NSString stringWithFormat:@"bookId = '%@'",self.bookModel._id];
    RLMResults *models = [WTStoredBookModel objectsWhere:condition];
    if (!models.count) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否将本书保存在本地" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }else{
#warning 可能存在字体更改之后 页面数不对的问题
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        WTStoredBookModel *storeModel = models.firstObject;
        storeModel.chapterCount = self.model.chapters.count;
        storeModel.currentPageCount = _page;
        storeModel.currentChapterCount = _chapter;
        [WTStoredBookModel createOrUpdateInRealm:realm withValue:storeModel];
        [realm commitWriteTransaction];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    WTStoredBookModel *storeModel = [[WTStoredBookModel alloc] initWithModel:self.bookModel];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [WTStoredBookModel createOrUpdateInRealm:realm withValue:storeModel];
    [realm commitWriteTransaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:WTAddBookNotification object:nil];
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
    if ( _chapterChange != 0  && !_model.chapters[_chapterChange - 1].isDownloadChapter) {
        //如果本地不存在 查找本地缓存
        [self fetchChapterFromDatabaseWithChapterIndex:_chapterChange - 1];
    }
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
    NSLog(@"Before chapter:%ld ===  page:%ld",_chapterChange,_pageChange);
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
    if ( (_chapterChange + 1) < self.model.chapters.count
        && !_model.chapters[_chapterChange + 1].isDownloadChapter) {
        //如果本地不存在 查找本地缓存
        [self fetchChapterFromDatabaseWithChapterIndex:_chapterChange + 1];
    }
    
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
    
    NSLog(@"After chapter:%ld ===  page:%ld",_chapterChange,_pageChange);
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
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
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

- (BOOL)canDownload{
    NSInteger total = [WTStoredChapterModel allObjects].count;
    return total > self.model.chapters.count;
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
         
         // 查找本地缓存的书籍信息
         WTStoredBookModel *storedBook = [WTStoredBookModel objectForPrimaryKey:self.bookModel._id];
         WTChapterModel *currentChapter = catalogue.chapters.firstObject;
         if (storedBook  && storedBook.currentChapterCount < catalogue.chapters.count) {
             currentChapter = catalogue.chapters[storedBook.currentChapterCount];
             self.model.record.page = storedBook.currentPageCount;
             self.model.record.chapter = storedBook.currentChapterCount;
             _chapter = self.model.record.chapter;
             _page = self.model.record.page;
         }
         
         //先从数据库查找
         if ([self fetchChapterFromDatabaseWithChapterIndex:_chapter]) {
             [self setupUI];
             [self hideProgressHUD];
             return;
         }
         
         //本地没有缓存的情况 再从网上下载
         RACTuple *chapter = RACTuplePack(currentChapter);
         [[[WTBookDownloader downloader].fetchBookChapterData execute:chapter]
          subscribeNext:^(WTBookChapterContentModel *chapter) {
              currentChapter.isDownloadChapter = YES;
              currentChapter.content = chapter.body;
              [self setupUI];
              [self hideProgressHUD];
          }];
         
     }];
}


@end
