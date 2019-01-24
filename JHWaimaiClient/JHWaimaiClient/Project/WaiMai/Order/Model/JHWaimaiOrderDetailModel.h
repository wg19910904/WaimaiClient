//
//  JHWaimaiOrderDetailModel.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWaimaiOrderDetailModel : NSObject
@property(nonatomic,copy)NSString *addr;//用户地址
@property(nonatomic,copy)NSString *amount;//支付总金额
@property(nonatomic,copy)NSString *comment_status;//评价的状态(0未评价1已评价)
@property(nonatomic,copy)NSString *complaint;//1是已投诉,0没投诉
@property(nonatomic,copy)NSString *contact;//联系人
@property(nonatomic,copy)NSString *cui_time;//催单时间
@property(nonatomic,copy)NSString *dateline;//下单时间
@property(nonatomic,assign)NSInteger dao_time;//去支付的时候倒计时的时间
@property(nonatomic,copy)NSString *flash_time;
@property(nonatomic,copy)NSString *freight;//配送费
@property(nonatomic,copy)NSString *house;//用户具体地址
@property(nonatomic,copy)NSString *intro;//订单备注
@property(nonatomic,copy)NSString *kefu_phone;//客服电话
@property(nonatomic,copy)NSString *lat;//订单lat
@property(nonatomic,copy)NSString *lng;//订单lng
@property(nonatomic,copy)NSString *mobile;//用户手机号
@property(nonatomic,copy)NSString *money;//余额支付金额
@property(nonatomic,copy)NSString *order_from;//订单来源
@property(nonatomic,copy)NSString *order_id;//订单id
@property(nonatomic,copy)NSString *order_status;//订单状态
@property(nonatomic,copy)NSString *order_status_label;//订单状态显示
@property(nonatomic,copy)NSString *package_price;//打包费
@property(nonatomic,copy)NSString *pay_code;//支付方式
@property(nonatomic,copy)NSString *expect_msg;//预计送达的信息
@property(nonatomic,copy)NSString *expect_show;//预计送达的状态
@property(nonatomic,copy)NSString *pay_status;//支付状态
@property(nonatomic,copy)NSString *pay_time;//支付时间
@property(nonatomic,copy)NSString *payment_type;//支付方式
@property(nonatomic,copy)NSString *pei_time;//期望送达的时间
@property(nonatomic,copy)NSString *pei_type;//配送方式(0自己送1三方送3是自提单)
@property(nonatomic,copy)NSString *product_price;//商品总价
@property(nonatomic,strong)NSArray *products;//商品信息
@property(nonatomic,copy)NSString *msg;//展示当前的状态信息的
@property(nonatomic,copy)NSString *pay_ltime;//订单支付时间倒计时的间隔时间
@property(nonatomic,copy)NSString *jifen_total;//评价获得的积分
@property(nonatomic,copy)NSString *comment_id;
@property(nonatomic,copy)NSString *link;
@property(nonatomic,copy)NSString *online_pay;//是否在线支付(0:货到付款,在线支付)
@property(nonatomic,copy)NSString *hongbao_num;//获取到的红包的个数
/*
{
    amount = "11.00";//商品总价
    "order_id" = 160;//订单ID
    "package_price"//打包费
    "product_id" = 1;//商品ID
    "product_name" ;//商品名称
    "product_number";//商品数量
    "product_price";//商品价格
}
*/
@property(nonatomic,copy)NSString *refund;//退款的状态
@property(nonatomic,copy)NSString *spend_number;//自提码
@property(nonatomic,copy)NSString *spend_status;//自提状态
@property(nonatomic,strong)NSDictionary *staff;//配送员信息
/*
 {
  mobile;//配送员手机号
 name = 160;//姓名
 "face"//头像
 "lat" = 1;//配送员lat
 "lng" ;//配送员lng
 }
 */
@property(nonatomic,copy)NSString *staff_id;//配送员ID
@property(nonatomic,copy)NSString *total_price;//订单总金额
@property(nonatomic,copy)NSString *uid;//用户id
@property(nonatomic,strong)NSDictionary *waimai;//外卖商家
/*
{
    addr 商家地址
    lat  商家lat
    lng  商家lng
    logo 商家LOGO
    phone 商家的手机号
    shop_id 商家id
    title  商家名称
}
*/
@property(nonatomic,strong)NSArray *youhui;//优惠的数据
/*
(
    {
      amount 优惠金额;
      color  颜色;
      title  描述;
      word   字;
    }
   );
}
*/
@property(nonatomic,strong)NSArray *time;
/*
 {
 date = "08:10";
 minute = 10;
 }
 */
@property(nonatomic,strong)NSDictionary * hongbao;
/*
 desc
 imgUrl
 link
 title
*/

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
