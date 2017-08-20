//
//  WTBookStoreManager.m
//  WTBookReader
//
//  Created by xueban on 2017/8/18.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTBookStoreManager.h"
#import <Realm.h>

#define BookStoreManagerDataBaseName @"ReadBookDataBase.realm"

@implementation WTBookStoreManager
static WTBookStoreManager *bookStoreManager = nil;
+(instancetype)bookStoreManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bookStoreManager = [[self alloc] init];
        [bookStoreManager creatDataBaseWithName:BookStoreManagerDataBaseName];
    });
    return bookStoreManager;
}

- (void)creatDataBaseWithName:(NSString *)databaseName
{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:databaseName];
    NSLog(@"数据库目录 = %@",filePath);
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [NSURL URLWithString:filePath];
    config.readOnly = NO;
    int currentVersion = 1.0;
    config.schemaVersion = currentVersion;
    config.migrationBlock = ^(RLMMigration *migration , uint64_t oldSchemaVersion) {
        // 这里是设置数据迁移的block
        if (oldSchemaVersion < currentVersion) {
        }
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
}

@end
