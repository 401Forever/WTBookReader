//
//  WTReadConfig.h
//  WTBookReader
//
//  Created by xueban on 2017/8/14.
//  Copyright © 2017年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WTNoteNotification @"WTNoteNotification"
#define WTThemeNotification @"WTThemeNotification"
#define WTEditingNotification @"WTEditingNotification"
#define WTEndEditNotification @"WTEndEditNotification"


#define TopSpacing 40.0f
#define BottomSpacing 40.0f
#define LeftSpacing 20.0f
#define RightSpacing  20.0f

@interface WTReadConfig : NSObject<NSCoding>
+(instancetype)shareInstance;
/** 书籍字体 */
@property (nonatomic) CGFloat fontSize;
/** 行间间隔 */
@property (nonatomic) CGFloat lineSpace;
/** 字体颜色 */
@property (nonatomic,strong) UIColor *fontColor;
/** 主题颜色 */
@property (nonatomic,strong) UIColor *theme;
@end
