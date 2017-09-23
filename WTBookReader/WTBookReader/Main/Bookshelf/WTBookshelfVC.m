//
//  WTBookshelfVC.m
//  WTBookReader
//
//  Created by liyuwen on 2017/8/19.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTBookshelfVC.h"
#import "WTBookshelfViewModel.h"
#import "WTSortDetailCell.h"
#import "WTReadPageViewController.h"
@interface WTBookshelfVC ()
@property(nonatomic,strong) WTBookshelfViewModel *bookshelfViewModel;
@end

@implementation WTBookshelfVC
+ (instancetype)bookshelfVC{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WTBookshelfVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WTBookshelfVC"];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addBookNotification)
                                                 name:WTAddBookNotification object:nil];
    [self prepareUI];
}

- (void)prepareUI{
    [self setupTableViewAction:self.tableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupTableViewAction:(UITableView *)tableView{
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                           refreshingAction:@selector(fetchDataFromHeader)];
}

- (void)addBookNotification{
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bookshelfViewModel numberOfRowsInSection:0];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTSortDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WTSortDetailCell" forIndexPath:indexPath];
    cell.model = [self.bookshelfViewModel modelAtIndexPath:indexPath];
    cell.bookImageView.image = nil;
    cell.bookImageView.image = [UIImage imageNamed:@"default_book_cover"];
    [cell.model.fetchImageSignal subscribeNext:^(UIImage *image) {
        cell.bookImageView.image = image;
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WTReadPageViewController *pageVC = [[WTReadPageViewController alloc] init];
    pageVC.bookModel = [self.bookshelfViewModel modelAtIndexPath:indexPath];
    [self presentViewController:pageVC animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.bookshelfViewModel deleteBookAtIndexPath:indexPath];
    [self.tableView reloadData];
}

#pragma mark - Target Action


- (void)fetchDataFromHeader{
    @weakify(self);
    [[self.bookshelfViewModel.reuqesCommand
      execute:nil]
     subscribeNext:^(id x) {
         @strongify(self);
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView.mj_header endRefreshing];
             [self.tableView reloadData];
         });
     }];
}



#pragma mark - Setter And Getter
- (WTBookshelfViewModel *)bookshelfViewModel{
    if (!_bookshelfViewModel) {
        _bookshelfViewModel = [[WTBookshelfViewModel alloc] init];
    }
    return _bookshelfViewModel;
}

@end
