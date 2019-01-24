//
//  JHWaiMaiOrderViewModel.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/9.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHWaimaiOrderListMainModel.h"
#import "JHWaimaiOrderDetailModel.h"
#import "JHWaimaiOrderSeeEvaliationModel.h"
@interface JHWaiMaiOrderViewModel : NSObject

/**
 获取订单列表的接口

 @param dic 需要传入的参数
 @param myBlock 回调的结果
 */
+(void)postToGetOrderListInfoWithDic:(NSDictionary *)dic
                               block:(void(^)(JHWaimaiOrderListMainModel *model,NSString *err))myBlock;

/**
 获取订单详情的接口

 @param dic 需要传入的参数
 @param myBlock 回调的结果
 */
+(void)postToGetOrderDetailInfoWithDic:(NSDictionary *)dic
                                 block:(void(^)(JHWaimaiOrderDetailModel *model,NSString *err))myBlock;

/**
 取消订单的方法

 @param dic 传入的参数
 @param myBlock 回调的结果
 */
+(void)postToCancelOrderWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString *err))myBlock;
/**
 确认送达的方法
 
 @param dic 传入的参数
 @param myBlock 回调的结果
 */
+(void)postToSureOrderWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString *err))myBlock;

/**
 订单投诉

 @param dic 传入的参数
 @param myBlock 回调的结果
 */
+(void)postToComplaintOrderWithDic:(NSDictionary *)dic
                          imageDic:(NSDictionary *)dic1
                        block:(void(^)(NSString *err))myBlock;

/**
 订单催单
 
 @param dic 传入的参数
 @param myBlock 回调的结果
 */
+(void)postToCuidanOrderWithDic:(NSDictionary *)dic
                             block:(void(^)(NSString *err))myBlock;
/**
 申请客服介入
 
 @param dic 传入的参数
 @param myBlock 回调的结果
 */
+(void)postToShenqingKefuWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString *err))myBlock;
/**
 申请退款
 
 @param dic 传入的参数
 @param myBlock 回调的结果
 */
+(void)postToPayBackWithDic:(NSDictionary *)dic
                           block:(void(^)(NSString *err))myBlock;

/**
 订单评价

 @param dic 传入的参数
 @param myBlock 回调的结果
 */
+(void)postToEvaluateOrderWithDic:(NSDictionary *)dic
                         imageDic:(NSDictionary *)dic1
                            block:(void(^)(NSString *err))myBlock;

/**
 查看评价

 @param dic 传入的参数
 @param myBlock 回调的结果
 */
+(void)postToSeeEvaluationWithDic:(NSDictionary *)dic
                           block:(void(^)(JHWaimaiOrderSeeEvaliationModel *model,NSString *err))myBlock;
/**
 申请客服介入

 @param dic 传入的参数
 @param myBlock 回调的block
 */
+(void)postToServiseWithDic:(NSDictionary *)dic
                      block:(void(^)(NSString *err))myBlock;
@end
