//
//  WMShopGoodModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/18.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMShopGoodSpecModel.h"
#import "WMShopGoodPropretyModel.h"

@interface WMShopGoodModel : NSObject

@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,strong)NSArray *cate_ids;// 多个分类
@property(nonatomic,copy)NSString *cate_str;// 多个分类，拼接的多个分类
@property(nonatomic,assign)BOOL is_must;// 是不是必点商品
@property(nonatomic,copy)NSString *product_id;
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *sales;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,assign)int sale_sku;
@property(nonatomic,copy)NSString *good;// 赞的人数
@property(nonatomic,copy)NSString *bad;//  差评的人数
@property(nonatomic,copy)NSString *package_price;
@property(nonatomic,copy)NSString *intro;// 商品信息
@property(nonatomic,copy)NSString *unit;// 单位
// 规格数组
@property(nonatomic,strong)NSArray *specs;
// 是否是规格商品
@property(nonatomic,assign)BOOL is_spec;
// 商品的口味
/*
 {
 key = "\U53e3\U5473";
 val =                                     (
 "\U8fa3",
 "\U4e0d\U8fa3",
 "\U72e0\U8fa3"
 );
 */
@property(nonatomic,strong)NSArray *specification;

@property(nonatomic,assign)BOOL is_discount;//是否是折扣商品
@property(nonatomic,assign)int disctype;// 折扣类型：0打折 1减价
@property(nonatomic,assign)float discval;// 折扣比例（打折：原价*discval/10，减价：原价-discval
@property(nonatomic,copy)NSString *oldprice;// 商品原价
@property(nonatomic,assign)float diffprice;// 商品差价
@property(nonatomic,copy)NSString *disclabel;// 折扣标签
@property(nonatomic,assign)int quota;
@property(nonatomic,copy)NSString *quotalabel;// 限购文字（有折扣活动时需要）

#pragma mark ====== 自定义属性 =======
// 是否是有口味的商品
@property(nonatomic,assign)BOOL is_specification;

@property(nonatomic,copy)NSString *goodPercent;// 好评率
// 客户选择的规格id(存入数据库中)
@property(nonatomic,copy)NSString *choosedSize_id;
// 选择的规格商品的打包费
@property(nonatomic,copy)NSString *spec_package_price;
// 客户选择的规格名称(在购物车展开的时候显示)
@property(nonatomic,copy)NSString *choosedSize_Name;
// 选择的规格商品的价格
@property(nonatomic,copy)NSString *choosedSize_price;
// 选择的规格商品的图片
@property(nonatomic,copy)NSString *choosedSize_photo;
// 选择的规格商品的库存
@property(nonatomic,assign)int choosedSize_sale_ku;
// 客户已经选择的数量
@property(nonatomic,assign)int good_choosedCount;
// 当前的商品还可以选择的数量
@property(nonatomic,assign)int remain_count;
// 数据库中的ID
@property(nonatomic,copy)NSString *goodDB_id;
// 选择的属性
@property(nonatomic,copy)NSString *choosed_proprety;
// 用来在购物车中展示属性
@property(nonatomic,copy)NSString *show_choosed_proprety;
// 用来创建订单时使用的属性
@property(nonatomic,copy)NSString *create_order_proprety;


#pragma mark ====== 团购购物车的属性 =======
// 当前分类下客户选择的商品数量
@property(nonatomic,assign)int current_shopcart_choosedCount;

@end
