//
//  WMEvaluateModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMEvaluateModel.h"

#import <MJExtension.h>

@implementation WMEvaluateModel

+(void)getEvaluateListWith:(NSString *)shop_id page:(int)page type:(int)type is_null:(int)is_null block:(EvaluateBlock)block{
    
    NSDictionary *dic;
    if (is_null == 0) {
        dic = @{@"shop_id":shop_id,@"page":@(page),@"type":@(type)};
    }else{
        dic = @{@"shop_id":shop_id,@"page":@(page),@"type":@(type),@"is_null":@(is_null)};
    }
    [HttpTool postWithAPI:@"client/waimai/shop/comments"
               withParams:dic success:^(id json) {
        NSLog(@"商家评价列表 =======  %@",json);
        if (ISPostSuccess) {
            NSArray *dataArr = [WMEvaluateModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            NSDictionary *dic = json[@"data"][@"detail"];
            NSArray *arr = json[@"data"][@"switchnav"];
            block(dataArr,dic,arr,nil);
        }else{
            block(nil,nil,nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(nil,nil,nil,NOTCONNECT_STR);
    }];
}
@end
