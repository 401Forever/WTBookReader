//
//  WTSortVC.m
//  WTBookReader
//
//  Created by xueban on 2017/4/25.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTSortVC.h"
#import "WTSortCell.h"
#import "WTSortViewModel.h"
#import "WTSortDetailVC.h"
@interface WTSortVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property(nonatomic,strong) WTSortViewModel *sortViewModel;
@end

@implementation WTSortVC
+ (instancetype)sortVC{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WTSortVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WTSortVC"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    self.mainCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                      refreshingAction:@selector(fetchData)];
    [self.mainCollectionView.mj_header beginRefreshing];
}

- (void)prepareUI{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.mainCollectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(MainScreenWidth/3.0, 50);
    layout.minimumLineSpacing = -0.5;
    layout.minimumInteritemSpacing = -0.5;
}

- (void)fetchData{
    RACSignal *requesSiganl = [self.sortViewModel.reuqesCommand execute:nil];
    [requesSiganl subscribeNext:^(NSArray  *dataSource) {
        [self.mainCollectionView.mj_header endRefreshing];
        self.sortViewModel.dataSource = dataSource;
        [self.mainCollectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    WTSortDataSource *sectionData = self.sortViewModel.dataSource[indexPath.section];
    WTSortItemModel *item = sectionData.sectionData[indexPath.row];
    WTSortDetailViewModel *viewModel = [[WTSortDetailViewModel alloc] initWithModel:item];
    WTSortDetailVC *detailVC = [WTSortDetailVC sortDetailVCWithViewModel:viewModel];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sortViewModel.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    WTSortDataSource *sectionData = self.sortViewModel.dataSource[section];
    return sectionData.sectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WTSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WTSortCell" forIndexPath:indexPath];
    WTSortDataSource *sectionData = self.sortViewModel.dataSource[indexPath.section];
    WTSortItemModel *item = sectionData.sectionData[indexPath.row];
    cell.model = item;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        WTSortHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WTSortHeaderView" forIndexPath:indexPath];
        WTSortDataSource *sectionData = self.sortViewModel.dataSource[indexPath.section];
        header.model = sectionData;
        return header;
    }
    return nil;
}

#pragma mark - Setter And Getter
- (WTSortViewModel *)sortViewModel{
    if (!_sortViewModel) {
        _sortViewModel = [[WTSortViewModel alloc] init];
    }
    return _sortViewModel;
}
@end
