//
//  ZQAppVersionTool.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/8/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQAppVersionTool.h"
#import "JHShowAlert.h"
@implementation ZQAppVersionTool

/**
 判断是否需要升级的接口

 @param api 升级的接口的api
 */
+(void)postToSureThatIsNeedUpgradeVersion:(NSString*)api{
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
    NSString *vers = dic[@"CFBundleShortVersionString"];
    [HttpTool postWithAPI:api withParams:@{} success:^(id json) {
        NSLog(@"更新版本的信息%@",json);
        NSString *client_api= @"";
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSArray *arr = [infoDic objectForKey:@"CFBundleURLTypes"];
        for (NSDictionary *dic in arr) {
            if ([dic[@"CFBundleURLName"] isEqualToString:@"APP_TYPE"]) {
                NSArray *urlArr = dic[@"CFBundleURLSchemes"];
                if ([urlArr containsObject:@"BIZ"]) {
                    client_api = @"BIZ";
                }else if ([urlArr containsObject:@"STAFF"]) {
                    client_api = @"STAFF";
                }else{
                    client_api = @"CUSTOM";
                }
            }
        }
        NSString *ios_version = @"";
        NSString *ios_force_update =@"";
        NSString *ios_intro = @"";
        NSString *ios_download = @"";
        if ([client_api isEqualToString:@"CUSTOM"]) {
            ios_version = json[@"data"][@"ios_client_version"];
            ios_force_update = json[@"data"][@"ios_client_force_update"];
            ios_intro = json[@"data"][@"ios_client_intro"];
            ios_download = json[@"data"][@"ios_client_download"];
        }else if ([client_api isEqualToString:@"STAFF"]){
            ios_version = json[@"data"][@"ios_staff_version"];
            ios_force_update = json[@"data"][@"ios_staff_force_update"];
            ios_intro = json[@"data"][@"ios_staff_intro"];
            ios_download = json[@"data"][@"ios_staff_download"];
        }else if ([client_api isEqualToString:@"BIZ"]){
            ios_version = json[@"data"][@"ios_biz_version"];
            ios_force_update = json[@"data"][@"ios_biz_force_update"];
            ios_intro = json[@"data"][@"ios_biz_intro"];
            ios_download = json[@"data"][@"ios_biz_download"];
        }
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([ios_version compare:vers] != NSOrderedDescending) {
                return;
            }
            if ([[ios_force_update description] isEqualToString:@"0"]) {
            [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示",nil) withMessage:ios_intro withBtn_cancel:NSLocalizedString(@"取消",nil) withBtn_sure:NSLocalizedString(@"确定",nil) withController:nil withCancelBlock:^{
                     [JHUserModel shareJHUserModel].isNotUpdate =YES;
                } withSureBlock:^{
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ios_download]];
                }];
            }else{
                [JHShowAlert showAlertWithMsg:ios_intro withBtnTitle:NSLocalizedString(@"确定",nil) withController:nil withBtnBlock:^{
                     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ios_download]];
                }];
            }
        }
    } failure:^(NSError *error) {}];
}
@end
