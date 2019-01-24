//
//  WMShopGoodPropretyModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopGoodPropretyModel.h"

@implementation WMShopGoodPropretyModel

+(NSString *)jr_customPrimarykey{
    return @"goodDB_id";
}

/// 自定义主键属性值
- (id)jr_customPrimarykeyValue {
    return self.proprety_id;
}

-(NSString *)proprety_id{
    return [NSString stringWithFormat:@"%@_%@_%@_%@",self.shop_id,self.good_id,self.title,self.proprety_name];
}


@end
