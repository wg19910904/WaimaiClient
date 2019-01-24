//
//  JHLoginAndRegisterViewModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHLoginAndRegisterViewModel.h"

#import "JHUserModel.h"
@implementation JHLoginAndRegisterViewModel
/**
 获取验证码的接口
 
 @param dic 需要的参数
 @param myBlock 回调结果的block
 */
+(void)postTosendSmsWithDic:(NSDictionary *)dic block:(void(^)(NSString *error,NSString *sms_code))myBlock{
    [HttpTool postWithAPI:@"magic/sendsms" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        NSString *code = nil;
        if (!ISPostSuccess) {
            err = Error_Msg;
        }else{
            code = json[@"data"][@"sms_code"];
        }
        
        if (myBlock) {
            myBlock(err,code);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR,nil);
        }
    }];
}
/**
 会员注册的接口
 
 @param dic 需要的数据
 @param myBlock 结果的回调
 */
+(void)postToRegisteWithDic:(NSDictionary *)dic
                      block:(void(^)(NSString *error))myBlock
                 newHongbao:(void(^)(BOOL have_newhb,NSString *newhb_link))hongbao{
    
    [HttpTool postWithAPI:@"client/passport/signup" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString * err = nil;
        if (ISPostSuccess) {
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [JHUserModel mj_objectWithKeyValues:json[@"data"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
        NSString *have_newhb = json[@"data"][@"have_newhb"];
        NSString *newhb_link = json[@"data"][@"newhb_link"];
        if (hongbao && ISPostSuccess) {
            hongbao(have_newhb.integerValue == 1,newhb_link);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
/**
 会员登陆的接口
 
 @param dic 需要的数据
 @param myBlock 结果的回调
 */
+(void)postToLoginWithDic:(NSDictionary *)dic
                    block:(void(^)(NSString *error))myBlock{
    
    [HttpTool postWithAPI:@"client/passport/login" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString * err = nil;
        if (ISPostSuccess) {
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [JHUserModel mj_objectWithKeyValues:json[@"data"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
/**
 找回密码的接口
 
 @param dic 需要的数据
 @param myBlock 回调的结果
 */
+(void)postToFindPsdWithDic:(NSDictionary *)dic
                      block:(void(^)(NSString *error))myBlock{
    [HttpTool postWithAPI:@"client/passport/forgot" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString * err = nil;
        if (!ISPostSuccess) {
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];

}
/**
 会员快捷登录的接口
 
 @param dic 需要传入的数据
 @param myBlock 回调结果的block
 */
+(void)postToFastLoginWithDic:(NSDictionary *)dic
                        block:(void(^)(NSString *error))myBlock{
    [HttpTool postWithAPI:@"client/passport/login" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString * err = nil;
        if (ISPostSuccess) {
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
             [JHUserModel mj_objectWithKeyValues:json[@"data"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
/**
 微信登录的接口
 
 @param dic 传入的数据
 @param myBlock 回调结果的block
 */
+(void)postToWeixinLoginWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString *error))myBlock{
    [HttpTool postWithAPI:@"client/passport/wxlogin" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString * err = nil;
        if (ISPostSuccess) {
            if (![json[@"data"][@"wxtype"] isEqualToString:@"wxbind"]){
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
            }
          [JHUserModel mj_objectWithKeyValues:json[@"data"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }

    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];

    
}
/**
 绑定微信的接口
 
 @param dic 传入的数据
 @param myBlock 回调结果的block
 */
+(void)postBindWeixinLoginWithDic:(NSDictionary *)dic
                            block:(void(^)(NSString *error))myBlock
                       newHongbao:(void(^)(BOOL have_newhb,NSString *newhb_link))hongbao{
    [HttpTool postWithAPI:@"client/passport/wxbind" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString * err = nil;
        if (ISPostSuccess) {
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [JHUserModel mj_objectWithKeyValues:json[@"data"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
        NSString *have_newhb = json[@"data"][@"have_newhb"];
        NSString *newhb_link = json[@"data"][@"newhb_link"];
        if (hongbao && ISPostSuccess) {
            hongbao(have_newhb.integerValue == 1,newhb_link);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
@end
