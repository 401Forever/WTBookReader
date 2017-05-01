//
//  WTFindBookVC.m
//  WTBookReader
//
//  Created by xueban on 2017/4/22.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTFindBookVC.h"
#import "WTFindBookCell.h"
#import "WTFindBookViewModel.h"
@interface WTFindBookVC ()
@property(nonatomic,strong) WTFindBookViewModel *findBookViewModel;
@end

@implementation WTFindBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.findBookViewModel.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTFindBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WTFindBookCell" forIndexPath:indexPath];
    cell.model = self.findBookViewModel.dataSource[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *temp = [[UIView alloc] init];
    temp.backgroundColor = [UIColor clearColor];
    return temp;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WTFindBookModel *model = self.findBookViewModel.dataSource[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
           
            break;
        }
        case 1:
        {
            WTSortVC *sortVC = [WTSortVC sortVC];
            sortVC.title = model.title;
            [self.navigationController pushViewController:sortVC animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Setter And Getter 
- (WTFindBookViewModel *)findBookViewModel{
    if (!_findBookViewModel) {
        _findBookViewModel = [[WTFindBookViewModel alloc] init];
    }
    return _findBookViewModel;
}
@end
