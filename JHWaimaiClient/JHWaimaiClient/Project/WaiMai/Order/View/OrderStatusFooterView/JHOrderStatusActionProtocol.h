//
//  JHOrderStatusActionProtocol.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JHOrderStatusActionProtocol <NSObject>
@optional
// 取消订单  is_timer 是否是倒计时
-(void)cancleOrderWithOrder_id:(NSString *)order_id is_timer:(BOOL)is_timer;
// 去支付
-(void)payOrderWithOrder_id:(NSString *)order_id amount:(NSString *)amount dateline:(NSInteger)dateline;
// 退款
-(void)refundOrderWithOrder_id:(NSString *)order_id phone:(NSString *)phone;
// 去评价
-(void)commentOrderWithOrder:(id)order;
// 再来一单
-(void)againOrderWithOrder:(id)order;
// 催单
-(void)cuiOrderWithOrder_id:(NSString *)order_id;
// 确认送达,确认自提
-(void)confirmOrderWithOrder_id:(NSString *)order_id;
// 申请客服介入
-(void)applyForCustomerServicesWithOrder_id:(NSString *)order_id;
// 查看评价
-(void)viewCommentWithOrder:(id)order;

@end
