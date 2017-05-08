//
//  WTRankVC.m
//  WTBookReader
//
//  Created by xueban on 2017/5/6.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTRankVC.h"

@interface WTRankVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) WTRankViewModel *rankViewModel;
@end

@implementation WTRankVC
+ (instancetype)rankVC{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WTRankVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WTRankVC"];
    return vc;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(fetchData)];
    [self.tableView.mj_header beginRefreshing];

}

- (void)fetchData{
    RACSignal *requesSiganl = [self.rankViewModel.reuqesCommand execute:nil];
    [requesSiganl subscribeNext:^(NSArray  *dataSource) {
        [self.tableView.mj_header endRefreshing];
        self.rankViewModel.dataSource = dataSource;
        [self.tableView reloadData];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rankViewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WTRankDataSource *sectionModel = self.rankViewModel.dataSource[section];
    return sectionModel.sectionData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WTRankCell" forIndexPath:indexPath];
    WTRankDataSource *sectionModel = self.rankViewModel.dataSource[indexPath.section];
    cell.model = sectionModel.sectionData[indexPath.row];
    [cell.model.fetchImageSignal subscribeNext:^(UIImage *image) {
        cell.rankImageView.image = image;
    }];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WTRankHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WTRankHeaderView"];
    if (!header) {
        header = [[WTRankHeaderView alloc] initWithReuseIdentifier:@"WTRankHeaderView"];
    }
    WTRankDataSource *sectionModel = self.rankViewModel.dataSource[section];
    header.sectionModel = sectionModel;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WTRankDataSource *sectionModel = self.rankViewModel.dataSource[indexPath.section];
    WTRankItemModel *model = sectionModel.sectionData[indexPath.row];
    if (!model.collapse) {
        WTRankDetailViewModel *viewModel = [[WTRankDetailViewModel alloc] initWithModel:model];
        WTRankMutilDetailVC *detailVC = [WTRankMutilDetailVC rankDetailVCWithViewModel:viewModel];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        WTRankDetailViewModel *viewModel = [[WTRankDetailViewModel alloc] initWithModel:model];
        WTRankSingleDetailVC *detailVC = [WTRankSingleDetailVC rankDetailVCWithViewModel:viewModel];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}



#pragma mark - Setter And Getter 
- (WTRankViewModel *)rankViewModel{
    if (!_rankViewModel) {
        _rankViewModel = [[WTRankViewModel alloc] init];
    }
    return _rankViewModel;
}
@end
