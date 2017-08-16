//
//  WTCatalogViewController.m
//  WTBookReader
//
//  Created by xueban on 2017/8/16.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTCatalogViewController.h"

#import "WTChapterVC.h"
#import "WTNoteVC.h"
#import "WTMarkVC.h"
@interface WTCatalogViewController ()<WTViewPagerVCDelegate,WTViewPagerVCDataSource,WTCatalogViewControllerDelegate>
@property (nonatomic,copy) NSArray *titleArray;
@property (nonatomic,copy) NSArray *VCArray;
@end

@implementation WTCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"目录",@"笔记",@"书签"];
    _VCArray = @[({
        WTChapterVC *chapterVC = [[WTChapterVC alloc]init];
//        chapterVC.readModel = _readModel;
        chapterVC.delegate = self;
        chapterVC;
    }),({
        WTNoteVC *noteVC = [[WTNoteVC alloc] init];
//        noteVC.readModel = _readModel;
        noteVC.delegate = self;
        noteVC;
    }),({
        WTMarkVC *markVC =[[WTMarkVC alloc] init];
//        markVC.readModel = _readModel;
        markVC.delegate = self;
        markVC;
    })];
    self.forbidGesture = YES;
    self.delegate = self;
    self.dataSource = self;
}

-(NSInteger)numberOfViewControllersInViewPager:(WTViewPagerVC *)viewPager
{
    return _titleArray.count;
}
-(UIViewController *)viewPager:(WTViewPagerVC *)viewPager indexOfViewControllers:(NSInteger)index
{
    return _VCArray[index];
}
-(NSString *)viewPager:(WTViewPagerVC *)viewPager titleWithIndexOfViewControllers:(NSInteger)index
{
    return _titleArray[index];
}
-(CGFloat)heightForTitleOfViewPager:(WTViewPagerVC *)viewPager
{
    return 40.0f;
}
-(void)catalog:(WTCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    if ([self.catalogDelegate respondsToSelector:@selector(catalog:didSelectChapter:page:)]) {
        [self.catalogDelegate catalog:self didSelectChapter:chapter page:page];
    }
}
@end
