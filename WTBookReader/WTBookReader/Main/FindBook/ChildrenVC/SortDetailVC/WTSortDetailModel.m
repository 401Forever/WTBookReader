//
//  WTSortDetailModel.m
//  WTBookReader
//
//  Created by xueban on 2017/4/27.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTSortDetailModel.h"
#import "NSString+URL.h"
#define NotNull(str) (str.length ? str : @"无")

@implementation WTSortDetailModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"books":@"WTSortDetailItemModel",
             };
}
@end
@implementation WTSortDetailItemModel
- (NSString *)authorAndMajorCate{
    return [NSString stringWithFormat:@"%@ | %@",NotNull(self.author), NotNull(self.majorCate)];
}

- (NSString *)latelyFollowerAndretentionRatio{
    return [NSString stringWithFormat:@"%@ | %.2lf%%",NotNull(self.latelyFollower), [self.retentionRatio floatValue]];
}

- (RACSignal *)fetchImageSignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (!self.cover.length) {
            [subscriber sendNext:[UIImage imageNamed:@"default_book_cover"]];
            [subscriber sendCompleted];
            return nil;
        }
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",HostString,self.cover];
        if ([self.cover hasPrefix:@"/agent/"]) {
            imageUrl = [NSString stringWithFormat:@"%@",[self.cover stringByReplacingOccurrencesOfString:@"/agent/" withString:@""]];
            imageUrl = [imageUrl URLDecodedString];
        }
        NSURL *url = [NSURL URLWithString:imageUrl];
       [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
           if (image) {
               [subscriber sendNext:image];
               [subscriber sendCompleted];
               return;
           }
           [subscriber sendNext:[UIImage imageNamed:@"default_book_cover"]];
           [subscriber sendCompleted];
       }];
        return nil;
    }];
}
@end
