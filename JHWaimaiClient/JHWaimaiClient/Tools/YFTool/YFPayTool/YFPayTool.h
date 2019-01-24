//
//  YFPayTool.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFSingleTon.h"

typedef void(^PayResultBlock)(BOOL success,NSString *errStr);

@interface YFPayTool : NSObject
YFSingleTonH(YFPayTool);

/**
 支付宝支付

 @param api             支付宝支付的api
 @param params          支付需要的参数
 @param resultBlock     回调的block
 */
+(void)AlipayApi:(NSString *)api params:(NSDictionary *)params block:(PayResultBlock)resultBlock;

/**
 微信支付
 
 @param api             微信支付的api
 @param params          支付需要的参数
 @param resultBlock     回调的block
 */
+(void)WXPayApi:(NSString *)api params:(NSDictionary *)params block:(PayResultBlock)resultBlock;

/**
 余额支付

 @param api             余额支付的api
 @param params          支付需要的参数
 @param resultBlock     回调的block
 */
+(void)moneyPayApi:(NSString *)api params:(NSDictionary *)params block:(PayResultBlock)resultBlock;


/**
 信用卡支付

 @param api             信用卡支付的api
 @param params          信用卡支付的参数
 @param resultBlock     回调的blcok
 */
+(void)stripePayApi:(NSString *)api params:(NSDictionary *)params block:(PayResultBlock)resultBlock;


/**
 PayPal支付

 @param api             PayPal支付的api
 @param params          PayPal支付的参数
 @param resultBlock     回调的blcok
 */

/**
 PayPal支付

 @param api             PayPal支付的api
 @param params          PayPal支付的参数
 @param presentVC       弹出paypal支付界面的vc
 @param resultBlock     回调的blcok
 */
+(void)PayPalPayApi:(NSString *)api params:(NSDictionary *)params presentVC:(UIViewController *)presentVC block:(PayResultBlock)resultBlock;


/**
 好友代付

 @param api             好友代付的api
 @param params          好友代付的参数
 @param resultBlock     回调的blcok
 */
+(void)friendPayApi:(NSString *)api params:(NSDictionary *)params block:(PayResultBlock)resultBlock;

+(void)getPayMessage:(NSString *)from andDic:(NSDictionary *)dic andApi:(NSString *)api block:(PayResultBlock)resultBlock;

@end
