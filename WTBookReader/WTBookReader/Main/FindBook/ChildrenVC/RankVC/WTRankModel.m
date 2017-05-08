//
//  WTRankModel.m
//  WTBookReader
//
//  Created by xueban on 2017/5/6.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTRankModel.h"


@implementation WTRankItemModel
- (RACSignal *)fetchImageSignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (self.collapse) {
//            [subscriber sendNext:[UIImage imageNamed:@"ranking_other"]];
             [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;

        }
        if (!self.cover.length) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",StaticHostString,self.cover];
        NSURL *url = [NSURL URLWithString:imageUrl];
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                [subscriber sendNext:image];
                [subscriber sendCompleted];
                return;
            }
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}



@end

@implementation WTRankModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"male":@"WTRankItemModel",
             @"female":@"WTRankItemModel",
             };
}
@end


@implementation WTRankDataSource
- (instancetype)initWithData:(NSArray *)data title:(NSString *)title key:(NSString *)key{
    if (self = [super init]) {
        _sectionData = data;
        _sectionTitle = title;
        _key = key;
    }
    return self;
}
@end
