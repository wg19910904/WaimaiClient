//
//  WMShopGoodModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/18.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopGoodModel.h"


@implementation WMShopGoodModel
-(NSString *)description{
    return [NSString stringWithFormat:@"\nWMShopGoodModel === %@\n%@\n%@\n%d\n%@\n%@\n%@\n",self.title,self.choosedSize_id,self.choosedSize_Name,self.good_choosedCount,self.oldprice,self.price,self.choosedSize_price];
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"specs":@"WMShopGoodSpecModel"};
}

+(NSString *)jr_customPrimarykey{
    return @"goodDB_id";
}

/// 自定义主键属性值
- (id)jr_customPrimarykeyValue {
    return self.goodDB_id;
}

-(NSString *)goodDB_id{//,self.cate_id
    return [NSString stringWithFormat:@"%@_%@_%@_%@",self.shop_id,self.product_id,self.choosedSize_id,self.choosed_proprety];
}

-(NSString *)choosedSize_id{
    return  _choosedSize_id.length == 0 ? @"" : _choosedSize_id;
}

-(NSString *)choosedSize_Name{
    return  _choosedSize_Name.length == 0 ? @"" : _choosedSize_Name;
}

-(NSString *)goodPercent{
    int count = ([_good intValue] + [_bad intValue]);
    if (count == 0) {
      return @"0%";
    }
    int percent = [_good floatValue]/([_good floatValue] + [_bad floatValue]) * 100;
    return [NSString stringWithFormat:@"%d%@",percent,@"%"];
}

-(BOOL)is_specification{
    if (self.specification.count == 0 && self.choosed_proprety.length == 0) {
        return NO;
    }
    return YES;
}

-(NSString *)choosed_proprety{
    return  _choosed_proprety.length == 0 ? @"" : _choosed_proprety;
}

-(NSString *)show_choosed_proprety{
    if (self.choosed_proprety.length == 0) {
        return @"";
    }else{
        NSArray *arr = [self.choosed_proprety componentsSeparatedByString:@","];
        NSMutableArray *proprety_arr = [NSMutableArray array];
        for (NSString *str in arr) {
            if ([str containsString:@":"]) {
                NSArray *arr = [str componentsSeparatedByString:@":"];
                [proprety_arr addObject:arr.lastObject];
            }
        }
        
        NSString *str = [proprety_arr componentsJoinedByString:@" + "];
        return str;
    }
}

-(NSString *)create_order_proprety{
    if (self.choosed_proprety.length == 0) {
        return @"";
    }else{
        NSArray *arr = [self.choosed_proprety componentsSeparatedByString:@","];
        NSMutableArray *propretyArr = [NSMutableArray array];
        for (NSInteger i=0; i<arr.count; i++) {
            NSString *str = arr[i];
            if ([str containsString:@":"]) {
                str = [str stringByReplacingOccurrencesOfString:@":" withString:@"_"];
                [propretyArr addObject:str];
            }
        }
        NSString *str = [propretyArr componentsJoinedByString:@"-"];
        return str;
    }
}

@end
