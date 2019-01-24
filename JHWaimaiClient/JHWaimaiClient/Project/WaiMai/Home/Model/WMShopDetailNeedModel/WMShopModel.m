//
//  WaiMaiShopModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopModel.h"
//#import "WMShopGoodModel.h"
#import <MJExtension.h>

@implementation WMShopModel



+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"cateArr":@"items"};
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"cateArr":@"WMShopCateModel",@"tj_items":@"WMShopCateModel"};
}

-(int)status{
    if (_yy_status == 1 && _yysj_status == 1) {
        return 1;
    }
    return 0;
}

-(NSArray *)getCoudanArrWith:(float)couDanPrice{
    NSMutableArray *arr = [NSMutableArray array];
    for (WMShopCateModel *cate in _cateArr) {
        if ([cate.cate_id isEqualToString:@"hot"]) {
            continue;
        }
        for (WMShopGoodModel *good in cate.products) {
            if (!good.is_discount&&!good.is_spec && [good.price floatValue] <= couDanPrice && good.sale_sku > 0 && [good.price floatValue] > 0) {
                
                BOOL is_contains = NO;
                for (WMShopGoodModel *subGood in arr) {
                    if ([subGood.product_id isEqualToString:good.product_id]) {
                        is_contains = YES;
                        break;
                    }
                }
                if (!is_contains) {
                    [arr addObject:good];
                }
                
            }
        }
    }
    
    NSArray *coudan_arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[obj1 price] floatValue] > [[obj2 price] floatValue];
    }];
    return coudan_arr;
}

-(void)searchProductWithKeyword:(NSString *)keyword block:(DataBlock)block{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *arr = [NSMutableArray array];
        for (WMShopCateModel * cate in self.cateArr) {
            if ([cate.cate_id isEqualToString:@"hot"]) {
                continue;
            }
            for (WMShopGoodModel *good in cate.products) {
                NSLog(@"%d",good.is_discount);
                if ([good.title containsString:keyword]) {
                    
                    BOOL is_contains = NO;
                    for (WMShopGoodModel *subGood in arr) {
                        if ([subGood.product_id isEqualToString:good.product_id]) {
                            is_contains = YES;
                            break;
                        }
                    }
                    if (!is_contains) {
                        [arr addObject:good];
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
             block(arr.copy,@"");
        });
    });
 
}

-(NSString *)yy_time{
    NSString *str = @"";
    for (NSDictionary *dic  in _yy_peitime) {
        NSString *time;
        if (str.length == 0) {
            time = [NSString stringWithFormat:@"%@ - %@",dic[@"stime"],dic[@"ltime"]];
        }else{
            time = [NSString stringWithFormat:@" %@ - %@",dic[@"stime"],dic[@"ltime"]];
        }
        str = [str stringByAppendingString:time];
    }
    return str;
}
//-(BOOL)is_show_more{
//    return NO;
//}

-(BOOL)can_zero_ziT{
    if (self.can_zero_ziti.integerValue == 0) {
        return NO;
    }else{
        return YES;
    }
}
+(void)getShopDetailWith:(NSString *)shop_id block:(ModelBlock)block{
    [HttpTool postWithAPI:@"client/waimai/shop/detail" withParams:@{@"shop_id":shop_id} success:^(id json) {
        NSLog(@"商家详情 =======  %@",json);
        if (ISPostSuccess) {
            WMShopModel * model = [WMShopModel mj_objectWithKeyValues:json[@"data"][@"detail"]];
            block(model,nil);
        }else{
            block(nil,Error_Msg);
        }
    } failure:^(NSError *error) {
        block(nil,NOTCONNECT_STR);
    }];
}
+(void)collectShopWith:(NSString *)shop_id status:(int)status block:(MsgBlock)block{
    
    [HttpTool postWithAPI:@"client/member/collect/collect" withParams:@{@"status":@(status),@"can_id":shop_id,@"type":@"waimai"} success:^(id json) {
        NSLog(@"收藏商家 =======  %@",json);
        if (ISPostSuccess) {
            block(YES,Error_Msg);
        }else{
            block(NO,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(NO,NOTCONNECT_STR);
    }];
}
+(void)getShopDetailInfoWith:(NSString *)shop_id block:(ModelBlock)block{
    [HttpTool postWithAPI:@"client/waimai/shop/info" withParams:@{@"shop_id":shop_id} success:^(id json) {
        NSLog(@"商家详情信息 =======  %@",json);
        if (ISPostSuccess) {
            WMShopModel * model = [WMShopModel mj_objectWithKeyValues:json[@"data"][@"detail"]];
            block(model,nil);
        }else{
            block(nil,Error_Msg);
        }
    } failure:^(NSError *error) {
        block(nil,NOTCONNECT_STR);
    }];
}

+(void)searchWMShopListWithKW:(NSString *)keyword page:(int)page block:(DataBlockAndColor)block{
    
    [HttpTool postWithAPI:@"client/waimai/shop/search" withParams:@{@"title":keyword,@"type":@"shop",@"page":@(page)} success:^(id json) {
        
        NSLog(@"搜索商家列表 =======  %@",json);
        
        if (ISPostSuccess) {
            NSArray *arr = [WMShopModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,Error_Msg,json[@"data"][@"color"]);
        }else{
            block(nil,Error_Msg,nil);
        }
        
    } failure:^(NSError *error) {
        block(nil,NOTCONNECT_STR,nil);
    }];
    
}

@end
