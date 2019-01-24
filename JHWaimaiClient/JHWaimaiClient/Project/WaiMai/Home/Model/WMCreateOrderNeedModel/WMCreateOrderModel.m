//
//  WMCreateOrderModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/10.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMCreateOrderModel.h"

#import "NSString+Tool.h"

@implementation WMCreateOrderModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"huangous":@"WMShopGoodModel"};
}

-(BOOL)show_first_switch{
    return (_first_order && !_support_first_share);
}

//-(NSString *)getOrderAmountWith:(BOOL)on_linePay ziti:(BOOL)is_ziti{
//    
//    float amount = [self.product_price floatValue] + [self.package_price floatValue] + self.card_amount;
//    
//    for (NSDictionary *dic in _youhui) {
//        amount -= [dic[@"amount"] floatValue];
//    }
//    amount -= [_hongbao_amount floatValue];
//    amount -= [_coupon_amount floatValue];
//    amount = MAX(amount, 0.01);
//    
//    if (!is_ziti) {
//        amount += [self.freight_stage floatValue];
//    }
    
//    if (on_linePay) {
//
//        for (NSDictionary *dic in _youhui) {
//            amount -= [dic[@"amount"] floatValue];
//        }
//        amount -= [_hongbao_amount floatValue];
//        amount -= [_coupon_amount floatValue];
//        amount = MAX(amount, 0.01);
//        if (!is_ziti) {
//            amount += [self.freight_stage floatValue];
//        }
//
//    }else{
//        if (!is_ziti) {
//           amount += [self.freight_stage floatValue];
//        }
//    }
//
    
//    return [NSString getStrFromFloatValue:amount bitCount:2];
//
//}

-(NSString *)hongbao_amount{
    return [NSString getStrFromFloatValue:[_hongbao_amount floatValue] bitCount:2];
}

-(NSString *)coupon_amount{
    return [NSString getStrFromFloatValue:[_coupon_amount floatValue] bitCount:2];
}

-(NSArray *)getTimesArr:(BOOL)is_ziti{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i=0; i<_day_dates.count; i++) {
        
        NSDictionary *dic = _day_dates[i];
        NSMutableDictionary *subDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if (i == 0) {
            NSString *time_str = is_ziti ? NSLocalizedString(@"立即自提", nil) : NSLocalizedString(@"立即送达", nil);
            NSMutableArray *time_arr = [NSMutableArray arrayWithArray:_set_time_date[@"set_time"]];
            if (time_arr.count > 0) {
                if ([time_arr[0] isEqualToString:@"0"]) {
                    [time_arr replaceObjectAtIndex:0 withObject:time_str];
                }
                subDic[@"times"] = time_arr;
            }else{
               subDic[@"times"] = _set_time_date[@"nomal_time"];
            }
            
        }else{
            subDic[@"times"] = _set_time_date[@"nomal_time"];
        }
        
        [arr addObject:subDic];
        
    }
    
    return arr.copy;
    
}

+(void)getCreateOrderDetailWith:(NSString *)shop_id isZiti:(NSString *)isZiti block:(ModelBlock)block{
    
    NSString *order_products = [WMShopDBModel shareWMShopDBModel].order_products;
    if ([WMShopDBModel shareWMShopDBModel].moreShopCartProductStr.length > 0) {
        order_products = [WMShopDBModel shareWMShopDBModel].moreShopCartProductStr;
    }
    [HttpTool postWithAPI:@"client/waimai/order/order" withParams:@{@"shop_id":shop_id,@"products":order_products,@"is_ziti":isZiti} success:^(id json) {
        NSLog(@"获取订单信息 =======  %@",json);
        if (ISPostSuccess) {
            WMCreateOrderModel *model = [WMCreateOrderModel mj_objectWithKeyValues:json[@"data"]];
            model.products = order_products;
            block(model,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
          block(nil,NOTCONNECT_STR);
    }];
}

+(void)getOrderInfoWhenChangeInfo:(NSDictionary *)dic block:(ModelBlock)block{

    [HttpTool postWithAPI:@"client/waimai/order/preinfo" withParams:dic success:^(id json) {
        
        NSLog(@" 订单信息修改 =======  %@",json);
        if (ISPostSuccess) {
            WMCreateOrderModel *model = [WMCreateOrderModel mj_objectWithKeyValues:json[@"data"]];

            block(model,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(nil,NOTCONNECT_STR);
    }];
    
}

+(void)getOrder_idWith:(NSDictionary *)dic block:(MsgBlock)block{

    [HttpTool postWithAPI:@"client/waimai/order/create"
               withParams:dic success:^(id json) {
        NSLog(@"生成订单id =======  %@",json);
        if (ISPostSuccess) {
            [JHUserModel shareJHUserModel].money = json[@"data"][@"member"][@"money"];
            block(YES,json[@"data"][@"order_id"]);
        }else{
            block(NO,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(NO,NOTCONNECT_STR);
    }];
}

@end
