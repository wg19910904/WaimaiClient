//
//  JHWaimaiMineAddressListDetailModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiMineAddressListDetailModel.h"

@implementation JHWaimaiMineAddressListDetailModel
-(NSString *)typeName{
    NSString * str;
    if ([_type isEqualToString:@"1"]) {
        str = NSLocalizedString(@"家", nil);
    }else if([_type isEqualToString:@"2"]){
        str = NSLocalizedString(@"公司", nil);
    }else if([_type isEqualToString:@"3"]){
        str = NSLocalizedString(@"学校", nil);
    }else{
        str = NSLocalizedString(@"其他", nil);
    }
    return str;
 
}
-(NSString *)typeColor{
    NSString *str;
    if ([_type isEqualToString:@"1"]) {
        str = @"FF6660";
    }else if([_type isEqualToString:@"2"]){
        str = @"14AAE4";
    }else if([_type isEqualToString:@"3"]){
        str = @"20AD20";
    }else{
        str = @"666666";
    }
    return str;
}
@end
