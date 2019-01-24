//
//  WMHomeModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/3.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMHomeModel.h"
#import <MJExtension.h>


@implementation WMHomeModel

+(NSDictionary *)mj_objectClassInArray{
    return  @{@"adv":@"JHADModel",
              @"banner":@"JHADModel",
              @"cate_adv":@"JHADModel",
              @"shop_items":@"WMHomeShopModel"};
}

+(void)getHomeDataWithDic:(NSDictionary *)dic block:(ModelBlock)block{
    
    [HttpTool postWithAPI:@"client/waimai/index" withParams:dic success:^(id json) {
        
        NSLog(@"外卖首页数据 =======  %@",json);
        if (ISPostSuccess) {
            if ([dic[@"page"] integerValue] > 1) {
                if ([json[@"data"][@"shop_items"] count] > 0) {
                    WMHomeModel *model = [WMHomeModel mj_objectWithKeyValues:json[@"data"]];
                    block(model,nil);
                }else{
                    block([WMHomeModel new],nil);
                }
            }else{
                WMHomeModel *model = [WMHomeModel mj_objectWithKeyValues:json[@"data"]];
                block(model,nil);
            }
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
                  
        block(nil,NOTCONNECT_STR);
                  
    }];
    
}

@end
