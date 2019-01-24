//
//  WMShopDBModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/19.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMShopCateModel.h"
#import "WMShopGoodModel.h"
#import "WMShopModel.h"

#import "YFSingleTon.h"

@interface WMShopDBModel : NSObject
YFSingleTonH(WMShopDBModel);
@property(nonatomic,strong)WMShopModel *shopModel;
@property(nonatomic,assign)BOOL showShopCartMoreGood;// 购物车展示更多商品
@property(nonatomic,copy)NSString *moreShopCartProductStr;// 多人购物车的商品拼接
@property(nonatomic,assign)BOOL is_can_zero_ziti;// 是否可以0元自提
@property(nonatomic,assign)BOOL is_presentShopDetailVC;// 是否是present出来的界面
@property(nonatomic,assign)int quota; // 限购数量（有折扣活动时需要）
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *shop_title;
@property(nonatomic,copy)NSString *shop_logo;
// 选择商品的总价格
@property(nonatomic,assign)float amount;  // 没有优惠的价格,折扣后的商品价格
// 选择商品的总价格
@property(nonatomic,assign)float all_amount;// 商品的实际原价

// 用户在这个商家选择的总商品数
@property(nonatomic,assign)int shop_choosedCount;

// 这个商家被用户选择了的商品
@property(nonatomic,strong)NSMutableArray *choosedGoodsArr;

// 存入数据库的时间
@property(nonatomic,assign)NSInteger dbDateline;

// 下单的时候需要的购物车信息
@property(nonatomic,copy)NSString *order_products;

@property(nonatomic,strong)NSDictionary *good_price_dic;// 购物车中每一种商品的总价和优惠后的价格,key为produc_id

#pragma mark ====== 多人团购 =======
// 当前购物车选择了的商品
@property(nonatomic,strong)NSMutableArray *current_shopcart_choosedGoodsArr;
// 当前购物车在这个商家选择的总商品数
//@property(nonatomic,assign)int shop_current_choosedCount;
// 当前购物车商品的总价格
@property(nonatomic,assign)float current_amount;
// 当前进行选择商品的购物车的标号,0为总的购物车
@property(nonatomic,assign)int current_shopcartNum;

@property(nonatomic,strong)NSDictionary *current_good_price_dic;// 购物车中每一种商品的总价和优惠后的价格,key为produc_id
// 多人团购点击是否点击选好了
@property(nonatomic,copy)MsgBlock sureChooseBlock;

#pragma mark ====== Functions =======

// 单例中的数据清空数据
-(void)clearData;

// 清空商品的当前选择数量
-(void)clearGoodCurrentChoosedCount;

/**
 删除外卖购物车的数据库
 */
-(void)deleteDB;

/**
 清空某个商家的购物车

 @param shop_id 商家id
 */
-(void)deleteAllGoodsWith:(NSString *)shop_id;

/**
 从数据库中获取某个商家的数据
 shop_id 与 self的shop_id一致
 @param block 回调的block
 */
-(void)getShopDataFormDB:(DataBlock)block;

/**
 从数据库中获取所有商家的数据

 @param block 回调的block
 */
-(void)getShopCartDataFormDB:(void (^)(NSArray * arr))block;

/**
 获取数据库中用户在此商家选择的商品个数

 @param shop_id 商家id
 @param block 回调的block
 */
-(void)getShopChoosedCountFromDB:(NSString *)shop_id block:(void(^)(int count))block;

/**
 获取数据库中用户在此商家某个分类选择的商品个数

 @param cate_id 分类id
 @return 个数
 */
-(int)getShopCateChoosedCountFromDB:(NSString *)cate_id;

/**
 获取数据库中用户在此商家此商品选择的数量

 @param product_id          商品id
 @param choosedSize_id      商品的规格id
 @param choosed_proprety    选择的属性
 @return 个数
 */
-(int)getShopGoodChoosedCountFromDB:(NSString *)product_id choosedSize_id:(NSString *)choosedSize_id propretyStr:(NSString *)choosed_proprety good:(WMShopGoodModel *)willDealGood;

/**
 购物车商品数量变化的处理

 @param good 变化的商品
 @param cate 商品所属的分类
 @param is_add 添加还是减少
 */
-(void)goodCountChange:(WMShopGoodModel *)good cate:(WMShopCateModel *)cate is_add:(BOOL)is_add;

/**
 获取摸个商品的剩余可选数量
 
 @param shop_id             商家id
 @param product_id          商品id
 @param choosedSize_id      规格商品的选择的规格id
 @return                    剩余可选的数量
 */
//-(int)getShopGoodRemainCountFromDBWith:(NSString *)shop_id product_id:(NSString *)product_id choosedSize_id:(NSString *)choosedSize_id;

/**
 再来一单添加数据到数据库中

 @param shop_id             商家id
 @param goodArr             商品数组
 @param cateArr             分类数组
 @param block               回调的block
 */
-(void)addOnceAgainOrderToDB:(NSString *)shop_id products:(NSArray *)goodArr cates:(NSArray *)cateArr block:(MsgBlock)block;

/**
 更新商品

 @param good                需要更新的商品
 */
-(void)updateGood:(WMShopGoodModel *)good;


/**
 单独处理分类

 @param cate 分类
 @param is_add 添加还是删减
 */
-(void)dealCate:(WMShopCateModel *)cate is_add:(BOOL)is_add;

@end
