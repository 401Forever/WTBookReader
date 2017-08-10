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
#define StaticHostString @"http://statics.zhuishushenqi.com"

//路由相关
#define Route_Rank @"ranking" //排行榜
#define Route_Sort @"cats/lv2" //分类 获取所有分类及子分类（可作为接口）
// 书籍相关
// 其后跟bookID可以获取与该book相关信息 例如 http://api.zhuishushenqi.com/book/51d11e782de6405c45000068
// id后再跟recommend可获取跟此book相似书籍 例如 http://api.zhuishushenqi.com/book/51d11e782de6405c45000068/recommend
#define Route_Book @"book"
#define Route_Review @"post/review"  // 获取用户评论
#define Route_BookList @"book-list"  //获取书单 例如 http://api.zhuishushenqi.com/book-list/51d11e782de6405c45000068/recommend?limit=3
#define Route_Rank @"ranking" // 获取榜单数据

//接口名
#define Interface_Unknow @"gender" //进入排行榜 自动调用的接口 原因未知
#define Interface_Sort   @"statistics" //分类接口
#define Interface_Book_Category @"by-categories" //通过分类获取书籍列表数据

// 获取最佳评论 例如 http://api.zhuishushenqi.com/post/review/best-by-book?book=51d11e782de6405c45000068
#define Interface_Review_Best @"best-by-book"

// 根据条件精确搜索数据
// 可选参数 ：author作者 例如 http://api.zhuishushenqi.com/book/accurate-search?author=%E5%A4%A9%E8%9A%95%E5%9C%9F%E8%B1%86
#define Interface_Book_Search @"accurate-search"

// 根据标签搜索 例如 http://api.zhuishushenqi.com/book/by-tags?tags=%E7%83%AD%E8%A1%80&start=0&limit=100
#define Interface_Book_Search_Tags @"by-tags"

// 获取所有的榜单 例如书最热榜 Top100"等  http://api.zhuishushenqi.com/ranking/gender
// 可根据collapse字段判断是否为别人的榜单
// 根据榜单ID可以直接获取该周榜单的数据 http://api.zhuishushenqi.com/ranking/54d42e72d9de23382e6877fb
// 根据monthRank获取月榜单
// 根据totalRank获取总榜单
#define Interface_Rank_All @"gender"

// 根据书籍ID获取该书籍的书源地址 例如http://api.zhuishushenqi.com/toc?view=summary&book=5559c3f38e9e69be5a0da51d
#define Interface_BookSource @"toc"

#define Interface_Catalogue @"mix-toc" // 获取数据的目录 例如 http://api.zhuishushenqi.com/mix-toc/5559c3f38e9e69be5a0da51d

// 根据目录获取到的link拼接URL 传入时间戳参数t 16位加密k(暂未破解)
// Y2fht@6Ag4%9QjUcj5JX + /chapter + /目录txt地址 + 时间戳   整体md5 取其 中间16位
// Y2fht@6Ag4%9QjUcj5JX/chapter/http%3A%2F%2Fread.qidian.com%2Fchapter%2FqEnX4gQ5oyVqqtWmhQLkJA2%2FTNfZ6IjFKdr4p8iEw--PPw21494849682
//1494849682 是当前时间 + 2个小时  t也是如此
#define Interface_Chapter @"" //http://chapter2.zhuishushenqi.com/chapter/http%3A%2F%2Fbook.my716.com%2FgetBooks.aspx%3Fmethod%3Dcontent%26bookId%3D634203%26chapterFile%3DU_719138_201607181024156331_0132_1.txt?k=9298f825cbdbfe38&t=1493717028


#define BookSecretKey @"Y2fht@6Ag4%9QjUcj5JX"

#endif /* ApiDefine_h */
