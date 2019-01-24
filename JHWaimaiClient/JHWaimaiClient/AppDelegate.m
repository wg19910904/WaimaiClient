//
//  AppDelegate.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/4/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <JRDBMgr.h>
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import <SDWebImage/SDImageCache.h>
#import <UMSocialCore/UMSocialCore.h>
#import <JPUSHService.h>
#import <CloudPushSDK/CloudPushSDK.h>
#import <MeiQiaSDK/MeiQiaSDK.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "YFTabBarController.h"
#import "JHConfigurationTool.h"
#import "JHGuideVC.h"
#import "JHLoginVC.h"
#import "JHNormalNaviVC.h"
#import "JHLaunchADVC.h"
#import "JHJumpRouteModel.h"
#import "XHMapKitHeader.h"
#import "JHShowAlert.h"
#import <AVFoundation/AVFoundation.h>
#import <LSSafeProtector.h>
#import <UMMobClick/MobClick.h>
#import <Bugly/Bugly.h>

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>
@property(nonatomic,strong)AVAudioPlayer *mq_audioPlay;
// iOS 10通知中心
@property(nonatomic,strong)UNUserNotificationCenter *notificationCenter;
@property(nonatomic,strong)UILocalNotification *localNotfication;
@property(nonatomic,assign)BOOL isFirstTime;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%@",NSHomeDirectory());
    [[NSUserDefaults standardUserDefaults]setObject:@(NO) forKey:@"jhcms_is_need_scurety"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:@"jhcms_nslog_info_yes"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:@"jhcms_new_version"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //测试美洽
    [self regeisterMeiqiaWithAppkey:@""];
    if (IsMall) {
        [self getAllCity];
    }
    
    //友盟统计
    UMConfigInstance.appKey = @"5bfdf5cfb465f5106b00015f";
    UMConfigInstance.channelId = @"";
    [MobClick startWithConfigure:UMConfigInstance];
    //bugly
    [Bugly startWithAppId:@"68b6234d24"];
    
    if (SupportAliYunPush) {
        // APNs注册，获取deviceToken并上报
        [self registerAPNS:application];
        // 初始化SDK
        [self initCloudPush];
        [self syncBadgeNum:0];
    }else{
        // 注册极光
        [self registerJPush:launchOptions];
    }
    // 存url
    [self handleUrl];
    // 第三方设置
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
//    // 获取WXAPPSecret
//    [self getWeiXinInfo];
    // 创建数据库
    [WMShopDBModel shareWMShopDBModel];
    // 开启网络监测
    [[JHConfigurationTool shareJHConfigurationTool] startReachability];
    // 获取上次的配置信息
    [[JHConfigurationTool shareJHConfigurationTool] getConfiguration];
    // 设置web的user_agent
    [self setUserAgent];
    //地图相关
    if ([GAODE_KEY length] > 0) {
        [XHMapKitManager shareManager].gaodeKey = GAODE_KEY;
    }else if ([GMS_MapKey length] > 0){
        [XHMapKitManager shareManager].gmsMapKey = GMS_MapKey;
        [XHMapKitManager shareManager].theme_color = THEME_COLOR_Alpha(1.0);
    }
    self.isFirstTime = [JHConfigurationTool shareJHConfigurationTool].first_launch_app;
    //appInfo
//    [self getAppInfo];
    [self getAppInfoNative];
    [self getCurrentLocation];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor=[UIColor whiteColor];
    
    // 启动广告页和引导页的处理
    if (_isFirstTime) {
        JHGuideVC *guide = [[JHGuideVC alloc] init];
        [guide setupWithImgs:@[@"intro1",@"intro2",@"intro3"]];
        self.window.rootViewController = guide;
    }else{
        //判断是否有是从通知中心过来,如果从通知中心进来 则不显示广告
//        NSDictionary *userinfo  = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if ([JHConfigurationTool shareJHConfigurationTool].launchAds.count > 0
//            &&![userinfo[@"type"] isEqualToString:@"order"]
            ) {
            JHLaunchADVC *ad = [JHLaunchADVC new];
            self.window.rootViewController = [[JHNormalNaviVC alloc] initWithRootViewController:ad];
        }else{
            JHBaseVC *basevc = [JHBaseVC new];
            self.window.rootViewController = basevc;
        }
    }
    //如果从通知进来,获取通知内的链接
    NSDictionary *userInfo  = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSString *link_url = userInfo[@"link_url"]?userInfo[@"link_url"]:@"";
    JHUserModel.shareJHUserModel.notiLink = link_url;
    JHUserModel.shareJHUserModel.hongbaoDic = [self handlePlatformHongbao:userInfo];
    // 注册通知
    [NoticeCenter addObserver:self selector:@selector(changeRootVC) name:AppChangeRootVC object:nil];
    [NoticeCenter addObserver:self selector:@selector(getLoginNotification) name:LOGIN_NoticeName object:nil];
    
