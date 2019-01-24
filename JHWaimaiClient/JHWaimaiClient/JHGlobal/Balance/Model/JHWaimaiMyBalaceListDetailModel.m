//
//  JHWaimaiMyBalaceListDetailModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiMyBalaceListDetailModel.h"
#import "NSString+Tool.h"
@implementation JHWaimaiMyBalaceListDetailModel
-(NSString *)dateline{
    NSString * str = [NSString formateDate:@"yyyy-MM-dd HH:mm:ss" dateline:[_dateline integerValue]];
    return str;
}
@end
