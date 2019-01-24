//
//  JHWaimaiRechargeMoneyModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiRechargeMoneyModel.h"

@implementation JHWaimaiRechargeMoneyModel
-(NSString *)chong{
    NSString * str = [@""  stringByAppendingString:_chong];
    return str;
}
-(NSString *)song{
    NSString * str = [@"" stringByAppendingString:_song];
    return str;
}
-(NSString *)title{
    if (_title.length == 0) return @"";
    NSString * str = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"送", nil),self.song,_title?_title:@""];
    return str;
}
-(NSString *)money{
    return _chong;
}
@end
