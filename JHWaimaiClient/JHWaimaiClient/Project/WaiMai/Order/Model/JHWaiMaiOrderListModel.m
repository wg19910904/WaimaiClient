//
//  JHWaiMaiOrderListModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiOrderListModel.h"
#import "NSString+Tool.h"
@implementation JHWaiMaiOrderListModel
-(NSString *)dateline{
    NSString *str = [NSString formateDate:@"yyyy-MM-dd HH:mm:ss" dateline:[_dateline integerValue]];
    return str;
}
-(NSInteger)pay_time{
    NSDate * date = [NSDate date];
    NSInteger dateLine = [date timeIntervalSince1970];
    NSInteger time = [_dateline integerValue] + [_pay_ltime integerValue]*60 - dateLine;
    NSLog(@"%ld",time);
    return time;
}

-(NSInteger)dao_time{
    _dao_time =  [_dateline integerValue] + [_pay_ltime integerValue]*60;
    return  _dao_time;
}
-(NSString *)amount{
    float a = [_amount floatValue];
    float b = [_money floatValue];
    float c = a+b;
    return [NSString stringWithFormat:@"%.2f",c];
}
-(NSString *)order_status_label{
    return _msg ;
}
@end
