//
//  WTSortDetailVC.m
//  WTBookReader
//
//  Created by xueban on 2017/4/26.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTSortDetailVC.h"
#import "WTSortDetailCell.h"
#import "WTSortDetailViewModel.h"

@interface WTSortDetailVC ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationViewLeftConstraint;

@property(nonatomic,strong) NSArray *tableViewArray;
@property (weak, nonatomic) IBOutlet UITableView *hotTableView; //热门
@property (weak, nonatomic) IBOutlet UITableView *newestTableView; // 新书
@property (weak, nonatomic) IBOutlet UITableView *praiseTableView; // 好评
@property (weak, nonatomic) IBOutlet UITableView *endTableView; // 完结


@property(nonatomic,strong) WTSortDetailViewModel *sortDetailViewModel;

@end

@implementation WTSortDetailVC
+ (instancetype)sortDetailVC{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WTSortDetailVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WTSortDetailVC"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewArray = @[self.hotTableView, self.newestTableView, self.praiseTableView, self.endTableView];
    [self prepareUI];
}

- (void)prepareUI{
    [self setupTableViewAction:self.hotTableView];
    [self setupTableViewAction:self.newestTableView];
    [self setupTableViewAction:self.praiseTableView];
    [self setupTableViewAction:self.endTableView];
    [self.hotTableView.mj_header beginRefreshing];
}

- (void)setupTableViewAction:(UITableView *)tableView{
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                      refreshingAction:@selector(fetchDataFromHeader)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                                refreshingAction:@selector(fetchDataFromBottom)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger pageIndex = [_tableViewArray indexOfObject:tableView];
    return [self.sortDetailViewModel numberOfRowsInSection:pageIndex];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTSortDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WTSortDetailCell" forIndexPath:indexPath];
    cell.model = [self.sortDetailViewModel modelAtIndexPath:indexPath];
    cell.bookImageView.image = nil;
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
    self.sortDetailViewModel.pageIndex = index;
}

#pragma mark - Target Action
- (IBAction)topViewBtnClick:(UIButton *)sender {
    [self animationToIndex:sender.tag];
    CGRect targetPoint = CGRectMake(MainScreenWidth * sender.tag,
                                    self.mainScrollView.contentOffset.y,
                                    self.mainScrollView.frame.size.width,
                                    self.mainScrollView.frame.size.height);
    [self.mainScrollView scrollRectToVisible:targetPoint animated:YES];
    self.sortDetailViewModel.pageIndex = sender.tag;
}

- (void)fetchDataFromHeader{
    [self.sortDetailViewModel cleanDataAtPageIndex:self.sortDetailViewModel.pageIndex];
    @weakify(self);
    [[self.sortDetailViewModel.reuqesCommand
      execute:RACTuplePack(@(self.sortDetailViewModel.pageIndex), WTSortDetailViewModel_FetchStatus_Header)]
     subscribeNext:^(id x) {
         @strongify(self);
         RACTupleUnpack(NSNumber *pageIndex,id data) = x;
         UITableView *currentTableView = self.tableViewArray[[pageIndex intValue]];
         [currentTableView reloadData];
         [currentTableView.mj_header endRefreshing];
    }];
}

- (void)fetchDataFromBottom{
    @weakify(self);
    [[self.sortDetailViewModel.reuqesCommand
      execute:RACTuplePack(@(self.sortDetailViewModel.pageIndex), WTSortDetailViewModel_FetchStatus_Bottom)]
     subscribeNext:^(id x) {
         @strongify(self);
         RACTupleUnpack(NSNumber *pageIndex,id data) = x;
         UITableView *currentTableView = self.tableViewArray[[pageIndex intValue]];
         [currentTableView reloadData];
         [currentTableView.mj_header endRefreshing];
     }];

}

#pragma mark - Private Function
- (void)animationToIndex:(NSInteger)index{
    CGFloat detalX = index == 0 ? 0 : (MainScreenWidth/4 * index);
    [UIView animateWithDuration:0.3 animations:^{
        self.animationViewLeftConstraint.constant = detalX;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Setter And Getter 
- (WTSortDetailViewModel *)sortDetailViewModel{
    if (!_sortDetailViewModel) {
        _sortDetailViewModel = [[WTSortDetailViewModel alloc] init];
    }
    return _sortDetailViewModel;
}
@end
