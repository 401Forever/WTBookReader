//
//  WTBookDownloader.m
//  WTBookReader
//
//  Created by xueban on 2017/8/17.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTBookDownloader.h"

@implementation WTBookDownloader
static WTBookDownloader *downloader = nil;
+(instancetype)downloader
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[self alloc] init];
        
    });
    return downloader;
}
@end
