//
//  HttpTool.h
//  Lunch
//
//  Created by xixixi on 16/2/18.
//  Copyright © 2016年 jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpTool : AFHTTPSessionManager

/**
 *  发送一个POST请求
 *
 *  @param api     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithAPI:(NSString *)api
         withParams:(NSDictionary *)params
            success:(void (^)(id json))success
            failure:(void (^)(NSError * error))failure;

/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param api     请求路径
 *  @param params  请求参数
 *  @param dataDic  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithAPI:(NSString *)api
             params:(NSDictionary *)params
            dataDic:(NSDictionary *)dataDic
            success:(void (^)(id json))success
            failure:(void (^)(NSError * error))failure;

/**
 *  发送一个POST请求(获取图形验证码)
 *
 *  @param api     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postTogetImageWithAPI:(NSString *)api
         withParams:(NSDictionary *)params
            success:(void (^)(id json))success
            failure:(void (^)(NSError * error))failure;

@end
