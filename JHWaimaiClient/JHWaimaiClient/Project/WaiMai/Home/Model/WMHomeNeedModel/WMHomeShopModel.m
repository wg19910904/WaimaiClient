//
//  WMHomeShopModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/3.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMHomeShopModel.h"
#import <MJExtension.h>


@implementation WMHomeShopModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"products":@"WMHomeShopProducts"};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"shop":@"waimai"};
}

+(void)getWMShopListWithFilterDic:(NSDictionary *)dic block:(DataBlock)block{
    
    [HttpTool postWithAPI:@"client/waimai/shop/shoplist" withParams:dic success:^(id json) {
       
        NSLog(@"商家列表 =======  %@",json);
        
        if (ISPostSuccess) {
            NSArray *arr = [WMHomeShopModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(nil,NOTCONNECT_STR);
    }];
    
}

+(void)searchWMShopListWithKW:(NSString *)keyword page:(int)page block:(DataBlock)block{
    
    [HttpTool postWithAPI:@"client/waimai/shop/search" withParams:@{@"title":keyword,@"type":@"shop",@"page":@(page)} success:^(id json) {
        
        NSLog(@"搜索商家列表 =======  %@",json);
        
        if (ISPostSuccess) {
            NSArray *arr = [WMHomeShopModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(nil,NOTCONNECT_STR);
    }];
    
}

@end
