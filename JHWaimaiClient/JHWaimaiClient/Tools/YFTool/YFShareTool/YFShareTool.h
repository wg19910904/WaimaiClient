//
//  YFShareTool.h
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/22.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YFSharePlatformType) {
    YFSharePlatformType_WechatSession,
    YFSharePlatformType_WechatTimeLine,
    YFSharePlatformType_QQ,
    YFSharePlatformType_QQZone,
    YFSharePlatformType_SaveImg
};

@interface YFShareTool : NSObject


/**
 分享调用

 @param dic 分享的信息
 @{
 @"shareUrl":           @"分享的链接",
 @"shareTitle":         @"分享的标题",
 @"shareStr":           @"分享的描述文字",
 @"urlImg":             @"分享的网络图片",
 @"localImg":           @"分享的本地图片",
 @"isOnlyImg":          @"是不是只是图片分享",
 @"savedImg":           @"保存本地的图片,当localImg为空时,用此图片分享",
 @"is_miniProgrammar":  @"是不是小程序分享",//后面的字段,小程序需要
 @"miniProgrammar_vc":  @"小程序分享图是这个控制器的截图,或者是savedImg",
 @"userName":           @"小程序username，如 gh_3ac2059ac66f",
 @"pagePath":           @"小程序页面路径"
 }
 @param platformType 分享到的平台
 @param block 分享结果的回调
 */
+(void)yf_shareWithInfo:(NSDictionary *)dic toPlatform:(YFSharePlatformType)platformType block:(MsgBlock)resultBlock;

@end

