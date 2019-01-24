//
//  JHConfigurationTool.m
//  JHShequClient_V3
//
//  Created by ios_yangfei on 17/4/1.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import "JHConfigurationTool.h"
#import "DSToast.h"
#import "AppDelegate.h"
#import <MJExtension.h>

#import <SDWebImageDownloaderOperation.h>
#import <SDImageCache.h>

@interface JHConfigurationTool ()
@property(nonatomic,strong)DSToast *textToast;
@property(nonatomic,strong)Reachability *reach;
@end

@implementation JHConfigurationTool
YFSingleTonM(JHConfigurationTool)


#pragma mark ====== Functions =======
// 获取city_id
-(void)getSubstationCity_id:(NSString *)adcode block:(MsgBlock)block{
    if (IsHaveFenZhan == NO) {
        //如果没有分站功能且请求失败,默认返回city_id为99999
        block(YES,@"99999");
        return;
    }
    [HttpTool postWithAPI:@"magic/citycode" withParams:@{@"code":adcode,@"citycode":@"0551"} success:^(id json) {
        NSLog(@"获取city_id =======  %@",json);
        if (ISPostSuccess) {
            block(YES,json[@"data"][@"city_id"]);
        }else{
            if(IsHaveFenZhan){
                block(NO,@"");
                NSLog(@"error : %@",json[@"message"]);
            }else{
                //如果没有分站功能且请求失败,默认返回city_id为99999
                block(YES,@"99999");
            }
        }
    } failure:^(NSError *error) {
        if (IsHaveFenZhan) {
            block(NO,@"");
        }else{
            //如果没有分站功能且请求失败,默认返回city_id为99999
            block(YES,@"99999");
        }
        NSLog(@"error : %@",error.description);
    }];
}

// 网络状态监听
-(void)startReachability{

    _reach = [Reachability reachabilityForInternetConnection];
//    _reach.reachableOnWWAN = NO;
    [NoticeCenter addObserver:self
                     selector:@selector(reachabilityChanged:)
                         name:kReachabilityChangedNotification
                       object:nil];
    [_reach startNotifier];
    NetworkStatus status = [_reach currentReachabilityStatus];
    self.netStatus = status;
    
}

//  获取当前网络的相关状态
- (void)reachabilityChanged:(NSNotification *)noti
{
    NetworkStatus status = [_reach currentReachabilityStatus];
    self.netStatus = status;

    NSString *title = @"";
    if(status == NotReachable){
        title =  NSLocalizedString(@"网络已断开连接!", NSStringFromClass([self class]));
    }else if(status == ReachableViaWWAN){
        title = NSLocalizedString(@"已切换到蜂窝数据", NSStringFromClass([self class]));
    }else if(status == ReachableViaWiFi){
        title =  NSLocalizedString(@"已切换到WiFi网络", NSStringFromClass([self class]));
    }
    
    self.textToast.text  = title;
    [self.textToast showInView:((AppDelegate *)[UIApplication sharedApplication].delegate).window showType:DSToastShowTypeCenter withBlock:^{
    }];
    
}

// 获取启动广告页
-(void)getLaunchAds{
    
    [HttpTool postWithAPI:@"client/adv/start" withParams:@{} success:^(id json) {
        NSLog(@"启动广告页 =======  %@",json);
        if (ISPostSuccess) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.launchAds = json[@"data"][@"items"];
                [self saveConfiguration];
                [self cachesImgs];
            });
        }
        
    } failure:^(NSError *error) {
      
    }];
    
}

// 缓存启动广告图片
-(void)cachesImgs{

    for (NSDictionary *dic in _launchAds) {
        NSURL *url = [NSURL URLWithString:ImageUrl(dic[@"thumb"])];
        
        [[SDImageCache sharedImageCache] diskImageExistsWithKey:url.absoluteString completion:^(BOOL isInCache) {
            if (!isInCache) {// 已经缓存过的不缓存(否则控制台输出 This method should be called from the ioQueue)
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:url.absoluteString];
                }];
            }
        }];
        
    }

}

#pragma mark ====== 存储 =======
-(void)saveConfiguration{
    NSDictionary *dic = @{@"city_id":_city_id ? _city_id : @"",
                          @"cityCode":_cityCode ? _cityCode : @"",
                          @"cityName":_cityName ? _cityName : @"",
                          @"lat":@(_lat),
                          @"lng":@(_lng),
                          @"launchAds":_launchAds};
    [[NSUserDefaults standardUserDefaults] setValue:dic forKey:@"JHConfigurationTool"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)getConfiguration{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"JHConfigurationTool"];
    [JHConfigurationTool mj_objectWithKeyValues:dic];
}

#pragma mark ====== Setter =======
-(void)setCityCode:(NSString *)cityCode{
    _cityCode = cityCode;
    cityCode = cityCode == nil ? @"" : cityCode;
    [[NSUserDefaults standardUserDefaults] setObject:cityCode forKey:@"cityCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setCity_id:(NSString *)city_id{
    _city_id = city_id;
    city_id = city_id == nil ? @"" : city_id;
    [[NSUserDefaults standardUserDefaults] setObject:city_id forKey:@"city_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setLat:(double)lat{
    _lat = lat;
    [[NSUserDefaults standardUserDefaults] setValue:@(lat) forKey:@"app.lat"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setLng:(double)lng{
    _lng = lng;
    [[NSUserDefaults standardUserDefaults] setValue:@(lng) forKey:@"app.lng"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark ====== Getter =======
-(DSToast *)textToast{
    if (_textToast == nil) {
        _textToast = [[DSToast alloc] init];
        _textToast.backgroundColor = HEX(@"ffb54c", 1);
        _textToast.textColor = [UIColor whiteColor];
    }
    return _textToast;
}

-(BOOL)first_launch_app{
    
    BOOL is_first =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst_launch_app_4.3"] boolValue];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isFirst_launch_app_4.3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return !is_first;
}

-(NSArray *)launchAds{
    if (_launchAds.count > 0) {
        NSInteger dateline = [[NSDate date] timeIntervalSince1970];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in _launchAds) {
            // 判断广告是否有效
            NSInteger ltime = [dic[@"ltime"] integerValue];
            NSInteger stime = [dic[@"stime"] integerValue];
            if (((ltime > 0 && ltime < dateline) || stime > dateline) == NO) {
                [arr addObject:dic];
            }
        }
        return arr.copy;
    }
 return @[];
}

-(void)dealloc{
    Remove_Notice
}

@end
