//
//  WTRankMutilDetailVC.m
//  WTBookReader
//
//  Created by xueban on 2017/5/8.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTRankMutilDetailVC.h"

@interface WTRankMutilDetailVC ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationViewLeftConstraint;

@property(nonatomic,strong) NSArray *tableViewArray;
@property (weak, nonatomic) IBOutlet UITableView *weekTableView; //周榜
@property (weak, nonatomic) IBOutlet UITableView *monthTableView; // 月榜
@property (weak, nonatomic) IBOutlet UITableView *allTableView; // 总榜


@property(nonatomic,strong) WTRankDetailViewModel *rankDetailViewModel;
@end

@implementation WTRankMutilDetailVC

+ (instancetype)rankDetailVC{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WTRankMutilDetailVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WTRankMutilDetailVC"];
    return vc;
}

+ (instancetype)rankDetailVCWithViewModel:(WTRankDetailViewModel *)viewModel{
    WTRankMutilDetailVC *detailVC = [WTRankMutilDetailVC rankDetailVC];
    detailVC.rankDetailViewModel = viewModel;
    return detailVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewArray = @[self.weekTableView, self.monthTableView, self.allTableView,];
    [self prepareUI];
}

- (void)prepareUI{
    [self setupTableViewAction:self.weekTableView];
    [self setupTableViewAction:self.monthTableView];
    [self setupTableViewAction:self.allTableView];
    [self.weekTableView.mj_header beginRefreshing];
}

- (void)setupTableViewAction:(UITableView *)tableView{
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                           refreshingAction:@selector(fetchDataFromHeader)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger pageIndex = [_tableViewArray indexOfObject:tableView];
    return [self.rankDetailViewModel numberOfRowsInSection:pageIndex];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTSortDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WTSortDetailCell" forIndexPath:indexPath];
    cell.model = [self.rankDetailViewModel modelAtIndexPath:indexPath];
    cell.bookImageView.image = nil;
    cell.bookImageView.image = [UIImage imageNamed:@"default_book_cover"];
    [cell.model.fetchImageSignal subscribeNext:^(UIImage *image) {
        cell.bookImageView.image = image;
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = self.mainScrollView.contentOffset.x / MainScreenWidth;
    [self animationToIndex:index];
    self.rankDetailViewModel.pageIndex = index;
    [self fetchHeaderData];
}

#pragma mark - Target Action
- (IBAction)topViewBtnClick:(UIButton *)sender {
    [self animationToIndex:sender.tag];
    CGRect targetPoint = CGRectMake(MainScreenWidth * sender.tag,
                                    self.mainScrollView.contentOffset.y,
                                    self.mainScrollView.frame.size.width,
                                    self.mainScrollView.frame.size.height);
    [self.mainScrollView scrollRectToVisible:targetPoint animated:YES];
    self.rankDetailViewModel.pageIndex = sender.tag;
    [self fetchHeaderData];
}

- (void)fetchDataFromHeader{
    [self.rankDetailViewModel cleanDataAtPageIndex:self.rankDetailViewModel.pageIndex];
    @weakify(self);
    [[self.rankDetailViewModel.reuqesCommand
      execute:RACTuplePack(@(self.rankDetailViewModel.pageIndex), WTRankDetailViewModel_FetchStatus_Header)]
     subscribeNext:^(id x) {
         @strongify(self);
         RACTupleUnpack(NSNumber *pageIndex,id data) = x;
         UITableView *currentTableView = self.tableViewArray[[pageIndex intValue]];
         [currentTableView.mj_header endRefreshing];
         [currentTableView reloadData];
     }];
}


#pragma mark - Private Function
- (void)animationToIndex:(NSInteger)index{
    CGFloat detalX = index == 0 ? 0 : (MainScreenWidth/3 * index);
    [UIView animateWithDuration:0.3 animations:^{
        self.animationViewLeftConstraint.constant = detalX;
        [self.view layoutIfNeeded];
    }];
}

- (void)fetchHeaderData{
    @weakify(self);
    [[self.rankDetailViewModel.canFetchHeaderDataSignal filter:^BOOL(NSNumber *value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        @strongify(self);
        UITableView *currentTableView = self.tableViewArray[self.rankDetailViewModel.pageIndex];
        [currentTableView.mj_header beginRefreshing];
    }];
}

#pragma mark - Setter And Getter
- (WTRankDetailViewModel *)rankDetailViewModel{
    if (!_rankDetailViewModel) {
        _rankDetailViewModel = [[WTRankDetailViewModel alloc] init];
    }
    return _rankDetailViewModel;
}

- (NSString *)title{
    return self.rankDetailViewModel.model.title;
}
@end
