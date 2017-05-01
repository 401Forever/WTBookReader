//
//  WTFindBookModel.m
//  WTBookReader
//
//  Created by xueban on 2017/4/24.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTFindBookModel.h"

@implementation WTFindBookModel
- (UIImage *)image{
    if (!self.imageName.length)return nil;
    return [UIImage imageNamed:self.imageName];
}
@end
