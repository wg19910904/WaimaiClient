//
//  JHUserModel.m
//  JHShequClient_V3
//
//  Created by ios_yangfei on 17/4/1.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import "JHUserModel.h"

@implementation JHUserModel
YFSingleTonM(JHUserModel)
-(NSString *)token{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (str.length == 0) {
        str = nil;
    }
    return str;
}
-(NSString *)hiddenCenterMobile{
    NSString *str = self.mobile;
    if (str.length > 0) {
        NSString *str_left = [str substringToIndex:3];
        NSString *str_right = [str substringFromIndex:7];
        str = [NSString stringWithFormat:@"%@****%@",str_left,str_right];
    }
    return str;
}
-(NSString *)sex{
    if ([_sex isEqualToString:@"0"]) {
        return NSLocalizedString(@"请选择性别", nil);
    }else if([_sex isEqualToString:@"1"]){
        return NSLocalizedString(@"男", nil);
    }else if([_sex isEqualToString:@"2"]){
        return NSLocalizedString(@"女", nil);
    }else{
        return _sex;
    }
}

-(BOOL)isLogin{
    return self.token.length == 0 ? NO : YES;
}
-(NSString *)registrationID{
    NSString *regisStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"];
    return regisStr ? regisStr : @"";
}
-(NSString *)bindStatus{
    if (_isBindWX) {
        return NSLocalizedString(@"已绑定", nil);
    }else{
        return NSLocalizedString(@"未绑定", nil);

    }
}

-(NSArray *)mall_order_count_arr{
    if (self.mall_order_count.count>0) {
        return @[self.mall_order_count[@"need_pay"],self.mall_order_count[@"need_fahuo"],self.mall_order_count[@"need_shouhuo"],self.mall_order_count[@"need_comment"],self.mall_order_count[@"refund"]];
    }else{
        return @[@"0",@"0",@"0",@"0",@"0"];
    }
}

//-(NSArray *)cookieArr{
//   NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"User.cookieArr"];
//    return arr ? arr : @[];
//}
@end
