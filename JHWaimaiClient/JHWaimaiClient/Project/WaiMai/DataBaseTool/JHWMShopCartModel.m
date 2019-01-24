//
//  JHWMShopCartModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/19.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHWMShopCartModel.h"

@implementation JHWMShopCartModel
-(UIColor *)shopcartColor{
    NSArray *colorArr = @[HEX(@"f33d1a", 1.0),HEX(@"3fc680", 1.0),HEX(@"169ffe", 1.0),HEX(@"fd8d13", 1.0),HEX(@"5b66f7", 1.0),HEX(@"ffb128", 1.0),HEX(@"2ab972", 1.0)];
    NSInteger index = (_shopcartNum - 1) % 7;
    return colorArr[index];
}

-(NSString *)products_str{
    NSString *str= @"";
    for (WMShopGoodModel *good in self.choosedGoodsArr) {
        NSString *goodStr;
        NSString *size_id = @"0";
        if (good.choosedSize_id.length != 0) {
            size_id = good.choosedSize_id;
        }
        int count = good.current_shopcart_choosedCount > 0 ? good.current_shopcart_choosedCount  : good.good_choosedCount;
        if (str.length == 0) {
            goodStr = [NSString stringWithFormat:@"%@-%@:%@:%d:&%@",_shopcartName,good.product_id,size_id,count,good.create_order_proprety];
        }else{
            goodStr = [NSString stringWithFormat:@",%@-%@:%@:%d:&%@",_shopcartName,good.product_id,size_id,count,good.create_order_proprety];
        }
        str = [str stringByAppendingString:goodStr];
    }

    return str;
}


@end
