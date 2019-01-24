//
//  JHUserModel.h
//  JHShequClient_V3
//
//  Created by ios_yangfei on 17/4/1.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFSingleTon.h"

@interface JHUserModel : NSObject
YFSingleTonH(JHUserModel)
//@property(nonatomic,strong)NSArray *cookieArr;
@property(nonatomic,copy)NSString *uid;//用户UID
@property(nonatomic,copy)NSString *nickname;//用户昵称
@property(nonatomic,copy)NSString *face;//用户头像
@property(nonatomic,copy)NSString *mobile;//用户手机号
@property(nonatomic,copy)NSString *hiddenCenterMobile;//用户隐藏中间四位的手机号
@property(nonatomic,copy)NSString *token;//用户唯一识别号
@property(nonatomic,copy)NSString *money;//账户余额
@property(nonatomic,copy)NSString *jifen;//账户积分
@property(nonatomic,copy)NSString *hongbao_count;//红包的个数
@property(nonatomic,copy)NSString *wx_openid;//微信OPENID，绑定过微信的用户会有该值，空则表示未绑定微信帐号
@property(nonatomic,copy)NSString *wx_unionid;
@property(nonatomic,assign)BOOL isBindWX;//是否绑定微信
@property(nonatomic,copy)NSString *bindStatus;
@property(nonatomic,copy)NSString *loginip;//最后登录IP
@property(nonatomic,copy)NSString *lastlogin;//最后登录时间
@property(nonatomic,copy)NSString *sex;//性别(0没有选择,1男,2女)
@property(nonatomic,strong)NSString *wxtype;//wxlogin,wxbind
@property(nonatomic,copy)NSString *collect_url;//收藏的url
@property(nonatomic,copy)NSString *hongbao_url;//红包的url
@property(nonatomic,copy)NSString *coupon_url;//我的优惠券
@property(nonatomic,copy)NSString *jifen_url;//我的积分
@property(nonatomic,copy)NSString *share_url;//邀请好友的链接
@property(nonatomic,copy)NSString *collect_tuan_url;//团购中我的收藏的url
@property(nonatomic,copy)NSString *registrationID;
@property(nonatomic,copy)NSString *kefu_phone;
@property(nonatomic,copy)NSString *allow_tixian;//是否允许提现
@property(nonatomic,copy)NSString *all_orders;
@property(nonatomic,copy)NSString *cancle_pay_count;
@property(nonatomic,copy)NSString *coupon_count;
@property(nonatomic,copy)NSString *go_pay_count;
@property(nonatomic,copy)NSString *no_comment_count;
@property(nonatomic,copy)NSString *order_comment_count;
@property(nonatomic,copy)NSString *tuan_ticket_count;
@property(nonatomic,assign)BOOL isNotUpdate;
@property(nonatomic,copy)NSString *checkin_url;
@property(nonatomic,copy)NSString *have_signin;//是否有签到
@property(nonatomic,copy)NSString *signin_link;//签到链接


#pragma mark ====== 商城 =======
@property(nonatomic,assign)int msg_new_count;
/*
 {
 "need_comment" = 2;
 "need_fahuo" = 7;
 "need_pay" = 0;
 "need_shouhuo" = 4;
 refund = 5;
 }
 */
@property(nonatomic,strong)NSDictionary *mall_order_count;
@property(nonatomic,strong)NSArray *mall_order_count_arr;
@property(nonatomic,copy)NSString *mall_collect_goods_url;
@property(nonatomic,copy)NSString *mall_collect_shops_url;
@property(nonatomic,copy)NSString *mall_coupon_url;

#pragma mark ====== 跑腿 =======
@property(nonatomic,copy)NSString *paotui_hongbao_url;
//外卖首页活动样式,为1时,样式为一行一个活动;为2时,样式为一行多个活动排列
@property(nonatomic,copy)NSString *shopHuodongType;
@property(nonatomic,copy)NSString *notiLink; //通知链接
@property(nonatomic,strong)NSDictionary *hongbaoDic;//从通知点击进入时,存储的平台红包数据
// 是否登录
@property(nonatomic,assign)BOOL isLogin;
@end
