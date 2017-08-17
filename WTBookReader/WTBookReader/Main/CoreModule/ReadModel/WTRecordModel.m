//
//  WTRecordModel.m
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTRecordModel.h"

@implementation WTRecordModel
MJCodingImplementation
-(id)copyWithZone:(NSZone *)zone
{
    WTRecordModel *recordModel = [[WTRecordModel allocWithZone:zone]init];
    recordModel.chapterModel = [self.chapterModel copy];
    recordModel.page = self.page;
    recordModel.chapter = self.chapter;
    return recordModel;
}

//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.chapterModel forKey:@"chapterModel"];
//    [aCoder encodeInteger:self.page forKey:@"page"];
//    [aCoder encodeInteger:self.chapter forKey:@"chapter"];
//    [aCoder encodeInteger:self.chapterCount forKey:@"chapterCount"];
//    [aCoder encodeObject:self.downloadProgressText forKey:@"downloadProgressText"];
//}
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super init];
//    if (self) {
//        self.chapterModel = [aDecoder decodeObjectForKey:@"chapterModel"];
//        self.page = [aDecoder decodeIntegerForKey:@"page"];
//        self.chapter = [aDecoder decodeIntegerForKey:@"chapter"];
//        self.chapterCount = [aDecoder decodeIntegerForKey:@"chapterCount"];
//        self.downloadProgressText = [aDecoder decodeObjectForKey:@"downloadProgressText"];
//    }
//    return self;
//}
@end
