//
//  WTNetworkManager.m
//  WTBookReader
//
//  Created by xueban on 2017/4/25.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTNetworkManager.h"
static WTNetworkManager *shareNetworkManager = nil;
@implementation WTNetworkManager
+ (instancetype)shareNetworkManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNetworkManager = [[super allocWithZone:NULL] init];
    });
    return shareNetworkManager;
}

- (id)init{
    if (self = [super init]){
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", @"text/javascript", nil];
        
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 30.0;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return self;
}

/**
 *  提交请求
 *
 *  @param postData post的值 健值对
 */
- (void)postWithURLString:(NSString *)urlString
                postValue:(id)postData
         withRequestBlock:(RequestResult)requestResult{
    if (!postData) return;
    NSLog(@"*** \n URL:%@ \n postData:%@ \n***",urlString, postData);
    [_manager POST:urlString parameters:postData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        requestResult((NSDictionary *)responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        requestResult(error.userInfo[@"resultMessage"],error);
    }];
}

/**
 *  提交请求
 *
 *  @param postData post的值 健值对
 */
- (void)getWithURLString:(NSString *)urlString
               postValue:(id)postData
        withRequestBlock:(RequestResult)requestResult{
    NSLog(@"*** \n URL:%@ \n postData:%@ \n***",urlString, postData);
    [_manager GET:urlString parameters:postData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        requestResult((NSDictionary *)responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        requestResult(error.userInfo[@"resultMessage"],error);
    }];
    
}

@end
