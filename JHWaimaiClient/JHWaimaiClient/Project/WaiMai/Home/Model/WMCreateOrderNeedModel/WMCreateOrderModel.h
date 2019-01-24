//
//  WMCreateOrderModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/10.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHWaimaiMineAddressListDetailModel.h"
#import "WMShopGoodModel.h"

@interface WMCreateOrderModel : NSObject
// 可以购买的红包套餐
@property(nonatomic,strong)NSDictionary *hongbaoPackage;
// 未达到减免说明字段
@property(nonatomic,copy)NSString *un_reduce_freight_info;
// 商家信息
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *shop_title;
@property(nonatomic,copy)NSString *shop_lat;
@property(nonatomic,copy)NSString *shop_lng;
@property(nonatomic,copy)NSString *shop_addr;
@property(nonatomic,assign)BOOL is_daofu;// 1 支持货到付款 0 不支持
@property(nonatomic,assign)BOOL online_pay;// 1支持在线支付 0 不支持
@property(nonatomic,assign)BOOL is_ziti;// 1 支持自提 0 不支持自提
@property(nonatomic,assign)BOOL support_hongbao;// 货到付款时支付是否支持红包
@property(nonatomic,assign)BOOL support_youhui;// 货到付款时支付是否支持优惠劵

@property(nonatomic,assign)BOOL first_order;// 是否是首单
@property(nonatomic,assign)BOOL support_first_share;// 首单是否共享1是0否
// 自定义属性
@property(nonatomic,assign)BOOL show_first_switch;// 是否显示首单优惠的选择开关

@property(nonatomic,copy)NSString *products;

// 红包和优惠劵
@property(nonatomic,copy)NSString *coupon_id;
@property(nonatomic,copy)NSString *coupon_amount;
@property(nonatomic,strong)NSArray *coupons;
@property(nonatomic,copy)NSString *hongbao_id;
@property(nonatomic,copy)NSString *hongbao_amount;
/*
 {
 amount = "1.00";
 "hongbao_id" = 649;
 "min_amount" = "20.00";
 }
 */
@property(nonatomic,strong)NSArray *hongbaos;
// 订单的优惠信息
/*
 {
 title:
 color:
 word:
 amount:
 }
 */
@property(nonatomic,strong)NSArray *youhui;

// 商品的总价格
@property(nonatomic,copy)NSString *product_price;
// 商品总数
@property(nonatomic,copy)NSString *product_number;
// 打包费
@property(nonatomic,copy)NSString *package_price;
// 配送费
@property(nonatomic,copy)NSString *freight_stage;
// 商品的结算价格（需支付金额）
@property(nonatomic,copy)NSString *amount;

@property(nonatomic,assign)BOOL is_first;// 是否使用首单优惠

/*
 {
     num = 2;
     price = "10.00";
     "spec_id" = 0;
     "spec_name" = "";
     title = "\U9e21\U817f\U996d";
     specification =                 (
     {
     key = 222;
     val = 222;
     },
     {
     key = "\U53e3\U5473";
     val = "\U8fa3";
     }
     );
 }

 */
@property(nonatomic,strong)NSArray *product_lists;
/*
 "shop": {
     "title": "皇后娘娘庙",
     "lat": "31.784349",
     "lng": "117.323640",
 }
 */
@property(nonatomic,strong)NSDictionary *shop;
@property(nonatomic,strong)JHWaimaiMineAddressListDetailModel *m_addr;

/*
 [
     {
     "date": "2017-03-31",
     "day": "今天(周五)"
     }
 ]
 */
@property(nonatomic,strong)NSArray *day_dates;
/**
"set_time_date": {
    "set_time": [ ],// 今天的时间
    "nomal_time": [ ],// 之后的时间
 }
 */
@property(nonatomic,strong)NSDictionary *set_time_date;

// 红包列表
@property(nonatomic,strong)NSArray *hongbao_list;

// 优惠劵列表
@property(nonatomic,strong)NSArray *coupon_list;

#pragma mark ====== 多人订餐 =======
@property(nonatomic,assign)float card_amount;// 购买会员卡的钱
@property(nonatomic,assign)float huangou_amount;//已选择的换购商品支付金额
@property(nonatomic,assign)float huangou_product_price;//已选择的换购商品总价
@property(nonatomic,assign)float huangou_package_price;//已选择的换购商品打包费

@property(nonatomic,strong)NSArray *huangous;
/*
 "cid": "1",
 "pcard_id": "1",
 "uid": "4",
 "title": "30天卡",
 "ltime": "1535375203",
 "limits": "5",
 "reduce": "1.00",
 "dateline": "1532783203"
 */
@property(nonatomic,strong)NSArray *peicards;//购买过的会员卡,通过这个判断有没有买过会员卡
@property(nonatomic,copy)NSString *peicard_id;//用户会员卡ID
@property(nonatomic,copy)NSString *peicard_amount;//会员卡减免金额
/*
 "pcard_id": "5",
 "title": "60天卡",
 "days": "60",      会员卡有效期限
 "amount": "60.00", 会员卡购买金额
 "limits": "2",     单日可使用次数
 "reduce": "1.00",  每单可减免金额
 */
@property(nonatomic,strong)NSArray *cards;// 可以购买的会员卡
@property(nonatomic,assign)BOOL have_peicard;// 是否购买会员卡

#pragma mark ======自定义属性=======
//// 选择货到付款的金额
//@property(nonatomic,copy)NSString *no_onlinePay_amount;
//// 自提的金额 在线支付
//@property(nonatomic,copy)NSString *ziti_amount;
//// 自提的金额 货到付款
//@property(nonatomic,copy)NSString *ziti_amount_no_youhui;


/**
  获取订单的支付金额

 @param on_linePay  是否在线支付
 @param is_ziti     是否自提
 @return            支付金额
 */
//-(NSString *)getOrderAmountWith:(BOOL)on_linePay ziti:(BOOL)is_ziti;

// 是不是的时间处理
-(NSArray *)getTimesArr:(BOOL)is_ziti;

/**
 获取订单信息

 @param shop_id     商家id
 @param block       回调的block
 */
+(void)getCreateOrderDetailWith:(NSString *)shop_id isZiti:(NSString *)isZiti block:(ModelBlock)block;

/**
 修改订单优惠劵接口

 @param orderModel  需要修改的订单
 @param coupon_id   将要修改的优惠劵id
 @param on_line_pay 是否就是在线支付
 @param block       回调的block
 */
//+(void)changeCouponWith:(WMCreateOrderModel *)orderModel on_line_pay:(BOOL )on_line_pay coupon_id:(NSString *)coupon_id block:(ModelBlock)block;


/**
 修改订单支付方式

 @param orderModel  需要修改的订单
 @param on_line_pay 是否就是在线支付
 @param block       回调的block
 */
//+(void)changePayTypeWith:(WMCreateOrderModel *)orderModel on_line_pay:(BOOL )on_line_pay block:(ModelBlock)block;


/**
 修改订单信息

 @param dic         修改后的订单信息
 @param block       回调的block
 */
+(void)getOrderInfoWhenChangeInfo:(NSDictionary *)dic block:(ModelBlock)block;

/**
 创建订单

 @param dic         订单信息
 @param block       回调的blcok
 */
+(void)getOrder_idWith:(NSDictionary *)dic block:(MsgBlock)block;
@end
