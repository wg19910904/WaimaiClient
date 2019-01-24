//
//  ZQAppVersionTool.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/8/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQAppVersionTool : NSObject
/**
 判断是否需要升级的接口
 
 @param api 升级的接口的api
 */
+(void)postToSureThatIsNeedUpgradeVersion:(NSString*)api;
@end
