//
//  JHWaimaiMineViewModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiMineViewModel.h"
#import "JHUserModel.h"

@implementation JHWaimaiMineViewModel
/**
 获取会员信息的接口
 
 @param myBlock 结果的回调
 */
+(void)postToGetUserInfoWithBlock:(void(^)(NSString *error))myBlock{
    [HttpTool postWithAPI:@"client/member/info" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        if (ISPostSuccess) {
             [JHUserModel mj_objectWithKeyValues:json[@"data"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
/**
 退出登录的操作
 */
+(void)postToQuitLogin{
    [HttpTool postWithAPI:@"client/passport/loginout" withParams:@{} success:^(id json) {
        [self remove];
    } failure:^(NSError *error) {
        [self remove];
    }];
}
+(void)remove{
    [JHUserModel shareJHUserModel].mall_order_count = @{};
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NoticeCenter postNotificationName:QuitLogin object:nil];
    });

}
/**
 获取我的地址的接口
 
 @param dic 需要的参数
 @param myBlock 回调的结果
 */
+(void)postToGetMyAddressWithDic:(NSDictionary *)dic is_paotui:(BOOL)is_paotui
                           block:(void(^)(JHWaimaiMineAddressListModel * model,NSString *error))myBlock{
    NSString *api = is_paotui ? @"client/paotui/addr/items" : @"client/member/addr/index";
    if (is_paotui) {
        [HttpTool postWithAPI:api withParams:dic success:^(id json) {
            NSLog(@"%@",json);
            NSString *err = nil;
            JHWaimaiMineAddressListModel * model = [[JHWaimaiMineAddressListModel alloc]init];
            if (ISPostSuccess) {
                model.items = [JHWaimaiMineAddressListDetailModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            }else{
                err = Error_Msg;
            }
            if (myBlock) {
                myBlock(model,err);
            }
            
        } failure:^(NSError *error) {
            if (myBlock) {
                myBlock(nil,NOTCONNECT_STR);
            }
            
        }];
    }else{
        [HttpTool postWithAPI:api withParams:dic success:^(id json) {
            NSLog(@"%@",json);
            NSString *err = nil;
            JHWaimaiMineAddressListModel * model = [[JHWaimaiMineAddressListModel alloc]init];
            if (ISPostSuccess) {
                model = [JHWaimaiMineAddressListModel mj_objectWithKeyValues:json[@"data"]];
            }else{
                err = Error_Msg;
            }
            if (myBlock) {
                myBlock(model,err);
            }
            
        } failure:^(NSError *error) {
            if (myBlock) {
                myBlock(nil,NOTCONNECT_STR);
            }
            
        }];
    }
}
/**
 下单的时候获取地址列表
 
 @param dic 需要的参数
 @param myBlock 回调的结果
 */
+(void)postToGetShopAddressWithDic:(NSDictionary *)dic
                             block:(void(^)(JHWaimaiMineAddressListModel * model,NSString *error))myBlock{
    [HttpTool postWithAPI:@"client/member/addr/orderAddr" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        JHWaimaiMineAddressListModel * model = [[JHWaimaiMineAddressListModel alloc]init];
        if (ISPostSuccess) {
            model = [JHWaimaiMineAddressListModel mj_objectWithKeyValues:json[@"data"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(model,err);
        }
        
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(nil,NOTCONNECT_STR);
        }
        
    }];
}
/**
 添加地址的接口
 
 @param dic 需要传入的数据
 @param myBlock 回调的block
 */
+(void)postToCreatAddressWithDic:(NSDictionary *)dic
                           block:(void(^)(NSString *error))myBlock{
    [HttpTool postWithAPI:@"client/member/addr/create" withParams:dic success:^(id json) {
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
 删除地址的方法
 
 @param dic 需要传入的数据
 @param myBlock 回调的结果
 */
+(void)postToRemoveAddressWithDic:(NSDictionary *)dic
                            block:(void(^)(NSString *error))myBlock{
    [HttpTool postWithAPI:@"client/member/addr/delete" withParams:dic success:^(id json) {
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
 修改地址的方法
 
 @param dic 需要传入的数据
 @param myBlock 回调的结果
 */
+(void)postToReviseAddressWithDic:(NSDictionary *)dic
                            block:(void(^)(NSString *error))myBlock{
    [HttpTool postWithAPI:@"client/member/addr/update" withParams:dic success:^(id json) {
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
 获取我的余额的界面的信息
 
 @param dic 需要传入的字符串
 @param myBlock 回调的结果
 */
+(void)postToGetBalanceRecorderWithDic:(NSDictionary *)dic
                                 block:(void(^)(JHWaimaiMyBalanceListModel *model,NSString *error))myBlock{
    [HttpTool postWithAPI:@"client/member/money/log" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        JHWaimaiMyBalanceListModel * model = [[JHWaimaiMyBalanceListModel alloc]init];
        if (ISPostSuccess) {
            model = [JHWaimaiMyBalanceListModel mj_objectWithKeyValues:json[@"data"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(model,err);
        }
        
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(nil,NOTCONNECT_STR);
        }
        
    }];
}
/**
 获取充值套餐
 
 @param myBlock 回调的结果
 */
+(void)postToGetRechargeInfo:(void(^)(NSArray * arr,NSString *error))myBlock{
    
    [HttpTool postWithAPI:@"client/payment/package" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        NSArray * arr;
        if (ISPostSuccess) {
            arr = json[@"data"][@"items"];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(arr,err);
        }
        
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(nil,NOTCONNECT_STR);
        }
        
    }];
}
@end
