//
//  JHWMShopCartModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/19.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWMShopCartModel : NSObject

@property(nonatomic,assign)int shopcartNum;// 购物车的顺序
@property(nonatomic,strong)UIColor *shopcartColor;// 购物车颜色
@property(nonatomic,copy)NSString *shopcartName;// 购物车的名字
@property(nonatomic,strong)NSArray *choosedGoodsArr;//购物车选择的商品
@property(nonatomic,copy)NSString *products_str;// 购物车商品的拼接
@end
