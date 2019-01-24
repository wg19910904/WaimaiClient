//
//  JHWaiMaiOrderListModel.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JHWaiMaiOrderListModel : NSObject
@property(nonatomic,copy)NSString * dateline;//下单时间
//@property(nonatomic,assign)NSInteger  pay_time;//支付时间
@property(nonatomic,assign)NSInteger dao_time;
@property(nonatomic,copy)NSString *freight;//配送费
@property(nonatomic,copy)NSString *order_id;//订单号
@property(nonatomic,copy)NSString *order_status;//订单状态
@property(nonatomic,copy)NSString *order_status_label;//订单状态的显示
@property(nonatomic,copy)NSString *package_price;//打包费
@property(nonatomic,copy)NSString *pay_status;//支付状态
@property(nonatomic,copy)NSString *product_number;//订单商品数量
@property(nonatomic,copy)NSString *product_price;//订单商品价格
@property(nonatomic,copy)NSString *product_title;//商品标题
@property(nonatomic,copy)NSString *shop_id;//商户id
@property(nonatomic,copy)NSString *shop_logo;//商家的logo
@property(nonatomic,copy)NSString *shop_title;//商家的标题
@property(nonatomic,copy)NSString *spend_number;//自提码
@property(nonatomic,copy)NSString *spend_status;//自提的核销状态;0未核销，1已核销
@property(nonatomic,copy)NSString *refund;//退款的状态(-1正常0退款中1已退款2被拒绝)
@property(nonatomic,copy)NSString *total_price;//该单的总价
@property(nonatomic,copy)NSString *uid;//用户id
@property(nonatomic,copy)NSString *staff_id;//是否存在配送员
@property(nonatomic,copy)NSString *comment_status;//是否评价(0未评价1已评价)
@property(nonatomic,copy)NSString *amount;//实际支付的金额
@property(nonatomic,copy)NSString *money;//余额支付的金额
@property(nonatomic,copy)NSString *msg;//展示当前的状态信息的
@property(nonatomic,copy)NSString *pay_ltime;//订单支付时间倒计时的间隔时间
@property(nonatomic,strong)NSArray *products;//点的菜的详细
@property(nonatomic,copy)NSString *jifen_total;//评价获得的积分
@property(nonatomic,strong)NSArray *time;
@property(nonatomic,copy)NSString *comment_id;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *online_pay;//是否在线支付(0:货到付款,在线支付)
/*
 "package_price" = "1.00";
 "product_id" = 13;
 "product_name" = "\U9e21\U7fc5\U996d";
 "product_number" = 2;
 "product_price" = "12.00";
 "spec_id" = 0;

 */
@property(nonatomic,copy)NSString *pei_type;

/*
 显示按钮(有值且为1时显示相应按钮)：
 endtime倒计时,
 pay去支付,
 comment评论,
 again再来一单,
 canel取消,
 cui催单,
 confirm 确认送达,
 payback申请退款,
 see查看评价,
 admin申请客服,
 waiting等待处理结果
 */
@property(nonatomic,strong)NSDictionary *show_btn;
@end
