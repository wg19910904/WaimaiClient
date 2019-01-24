//
//  JHTempJumpWithRouteModel.h
//  JHCommunityClient
//
//  Created by ijianghu on 2017/4/10.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
typedef NS_ENUM(NSInteger,EMenuType){
    EMenuTypeSearch = 0,//搜索
    EMenuTypePhone,//电话
    EMenuTypeShare,//分享
    EMenuTypeText,//文字
    EMenuTypeMore,//多个按钮
};
@protocol JHJumpRouteModelDelegate <NSObject>

@optional
// 返回上一个控制器
- (void)goBack;
-(void)onShare:(NSDictionary *)json;
-(void)gotoShare:(NSDictionary *)dic;//分享的回调
-(void)addMenu:(NSDictionary *)obj type:(EMenuType)type;//增加按钮的回调
-(void)previewImage:(NSDictionary *)dic;//调用本地图片浏览器
-(void)chooseImage;//选择图片
-(void)getLocation;//获取坐标
-(void)onLogin:(NSDictionary *)obj;//登录
-(void)onPayment:(NSDictionary *)obj;//调用原生支付
-(void)onPaymentByCode:(NSDictionary *)obj;//调用原生支付
- (void)showBackBtnAndTitle:(id)obj; //是否展示返回按钮和标题
-(void)goHome;
@end
@interface JHJumpRouteModel : NSObject

// 用于js交互的代理
@property(nonatomic,weak)id<JHJumpRouteModelDelegate> jsDelegate;

/**
 路由跳转

 @param link 路由的链接
 @return 返回控制器
 */
+(id)jumpWithLink:(NSString *)link;
@end