#warning 开启防crash功能---注意线上环境isDebug一定要设置为NO
    [LSSafeProtector openSafeProtectorWithIsDebug:NO block:^(NSException *exception, LSSafeProtectorCrashType crashType) {
        NSLog(@"\n崩溃了----%@",exception);
    }];
    return YES;
}

#pragma mark ====== Functions =======
// 修改url
-(void)handleUrl{
    [[NSUserDefaults standardUserDefaults]setObject:KReplace_Url forKey:@"KReplace_Url"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setObject:IPADDRESS forKey:@"IPADDRESS"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//// 获取微信的基础配置
//-(void)getWeiXinInfo{
//    [HttpTool postWithAPI:@"client/data/get_wechat" withParams:@{} success:^(id json) {
//        if (ISPostSuccess) {
//            NSLog(@"%@",json);
//            //注册友盟
//            [self registerYouMeng:json[@"data"][@"data"][@"app_appsecret"]];
//        }else{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self getWeiXinInfo];
//            });
//        }
//    } failure:^(NSError *error) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//             [self getWeiXinInfo];
//        });
//    }];
//}

// 注册友盟
-(void)registerYouMeng:(NSString *)weiXinSecret{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UMSocialManager defaultManager]setUmSocialAppkey:UM_KEY];
        /* 设置微信的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAPPID appSecret:weiXinSecret redirectURL:@""];//http://com.ijh.waimai.ltd
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAPPID  appSecret:nil redirectURL:@""];
    });
    
}

// 设置webView加载时的user_agent
-(void)setUserAgent{
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *ua = [NSString stringWithFormat:@"%@/%@",userAgent, @"com.jhcms.ios"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
}

// 商城收货地址时候需要用到的 省市区
-(void)getAllCity{
    
    [HttpTool postWithAPI:@"client/mall/addr/all_areas" withParams:@{} success:^(id json) {
        if (ISPostSuccess) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //                NSLog(@"%@",json);
                NSArray *arr = json[@"data"][@"items"];
                [UserDefaults setObject:arr forKey:@"AllCity"];
                [UserDefaults synchronize];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getAllCity];
            });
        }
    } failure:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getAllCity];
        });
    }];
    
}

-(void)getAppInfo{
    __weak typeof(self)ws = self;
    NSLog(@"-----%f",[[NSDate date] timeIntervalSince1970]);
    [HttpTool postWithAPI:@"client/app/info" withParams:@{} success:^(id json) {
        if (ISPostSuccess) {
            NSLog(@"****%f",[[NSDate date] timeIntervalSince1970]);
            //NSLog(@"%@",json);
            //处理首页配置
            self.homeConfig = [JHWaimaiHomeModel mj_objectWithKeyValues:json[@"data"]];
            [self.homeConfig handleTabBarVC];
            //当有开屏广告页时,并且第一次安装时,不直接进入首页
            if ([JHConfigurationTool shareJHConfigurationTool].launchAds.count == 0 &&
                ws.isFirstTime == NO) {
                [self changeRootVC];
            }
            [UserDefaults setObject:json[@"data"] forKey:@"appInfo"];
            [UserDefaults synchronize];
            //注册美洽
            NSString *mq_key = json[@"data"][@"mqkey"];
            [self regeisterMeiqiaWithAppkey:mq_key];
            
            [JHConfigurationTool shareJHConfigurationTool].paotui_order_link = json[@"data"][@"paotui_order_link"];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self changeRootVC];
            });
        }
        
    } failure:^(NSError *error) {
        NSLog(@"+++++%f",[[NSDate date] timeIntervalSince1970]);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changeRootVC];
        });
    }];
}

//原生POST请求
- (void)getAppInfoNative{
    __weak typeof(self)ws = self;
    NSString *url_str = [NSString stringWithFormat:@"%@%@/api.php?API=client/app/info&CLIENT_OS=IOS",KPROTOCL,KReplace_Url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url_str]];
    [request setHTTPMethod:@"POST"];
    //设置请求最长时间
    request.timeoutInterval = 60;
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSLog(@"-----%f",[[NSDate date] timeIntervalSince1970]);
        if (data) {
            //利用iOS自带原生JSON解析data数据 保存为Dictionary
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"首页配置 client/app/info %@",json);
            
            if ([json[@"error"] isEqualToString:@"0"]) {
                //处理首页配置
                self.tabbarConfig = [JHWaimaiHomeModel mj_objectWithKeyValues:json[@"data"]];
                [self.tabbarConfig handleTabBarVC];
                //当有开屏广告页时,并且第一次安装时,不直接进入首页
                if ([JHConfigurationTool shareJHConfigurationTool].launchAds.count == 0 &&
                    ws.isFirstTime == NO) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self changeRootVC];
                    });
                }
                [UserDefaults setObject:json[@"data"] forKey:@"appInfo"];
                [UserDefaults synchronize];
                [JHUserModel shareJHUserModel].have_signin = json[@"data"][@"have_signin"];
                [JHUserModel shareJHUserModel].signin_link = json[@"data"][@"signin_link"];
                //注册美洽
                NSString *mq_key = json[@"data"][@"mqkey"];
                [self regeisterMeiqiaWithAppkey:mq_key];
                // 获取WXAPPSecret
                [self registerYouMeng:json[@"data"][@"wechat"][@"app_appsecret"]];
                 [JHConfigurationTool shareJHConfigurationTool].is_have_friendPay = [json[@"data"][@"wechat"][@"wx_friendpay"] boolValue];
                [JHConfigurationTool shareJHConfigurationTool].paotui_order_link = json[@"data"][@"paotui_order_link"];
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self getAppInfoNative];
                });
            }
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getAppInfoNative];
            });
        }
    }];
    //    NSLog(@"-----%f",[[NSDate date] timeIntervalSince1970]);
    [task resume];
}

#pragma mark - 定位当前位置
- (void)getCurrentLocation{
    __weak typeof(self)ws = self;
    [[XHPlaceTool sharePlaceTool] getCurrentPlaceWithSuccess:^(XHLocationInfo *model) {
        [JHConfigurationTool shareJHConfigurationTool].lat = model.coordinate.latitude;
        [JHConfigurationTool shareJHConfigurationTool].lng = model.coordinate.longitude;
        [ws getHomeConfigData];
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - 获取首页配置数据
- (void)getHomeConfigData{
    __weak typeof(self)ws = self;
    [HttpTool postWithAPI:@"client/waimai/index/index" withParams:@{}
                  success:^(id json) {
                      if (ERROR_O) {
                          ws.homeConfig = [JHWaimaiHomeModel mj_objectWithKeyValues:json[@"data"]];
                          [ws.homeConfig handleHomeConfig];
                          [JHConfigurationTool shareJHConfigurationTool].city_id = json[@"data"][@"city_id"];
                          [[JHConfigurationTool shareJHConfigurationTool] saveConfiguration];
                          [JHUserModel shareJHUserModel].shopHuodongType = ws.homeConfig.shopHuodongType;
                      }else{
                      }
                  } failure:^(NSError *error) {
                  }];
    
}
#pragma mark - 注册美洽
- (void)regeisterMeiqiaWithAppkey:(NSString *)mq_key{
#pragma mark - 67ac064b88c479f45f57ef68d51ba162
    [MQManager initWithAppkey:@"" completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@"error:%@",error);
        }
    }];
}
// 切换根视图
-(void)changeRootVC{
    if (self.tabbarConfig.tabbarDic.count == 0) {
        __weak typeof (self)weakSelf = self;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil
                                                                        message:NSLocalizedString(@"初始化失败\n请检查网络并重试",nil)
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"重新加载", nil)
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [JHConfigurationTool shareJHConfigurationTool].launchAds = @[];
                                                    //                                                    [weakSelf getAppInfo];
                                                    [weakSelf getAppInfoNative];
                                                }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    YFTabBarController *tabbar = [YFTabBarController new];
//    if (IsWaiMai) {
        [tabbar waimaiTabbar];
//    }else if (IsPaoTui){
//        [tabbar paoTuiTabbar];
//    }else if (IsTuanGou){
//        [tabbar tuanGouTabbar];
//    }else if (IsMall){
//        [tabbar mallTabbar];
//    }else{
//        [tabbar normalTableView];
//    }
    BOOL is_launch_ad = NO;
    UIViewController *vc;
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        vc= [(UINavigationController *)self.window.rootViewController viewControllers].lastObject;
    }
    
    if (vc && [vc isKindOfClass:[JHLaunchADVC class]]) {
        is_launch_ad = YES;
    }
    
    if (is_launch_ad) { // 启动广告页的转场动画
        
        [vc.view addSubview:tabbar.view];
        [vc.view sendSubviewToBack:tabbar.view];
        tabbar.view.alpha = 0.0;
        [UIView animateWithDuration:0.75 animations:^{
            for (UIView *view in vc.view.subviews) {
                view.alpha = 0.0;
            }
            ((JHLaunchADVC *)vc).scrollView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            tabbar.view.alpha = 1.0;
        }completion:^(BOOL finished) {
            [self.window addSubview:tabbar.view];
            self.window.rootViewController = tabbar;
        }];
    }else{ // 非启动广告页的转场动画
        
        CATransition *transition = [CATransition new];
        transition.duration = 0.75;
        transition.type = kCATransitionFade;
        [self.window.layer addAnimation:transition forKey:@""];
        self.window.rootViewController = tabbar;
    }
}

#pragma mark ====== 接收到登录的通知 =======
-(void)getLoginNotification{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    JHLoginVC *vc = [[JHLoginVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    UIViewController *topVC = [self topViewController];
    if ([topVC isKindOfClass:[JHLoginVC class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [topVC presentViewController:nav animated:YES completion:nil];
    });
}

- (UIViewController*)topViewController
{
    //解决Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!问题
    return [self topViewControllerWithRootViewController:self.window.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
    
}

#pragma mark ====== 极光推送相关 =======
// 注册极光
-(void)registerJPush:(NSDictionary *)dic{
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc]init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:dic appKey:JPUSHKEY channel:@"App Store" apsForProduction:NO];
    [NoticeCenter addObserver:self selector:@selector(getRegistrationID) name:kJPFNetworkDidLoginNotification object:nil];
}

// 获取极光推送的registrationID
- (void)getRegistrationID
{
    NSString *registrationID = [JPUSHService registrationID];
    [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark ====== 支付处理 =======
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    BOOL result_wx = [WXApi handleOpenURL:url delegate:self];
    result = result || result_wx;
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
        return YES;
    }
    
    return result;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    BOOL result_wx = [WXApi handleOpenURL:url delegate:self];
    result = result || result_wx;
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
        return YES;
    }
    
    return result;
}

// 微信支付处理
-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        return;
    }
    switch (resp.errCode) {
        case WXSuccess:
            [NoticeCenter postNotificationName:WXSuccessPay_Notification object:nil];
            break;
            
        default:
            [NoticeCenter postNotificationName:WXFailPay_Notification object:nil];
            break;
    }
    
}

#pragma mark ====== UIApplicationDelegate =======
// 注册 DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    if (SupportAliYunPush) {
        [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"Register deviceToken success, deviceToken: %@", [CloudPushSDK getApnsDeviceToken]);
            } else {
                NSLog(@"Register deviceToken failed, error: %@", res.error);
            }
        }];
    }else [JPUSHService registerDeviceToken:deviceToken];
    
    //注册设备号给美洽
    [MQManager registerDeviceToken:deviceToken];
}

// 实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //非点击通知,收到通知的处理
        [self handleiOSRemoteNotification:notification onClick:NO];
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert|
                      UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound);
    
    //美洽声音处理
    UIApplication * application  = [UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateActive) {
        NSString *haveMeiqiaMsg = userInfo[@"type"];
        if ([haveMeiqiaMsg isEqualToString:@"meiqia"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"meiqia_haveMsg" object:nil];
            //播放声音
            [self.mq_audioPlay play];
        }
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    completionHandler();  // 系统要求执行这个方法
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        // 点击时,收到通知的处理
        [self handleiOSRemoteNotification:response.notification onClick:YES];
    }
    
    
}

// 接收到通知的方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    //判断系统版本,低于iOS10 执行方法体
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_9_x_Max) {
        if (application.applicationState == UIApplicationStateBackground || application.applicationState == UIApplicationStateInactive) {
//            if ([userInfo[@"type"] isEqualToString:@"order"]){
                NSString *link_url = userInfo[@"link_url"]?userInfo[@"link_url"]:@"";
                if ([link_url.lowercaseString containsString:@"http"]) {
                    [[self topViewController].navigationController pushViewController:[JHJumpRouteModel jumpWithLink:userInfo[@"link_url"]] animated:YES];
                }
//            }
            // 美洽声音处理
            if ([userInfo[@"type"] isEqualToString:@"meiqia"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"meiqia_haveMsg" object:nil];
                //播放声音
                [self.mq_audioPlay play];
            }
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if(SupportAliYunPush) [self syncBadgeNum:0];
    else  [JPUSHService setBadge:0];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [WMShopDBModel shareWMShopDBModel].current_shopcartNum = 0;
    [WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC = NO;
    [[JHConfigurationTool shareJHConfigurationTool] saveConfiguration];
    [[JRDBMgr shareInstance] close];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //进入前台 打开meiqia服务
    [MQManager openMeiqiaService];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 进入后台 关闭美洽服务
    [MQManager closeMeiqiaService];
}

#pragma mark ====== 阿里云推送处理 =======
#pragma mark APNs Register
/**
 *    向APNs注册，获取deviceToken用于推送
 */
- (void)registerAPNS:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        // iOS 10 notifications
        _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        _notificationCenter.delegate = self;
        // 请求推送权限
        [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // granted
                NSLog(@"User authored notification.");
                // 向APNs注册，获取deviceToken
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
            } else {
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    } else if (systemVersionNum >= 8.0) {
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
#pragma clang diagnostic pop
    }
}

