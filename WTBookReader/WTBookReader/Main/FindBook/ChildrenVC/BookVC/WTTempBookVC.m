//
//  WTTempBookVC.m
//  WTBookReader
//
//  Created by xueban on 2017/8/10.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTTempBookVC.h"
#import "WTReadPageViewController.h"

@interface WTTempBookVC ()
@property(nonatomic,strong) WTBookViewModel *bookViewModel;
@end

@implementation WTTempBookVC

+ (instancetype)bookVCWithViewModel:(WTBookViewModel *)viewModel{
    WTTempBookVC *detailVC = [[WTTempBookVC alloc] init];
    detailVC.bookViewModel = viewModel;
    return detailVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [[self.bookViewModel.requestBookSourceCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self)
        [[self.bookViewModel.fetchBookCatalogue execute:nil] subscribeNext:^(id x) {
            [[self.bookViewModel.fetchBookChapterData execute:nil] subscribeNext:^(WTBookChapterContentModel *chapter) {
                WTReadPageViewModel *viewModel = [[WTReadPageViewModel alloc] init];
                viewModel.tempContent = chapter.body;
                WTReadPageViewController *bookVC = [[WTReadPageViewController alloc] init];
                bookVC.viewModel = viewModel;
                [self.navigationController pushViewController:bookVC animated:YES];
            }];
        }];
    }];
}


#pragma mark - Setter And Getter
- (WTBookViewModel *)bookViewModel{
    if (!_bookViewModel) {
        _bookViewModel = [[WTBookViewModel alloc] init];
    }
    return _bookViewModel;
}

- (NSString *)title{
    return self.bookViewModel.model.title;
}
@end
