//
//  WTReadParser.h
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTReadConfig.h"
#import <CoreText/CoreText.h>
@interface WTReadParser : NSObject
+(CTFrameRef)parserContent:(NSString *)content config:(WTReadConfig *)parser bouds:(CGRect)bounds;
+(NSDictionary *)parserAttribute:(WTReadConfig *)config;
//根据触碰点获取当前文字的索引
+(CFIndex)parserIndexWithPoint:(CGPoint)point frameRef:(CTFrameRef)frameRef;
/**
 *  根据触碰点获取默认选中区域
 *  @range 选中范围
 *  @return 选中区域
 */
+(CGRect)parserRectWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef;
/**
 *  根据触碰点获取默认选中区域
 *  @range 选中范围
 *  @return 选中区域的集合
 */
+(NSArray *)parserRectsWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef paths:(NSArray *)paths;
/**
 *  根据触碰点获取默认选中区域
 *  @range 选中范围
 *  @return 选中区域的集合
 *  @direction 滑动方向 (0 -- 从左侧滑动 1-- 从右侧滑动)
 */
+(NSArray *)parserRectsWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef paths:(NSArray *)paths direction:(BOOL) direction;
@end
