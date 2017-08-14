//
//  WTNoteModel.m
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import "WTNoteModel.h"

@implementation WTNoteModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.note forKey:@"note"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:@(self.location) forKey:@"location"];
    [aCoder encodeObject:@(self.length) forKey:@"length"];
    [aCoder encodeObject:@(self.chapter) forKey:@"chapter"];
//    [aCoder encodeObject:self.recordModel forKey:@"recordModel"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.note = [aDecoder decodeObjectForKey:@"note"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.location = [[aDecoder decodeObjectForKey:@"location"] integerValue];
        self.length = [[aDecoder decodeObjectForKey:@"length"] integerValue];
        self.chapter = [[aDecoder decodeObjectForKey:@"chapter"] integerValue];
//        self.recordModel = [aDecoder decodeObjectForKey:@"recordModel"];
    }
    return self;
}

@end