#pragma mark SDK Init
- (void)initCloudPush {
    // 正式上线建议关闭
    [CloudPushSDK turnOnDebug];
    //     SDK初始化，手动输出appKey和appSecret
    [CloudPushSDK asyncInit:AliYunPushKey appSecret:AliYunPushSecret callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            // 保存 getDeviceId
            [[NSUserDefaults standardUserDefaults] setObject:[CloudPushSDK getDeviceId] forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
    
}

#pragma mark Notification Open
/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    
    if (application.applicationState == UIApplicationStateBackground || application.applicationState == UIApplicationStateInactive) {
//        if ([userInfo[@"type"] isEqualToString:@"order"]){
    
            NSString *link_url = userInfo[@"link_url"]?userInfo[@"link_url"]:@"";
            if ([link_url.lowercaseString containsString:@"http"]) {
                [[self topViewController].navigationController pushViewController:[JHJumpRouteModel jumpWithLink:userInfo[@"link_url"]] animated:YES];
            }
//        }
    }

    application.applicationIconBadgeNumber = 0;
    if (SupportAliYunPush) {
        // 同步通知角标数到服务端
        [self syncBadgeNum:0];
        [CloudPushSDK sendNotificationAck:userInfo];
    }
}

#pragma mark Receive Message
/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知，并上报通知打开回执
    [self handleiOSRemoteNotification:notification onClick:NO];
    // 通知不弹出
    completionHandler(UNNotificationPresentationOptionNone);
    
    // 通知弹出，且带有声音、内容和角标
    //    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

#pragma mark Click Message
/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        [self handleiOSRemoteNotification:response.notification onClick:NO];
    }
    completionHandler();
}

