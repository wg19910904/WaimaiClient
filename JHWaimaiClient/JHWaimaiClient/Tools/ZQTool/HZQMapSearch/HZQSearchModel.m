//
//  HZQSearchModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "HZQSearchModel.h"

@implementation HZQSearchModel
-(NSString *)location{
    NSString *str = [NSString stringWithFormat:@"%@%@",_address,_name];
    return str;
}
@end
