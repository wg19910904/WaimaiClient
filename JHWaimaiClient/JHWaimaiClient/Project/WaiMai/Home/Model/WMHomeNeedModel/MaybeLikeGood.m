//
//  MaybeLikeGood.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/4/28.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "MaybeLikeGood.h"

#import <MJExtension.h>

@implementation MaybeLikeGood

+(void)searchWMProductsListWithKW:(NSString *)keyword page:(int)page block:(DataBlock)block{
    
    [HttpTool postWithAPI:@"client/waimai/shop/search" withParams:@{@"title":keyword,@"type":@"product",@"page":@(page)} success:^(id json) {
        
        NSLog(@"搜索商品列表 =======  %@",json);
        
        if (ISPostSuccess) {
            NSArray *arr = [MaybeLikeGood mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(nil,NOTCONNECT_STR);
    }];
    
}
@end