#pragma mark DealWith Message
/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOSRemoteNotification:(UNNotification *)notification  onClick:(BOOL)onClick{
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (onClick && [self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
            
            NSString *link_url = userInfo[@"link_url"]?userInfo[@"link_url"]:@"";
            if ([link_url.lowercaseString containsString:@"http"]) {
                [[self topViewController].navigationController pushViewController:[JHJumpRouteModel jumpWithLink:link_url] animated:YES];
            }
        }
    
    // 通知角标数清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (SupportAliYunPush) {
        // 同步角标数到服务端
        [self syncBadgeNum:0];
        // 通知打开回执上报
        [CloudPushSDK sendNotificationAck:userInfo];
    }
    //处理平台红包
    if ([userInfo[@"type"] isEqualToString:@"hongbao"]) {
        NSDictionary *hongbaoDic = [self handlePlatformHongbao:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:K_show_platform_hongbao object:hongbaoDic];
    }
}
//处理平台红包
- (NSDictionary *)handlePlatformHongbao:(NSDictionary *)userInfo{
    //处理平台红包
    if ([userInfo[@"type"] isEqualToString:@"hongbao"]) {
        NSArray *items = userInfo[@"items"];
        if (items.count == 0) {
            return @{};
        }else{
            NSString *link_url = userInfo[@"link_url"] ? userInfo[@"link_url"] : @"";
            NSDictionary *hongbaoDic = @{@"items":items,
                                         @"link_url":link_url,
                                         @"type":@"3",
                                         @"background":userInfo[@"background"],
                                         @"background_color":userInfo[@"background_color"]};
            return hongbaoDic;
        } 
    }
    return @{};
}

/* 同步通知角标数到服务端 */
- (void)syncBadgeNum:(NSUInteger)badgeNum {
    [CloudPushSDK syncBadgeNum:badgeNum withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Sync badge num: [%lu] success.", (unsigned long)badgeNum);
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self syncBadgeNum:0];
            });
            NSLog(@"Sync badge num: [%lu] failed, error: %@", (unsigned long)badgeNum, res.error);
        }
    }];
}

-(AVAudioPlayer *)mq_audioPlay{
    if (_mq_audioPlay==nil) {
        _mq_audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"maiqiamsg" ofType:@"mp3"]] error:nil];
        _mq_audioPlay.volume = 1;
    }
    return _mq_audioPlay;
}


@end
