//
//  JHLoginAndRegisterViewModel.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHLoginAndRegisterViewModel : NSObject

/**
 获取验证码的接口

 @param dic 需要的参数
 @param myBlock 回调结果的block
 */
+(void)postTosendSmsWithDic:(NSDictionary *)dic
                         block:(void(^)(NSString *error,NSString *sms_code))myBlock;

/**
 会员注册的接口

 @param dic 需要的数据
 @param myBlock 结果的回调
 */
+(void)postToRegisteWithDic:(NSDictionary *)dic
                      block:(void(^)(NSString *error))myBlock
                 newHongbao:(void(^)(BOOL have_newhb,NSString *newhb_link))hongbao;

/**
 会员登陆的接口

 @param dic 需要的数据
 @param myBlock 结果的回调
 */
+(void)postToLoginWithDic:(NSDictionary *)dic
                    block:(void(^)(NSString *error))myBlock;

/**
 找回密码的接口

 @param dic 需要的数据
 @param myBlock 回调的结果
 */
+(void)postToFindPsdWithDic:(NSDictionary *)dic
                      block:(void(^)(NSString *error))myBlock;

/**
 会员快捷登录的接口

 @param dic 需要传入的数据
 @param myBlock 回调结果的block
 */
+(void)postToFastLoginWithDic:(NSDictionary *)dic
                      block:(void(^)(NSString *error))myBlock;

/**
 微信登录的接口

 @param dic 传入的数据
 @param myBlock 回调结果的block
 */
+(void)postToWeixinLoginWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString *error))myBlock;

/**
 绑定微信的接口
 
 @param dic 传入的数据
 @param myBlock 回调结果的block
 */
+(void)postBindWeixinLoginWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString *error))myBlock
                       newHongbao:(void(^)(BOOL have_newhb,NSString *newhb_link))hongbao;
@end
