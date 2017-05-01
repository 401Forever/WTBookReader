//
//  WTNetworkManager.h
//  WTBookReader
//
//  Created by xueban on 2017/4/25.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiDefine.h"
typedef void (^RequestResult)(id resultDictionary, NSError *error);

@interface WTNetworkManager : NSObject
@property(nonatomic,strong) AFHTTPSessionManager *manager;

//单例
+ (instancetype)shareNetworkManager;

- (void)postWithURLString:(NSString *)urlString
                postValue:(id)postData
         withRequestBlock:(RequestResult)requestResult;

- (void)getWithURLString:(NSString *)urlString
               postValue:(id)postData
        withRequestBlock:(RequestResult)requestResult;

//- (void)postWithURLString:(NSString *)urlString
//                postValue:(id)postData
//             postFormData: (PostFormData *) postFormData
//         withRequestBlock:(RequestResult)requestResult;
@end
