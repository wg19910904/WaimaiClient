//
//  WaiMaiShopModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMShopCateModel.h"

@interface WMShopModel : NSObject
@property(nonatomic,assign)BOOL is_reduce_pei; // 是否有减免配送费活动
@property(nonatomic,copy)NSString *reduceEd_freight; // 配送费起始价
@property(nonatomic,assign)BOOL is_show_more;// 搜索界面显示更多商品
@property(nonatomic,copy)NSString *tips_label;
@property(nonatomic,assign)BOOL have_must;// 是否含有必点商品
@property(nonatomic,assign)BOOL is_new;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *share_url;
@property(nonatomic,assign)float avg_score;
@property(nonatomic,copy)NSString *orders;// 总销量
@property(nonatomic,copy)NSString *min_amount;// 起送价
@property(nonatomic,copy)NSString *freight;// 配送费
@property(nonatomic,assign)int pei_type;// 0商家配送  1平台专送
@property(nonatomic,copy)NSString *pei_time; // 配送时间
@property(nonatomic,copy)NSString *juli_label;// 距离
@property(nonatomic,assign)BOOL collect;// 是否收藏商家
@property(nonatomic,copy)NSString *delcare;// 公告
@property(nonatomic,copy)NSString *can_zero_ziti;
@property(nonatomic,assign)BOOL can_zero_ziT;//是否自提
@property(nonatomic,copy)NSString *yyst;//是否营业

/*
 {
 "coupon_amount" = 15;
 title = "\U51712\U5f20";
 link
 };
 */
// 优惠劵信息
@property(nonatomic,strong)NSDictionary *shop_coupon;

/*
 {
    title:
    color:
    word:
 }
 */
// 优惠活动数组
@property(nonatomic,strong)NSArray *huodong;

// 未拼接活动数组
@property(nonatomic,strong)NSArray *huodongMark;

@property(nonatomic,strong)NSArray *products;

// yysj_status 和 yy_status 都为1 营业中，否则打烊
@property(nonatomic,assign)int yysj_status;
@property(nonatomic,assign)int yy_status;

// 分类数组（包含商品）
@property(nonatomic,strong)NSArray *cateArr;
@property(nonatomic,strong)WMShopCateModel *tj_items;// 推荐商品分类
/*
 {
 "adv_id" = 1;
 link = "http://wmdemo.jhcms.cn/waimai";
 photo = "http://img01.jhcms.com/wmdemo/photo/201807/20180730_48A5A7A913E979C9EC06610F96B3F815.jpg_thumb.jpg";
 title = "\U5e7f\U544a1";
 },
 */
@property(nonatomic,strong)NSArray *advs;// 店铺广告

// 图片数组
@property(nonatomic,strong)NSArray *verify;
@property(nonatomic,strong)NSArray *album;

// 营业时间段
@property(nonatomic,strong)NSArray *yy_peitime;
@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *lng;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *addr;

@property(nonatomic,assign)int quota; // 限购数量（有折扣活动时需要）

/*
 wxapp =             {
 "have_wx_app" = 1;
 "wx_app_id" = "gh_7c96e6f59ec2";
 "wx_app_url" = "/pages/shoptail/detail?id=134";
 };
 */
@property(nonatomic,strong)NSDictionary *wxapp;

// 支持的优惠条件
/*
 {
 first = 0;
 "first_share" = 0;
 hongbao = 0;
 manjian = 0;
 youhui = 0;
 }
 */
@property(nonatomic,strong)NSDictionary *support;

/*
 manjian =             {
 config =                 (
 {
 "coupon_amount" = 2;
 "order_amount" = 10;
 "roof_amount" = 0;
 "shop_amount" = 2;
 },
 {
 "coupon_amount" = 5;
 "order_amount" = 20;
 "roof_amount" = 2;
 "shop_amount" = 3;
 }
 );
 "shop_id" = 857;
 };
 */
// 满减优惠
@property(nonatomic,strong)NSDictionary *manjian;
// 是不是首单
@property(nonatomic,assign)BOOL is_first;
// 首单优惠金额  
@property(nonatomic,assign)float first_youhui;

#pragma mark ====== 自己添加的属性 =======
// 营业时间
@property(nonatomic,copy)NSString *yy_time;
// 营业状态
@property(nonatomic,assign)int status;// 1营业中  0打烊
// 展示优惠劵
@property(nonatomic,assign)BOOL showMore;
// 凑单的价格
@property(nonatomic,assign)float couDanPrice;
// 用于凑单的商品
@property(nonatomic,strong)NSArray *couDanArr;

@property(nonatomic,assign)BOOL is_distance;// 超出配送范围.该字段暂时无

/**
 获取商家详情

 @param shop_id 商家id
 @param block 回调的block
 */
+(void)getShopDetailWith:(NSString *)shop_id block:(ModelBlock)block;


/**
 收藏商家

 @param shop_id 商家id
 @param status  收藏状态
 @param block 回调的block
 */
+(void)collectShopWith:(NSString *)shop_id status:(int)status block:(MsgBlock)block;


/**
 获取商家详情介绍信息

 @param shop_id 商家id
 @param block 回调的block
 */
+(void)getShopDetailInfoWith:(NSString *)shop_id block:(ModelBlock)block;


/**
 店内搜索的方法

 @param keyword 关键词
 @param block 回调的block
 */
-(void)searchProductWithKeyword:(NSString *)keyword block:(DataBlock)block;

// 获取凑单数组
-(NSArray *)getCoudanArrWith:(float)couDanPrice;


+(void)searchWMShopListWithKW:(NSString *)keyword page:(int)page block:(DataBlockAndColor)block;
@end
