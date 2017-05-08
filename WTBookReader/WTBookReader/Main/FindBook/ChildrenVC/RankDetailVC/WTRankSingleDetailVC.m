//
//  WTRankSingleDetailVC.m
//  WTBookReader
//
//  Created by xueban on 2017/5/8.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTRankSingleDetailVC.h"

@interface WTRankSingleDetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *rankTableView;
@property(nonatomic,strong) WTRankDetailViewModel *rankDetailViewModel;
@end

@implementation WTRankSingleDetailVC
+ (instancetype)rankDetailVC{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WTRankSingleDetailVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WTRankSingleDetailVC"];
    return vc;
}

+ (instancetype)rankDetailVCWithViewModel:(WTRankDetailViewModel *)viewModel{
    WTRankSingleDetailVC *detailVC = [WTRankSingleDetailVC rankDetailVC];
    detailVC.rankDetailViewModel = viewModel;
    return detailVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
}

- (void)prepareUI{
    [self setupTableViewAction:self.rankTableView];
    [self.rankTableView.mj_header beginRefreshing];
}

- (void)setupTableViewAction:(UITableView *)tableView{
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                           refreshingAction:@selector(fetchDataFromHeader)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rankDetailViewModel numberOfRowsInSection:0];
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



#pragma mark - Target Action


- (void)fetchDataFromHeader{
    [self.rankDetailViewModel cleanDataAtPageIndex:self.rankDetailViewModel.pageIndex];
    @weakify(self);
    [[self.rankDetailViewModel.reuqesCommand
      execute:RACTuplePack(@(self.rankDetailViewModel.pageIndex), WTRankDetailViewModel_FetchStatus_Header)]
     subscribeNext:^(id x) {
         @strongify(self);
         RACTupleUnpack(NSNumber *pageIndex,id data) = x;
         [self.rankTableView.mj_header endRefreshing];
         [self.rankTableView reloadData];
     }];
}


#pragma mark - Private Function

- (void)fetchHeaderData{
    @weakify(self);
    [[self.rankDetailViewModel.canFetchHeaderDataSignal filter:^BOOL(NSNumber *value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self.rankTableView.mj_header beginRefreshing];
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
