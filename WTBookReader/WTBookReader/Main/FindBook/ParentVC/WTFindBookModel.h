//
//  WTFindBookModel.h
//  WTBookReader
//
//  Created by xueban on 2017/4/24.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTFindBookModel : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *imageName;

@property(nonatomic,strong) UIImage *image;
@end
