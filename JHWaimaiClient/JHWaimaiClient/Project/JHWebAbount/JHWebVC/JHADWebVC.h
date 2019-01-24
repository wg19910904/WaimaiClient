//
//  JHADWebVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/14.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHADWebVC : JHBaseVC
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)BOOL is_launch_ad;// 启动广告页
@property(nonatomic,strong)UIWebView *web;
// 是不是好友代付的网页
@property(nonatomic,assign)BOOL is_frendPay_web;
@end
