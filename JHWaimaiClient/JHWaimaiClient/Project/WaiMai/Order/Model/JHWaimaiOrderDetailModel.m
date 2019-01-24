//
//  JHWaimaiOrderDetailModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailModel.h"
#import "NSString+Tool.h"
@implementation JHWaimaiOrderDetailModel

-(NSDictionary *)show_btn{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_show_btn];
    for (NSString *key in dic.allKeys) {
        if ([key isEqualToString:@"endtime"]) {
            [dic removeObjectForKey:key];
        }
        if ([key isEqualToString:@"waiting"]) {
            [dic removeObjectForKey:key];
        }
    }
    return dic.copy;
}

-(NSString *)dateline{
    NSString * str = [NSString formateDate:@"yyyy-MM-dd HH:mm:ss" dateline:[_dateline integerValue]];
    return str;
}
-(NSString *)payment_type{
    return [_online_pay integerValue] == 1? NSLocalizedString(@"在线支付", nil):NSLocalizedString(@"货到付款", nil);
}
-(NSString *)pei_type{
    if ([_pei_type integerValue] == 3) {
        return NSLocalizedString(@"自提", nil);
    }else if([_pei_type integerValue] == 1){
        return NSLocalizedString(@"平台送", nil);
    }
    else {
        return NSLocalizedString(@"商家送", nil);
    }
}
-(NSString *)pei_time{
    if ([_pei_time isEqualToString:@"0"]) {
        if ( [_pei_type isEqualToString:@"3"]) {
             return NSLocalizedString(@"立即自提", nil);
        }
        return NSLocalizedString(@"尽快送达", nil);
    }else{
        return [NSString formateDate:@"yyyy-MM-dd HH:mm:ss" dateline:[_pei_time integerValue]];
    }
}
-(NSInteger)dao_time{
    _dao_time = [_dateline integerValue] + [_pay_ltime integerValue]*60;
    return _dao_time;
}
-(NSString *)amount{
    float a = [_amount floatValue];
    float b = [_money floatValue];
    float c = a+b;
    return [NSString stringWithFormat:@"%.2f",c];
}
-(NSString *)order_status_label{
    return _msg;
}
-(NSString *)freight{
    NSInteger a = [_freight floatValue];
    if (a == 0) {
        return NSLocalizedString(@"免配送费", nil);
    }else{
        return _freight;
    }
}
@end
