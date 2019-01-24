//
//  JHWaimaiMineViewModel.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHWaimaiMineAddressListModel.h"
#import "JHWaimaiMyBalanceListModel.h"
@interface JHWaimaiMineViewModel : NSObject

/**
 获取会员信息的接口

 @param myBlock 结果的回调
 */
+(void)postToGetUserInfoWithBlock:(void(^)(NSString *error))myBlock;

/**
 退出登录的操作
 */
+(void)postToQuitLogin;

/**
 获取我的地址的接口

 @param dic 需要的参数
 @param is_paotui 是不是跑腿选择地址的接口
 @param myBlock 回调的结果
 */
+(void)postToGetMyAddressWithDic:(NSDictionary *)dic  is_paotui:(BOOL)is_paotui
                           block:(void(^)(JHWaimaiMineAddressListModel * model,NSString *error))myBlock;

/**
 下单的时候获取地址列表

 @param dic 需要的参数
 @param myBlock 回调的结果
 */
+(void)postToGetShopAddressWithDic:(NSDictionary *)dic
                             block:(void(^)(JHWaimaiMineAddressListModel * model,NSString *error))myBlock;

/**
 添加地址的接口

 @param dic 需要传入的数据
 @param myBlock 回调的block
 */
+(void)postToCreatAddressWithDic:(NSDictionary *)dic
                           block:(void(^)(NSString *error))myBlock;
/**
 删除地址的方法

 @param dic 需要传入的数据
 @param myBlock 回调的结果
 */
+(void)postToRemoveAddressWithDic:(NSDictionary *)dic
                            block:(void(^)(NSString *error))myBlock;

/**
 修改地址的方法

 @param dic 需要传入的数据
 @param myBlock 回调的结果
 */
+(void)postToReviseAddressWithDic:(NSDictionary *)dic
                            block:(void(^)(NSString *error))myBlock;



/**
 获取我的余额的界面的信息

 @param dic 需要传入的字符串
 @param myBlock 回调的结果
 */
+(void)postToGetBalanceRecorderWithDic:(NSDictionary *)dic
                                 block:(void(^)(JHWaimaiMyBalanceListModel *model,NSString *error))myBlock;

/**
 获取充值套餐

 @param myBlock 回调的结果
 */
+(void)postToGetRechargeInfo:(void(^)(NSArray * arr,NSString *error))myBlock;

@end
