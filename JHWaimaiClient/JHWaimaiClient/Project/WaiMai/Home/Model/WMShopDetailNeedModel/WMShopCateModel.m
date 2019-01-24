//
//  WMShopCateModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/18.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopCateModel.h"
#import <MJExtension.h>

@implementation WMShopCateModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"products":@"WMShopGoodModel"};
}

+(NSString *)jr_customPrimarykey{
    return @"cateDB_id";
}

/// 自定义主键属性值
- (id)jr_customPrimarykeyValue {
    return self.cateDB_id;
}

-(NSString *)cateDB_id{
    return [NSString stringWithFormat:@"%@_%@",self.shop_id,self.cate_id];
}

@end
