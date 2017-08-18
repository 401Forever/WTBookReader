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

/** 主题颜色 */
#define ReadConfig_ThemeColor_1 [UIColor whiteColor]
#define ReadConfig_ThemeColor_2 RGBA(188, 178, 190, 1)
#define ReadConfig_ThemeColor_3 RGBA(190, 182, 162, 1)
#define ReadConfig_ThemeColor_4 RGBA(30, 30, 40, 1)

/** 字体颜色 */
#define ReadConfig_FontColor_1 [UIColor blackColor]
#define ReadConfig_FontColor_2 ReadConfig_FontColor_1
#define ReadConfig_FontColor_3 ReadConfig_FontColor_1
#define ReadConfig_FontColor_4 RGBA(88, 111, 143, 1)

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
