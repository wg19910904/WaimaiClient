//
//  JHUserAccountSetViewModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHUserAccountSetViewModel.h"

@implementation JHUserAccountSetViewModel
/**
 修改密码的接口
 
 @param dic 需要传入的数据
 @param myBlock 回调的接口
 */
+(void)postToRevisePsdWithDic:(NSDictionary *)dic
                        block:(void(^)(NSString * error))myBlock{
    [HttpTool postWithAPI:@"client/member/passwd" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *str = nil;
        if (!ISPostSuccess) {
            str = Error_Msg;
        }
        if (myBlock) {
            myBlock(str);
        }

    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
/**
 换绑手机的接口
 
 @param dic 需要的数据
 @param myBlock 回调的结果
 */
+(void)postToChangePhoneWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString * error))myBlock{
    [HttpTool postWithAPI:@"client/member/updatemobile" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *str = nil;
        if (!ISPostSuccess) {
            str = Error_Msg;
        }
        if (myBlock) {
            myBlock(str);
        }
        
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];

}
/**
 修改昵称的接口
 @param dic 需要的数据
 @param myBlock 回调的结果
 */
+(void)postToChangeNickNameWithDic:(NSDictionary *)dic
                             block:(void(^)(NSString * error))myBlock{
    [HttpTool postWithAPI:@"client/member/updatename" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *str = nil;
        if (!ISPostSuccess) {
            str = Error_Msg;
        }
        if (myBlock) {
            myBlock(str);
        }
        
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
/**
 上传头像的接口
 
 @param dic 需要的数据
 @param myBlock 回调的结果
 */
+(void)postToUpHeaderImgWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString * error))myBlock{
    [HttpTool postWithAPI:@"client/member/updateface" params:@{} dataDic:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *str = nil;
        if (!ISPostSuccess) {
            str = Error_Msg;
        }
        if (myBlock) {
            myBlock(str);
        }

    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
/**
 改变性别的接口
 
 @param dic 需要传入的数据
 @param myBlock 回调的结果
 */
+(void)postToChangeSexWithDic:(NSDictionary *)dic
                        block:(void(^)(NSString * error))myBlock{
    
    [HttpTool postWithAPI:@"client/member/updatesex" withParams:dic
                  success:^(id json) {
                      NSLog(@"%@",json);
                      NSString *str = nil;
                      if (!ISPostSuccess) {
                          str = Error_Msg;
                      }
                      if (myBlock) {
                          myBlock(str);
                      }
                  } failure:^(NSError *error) {
                      if (myBlock) {
                          myBlock(NOTCONNECT_STR);
                      }
                  }];
}
/**
 绑定微信的方法
 
 @param dic 需要传入的数据
 @param myBlock 回调的结果
 */
+(void)postToBindeWeixinWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString *error))myBlock{
    [HttpTool postWithAPI:@"client/member/bindweixin" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
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
 解除绑定微信的方法
 
 @param dic 需要传入的数据
 @param myBlock 回调的结果
 */
+(void)postToNoBindeWeixinWithDic:(NSDictionary *)dic
                            block:(void(^)(NSString *error))myBlock{
    
    [HttpTool postWithAPI:@"client/member/nobindweixin" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
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

@end
