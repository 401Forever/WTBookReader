//
//  ApiDefine.h
//  WTBookReader
//  网址定义文件
//  Created by xueban on 2017/4/22.
//  Copyright © 2017年 lyw. All rights reserved.
//

#ifndef ApiDefine_h
#define ApiDefine_h

#define HostString @"http://api.zhuishushenqi.com"

//路由相关
#define Route_Rank @"ranking" //排行榜
#define Route_Sort @"cats/lv2" //分类
#define Route_Book @"book" // 书籍相关


//接口名
#define Interface_Unknow @"gender" //进入排行榜 自动调用的接口 原因未知
#define Interface_Sort   @"statistics" //分类接口
#define Interface_Book_Category @"by-categories" //通过分类获取书籍列表数据

#endif /* ApiDefine_h */
