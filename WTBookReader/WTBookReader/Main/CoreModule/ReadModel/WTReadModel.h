//
//  WTReadModel.h
//  WTBookReader
//
//  Created by xueban on 2017/8/17.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTChapterModel.h"
#import "WTBookCatalogueModel.h"
#import "WTRecordModel.h"
#import "WTNoteModel.h"
#import "WTMarkModel.h"
@interface WTReadModel : NSObject
@property (nonatomic,strong) NSURL *resource;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSMutableArray <WTMarkModel *>*marks;
@property (nonatomic,strong) NSMutableArray <WTNoteModel *>*notes;
@property (nonatomic,strong) NSMutableArray <WTChapterModel *>*chapters;
@property (nonatomic,strong) NSMutableDictionary *marksRecord;
@property (nonatomic,strong) WTRecordModel *record;
@property (nonatomic,strong) NSNumber *font;

-(instancetype)initWithContent:(NSString *)content;
-(NSUInteger)getPageIndexByOffset:(NSUInteger)offset Chapter:(NSUInteger)chapterIndex;
+(void)updateLocalModel:(WTReadModel *)readModel url:(NSURL *)url;
@end
