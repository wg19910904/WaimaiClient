//
//  JHWaimaiOrderSeeEvaliationModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/15.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderSeeEvaliationModel.h"
#import "NSString+Tool.h"
@implementation JHWaimaiOrderSeeEvaliationModel
-(NSString *)songda{
    NSString * str = [NSString formateDate:@"HH:mm" dateline:[_songda integerValue]];
    
    return [NSString stringWithFormat:@"%@%@(%@%@)",_pei_time,NSLocalizedString(@"分钟", nil),str,NSLocalizedString(@"送达", nil)];
}
@end
