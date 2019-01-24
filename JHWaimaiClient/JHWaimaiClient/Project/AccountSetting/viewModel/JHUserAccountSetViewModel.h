//
//  JHUserAccountSetViewModel.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHUserAccountSetViewModel : NSObject

/**
 修改密码的接口

 @param dic 需要传入的数据
 @param myBlock 回调的接口
 */
+(void)postToRevisePsdWithDic:(NSDictionary *)dic
                        block:(void(^)(NSString * error))myBlock;

/**
 换绑手机的接口

 @param dic 需要的数据
 @param myBlock 回调的结果
 */
+(void)postToChangePhoneWithDic:(NSDictionary *)dic
                         block:(void(^)(NSString * error))myBlock;

/**
 修改昵称的接口

 @param dic 需要的数据
 @param myBlock 回调的结果
 */
+(void)postToChangeNickNameWithDic:(NSDictionary *)dic
                        block:(void(^)(NSString * error))myBlock;

/**
 上传头像的接口

 @param dic 需要的数据
 @param myBlock 回调的结果
 */
+(void)postToUpHeaderImgWithDic:(NSDictionary *)dic
                         block:(void(^)(NSString * error))myBlock;

/**
 改变性别的接口

 @param dic 需要传入的数据
 @param myBlock 回调的结果
 */
+(void)postToChangeSexWithDic:(NSDictionary *)dic
                        block:(void(^)(NSString * error))myBlock;

/**
 绑定微信的方法
 
 @param dic 需要传入的数据
 @param myBlock 回调的结果
 */
+(void)postToBindeWeixinWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString *error))myBlock;
/**
 解除绑定微信的方法
 
 @param dic 需要传入的数据
 @param myBlock 回调的结果
 */
+(void)postToNoBindeWeixinWithDic:(NSDictionary *)dic
                            block:(void(^)(NSString *error))myBlock;
@end
