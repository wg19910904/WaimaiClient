//
//  JHConfigurationTool.h
//  JHShequClient_V3
//
//  Created by ios_yangfei on 17/4/1.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability.h>
#import "YFSingleTon.h"

@interface JHConfigurationTool : NSObject
YFSingleTonH(JHConfigurationTool)

// 定位相关
@property(nonatomic,copy)NSString *city_id;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *lastCommunity;
@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;
@property(nonatomic,copy)NSString *code;//保存订单详情中的二维码
@property(nonatomic,strong)UIImage *image_code;//保存生成的二维码图片
@property(nonatomic,copy)NSString *paotui_order_link;// 跑腿订单的网页链接
// 是否支持好友代付
@property(nonatomic,assign)BOOL is_have_friendPay;

/*
 {
 "adv_id" = 27;
 link = "http://www.google.com";
 ltime = 1593014400;
 stime = 1593014400;
 thumb = "photo/201702/20170215_9D6182B84863946166DE6AF53F79A5A3.jpg";
 title = 1111;
 }

 */
@property(nonatomic,strong)NSArray *launchAds;// 启动广告页

// 是不是第一次启动app
@property(nonatomic,assign)BOOL first_launch_app;

// 网络状态
@property(nonatomic,assign)NetworkStatus netStatus;

// 网络状态监听
-(void)startReachability;

// 保存配置信息
-(void)saveConfiguration;

// 获取上次的配置信息
-(void)getConfiguration;

// 获取启动广告业
-(void)getLaunchAds;

 
/**
 根据adcode获取city_id

 @param adcode 高德地理编码的adcode
 @param block  回调的block
 */
-(void)getSubstationCity_id:(NSString *)adcode block:(void(^)(BOOL ,NSString *))block;

@end
