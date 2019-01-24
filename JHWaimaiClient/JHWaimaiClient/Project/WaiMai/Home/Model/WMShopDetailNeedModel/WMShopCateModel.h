//
//  WMShopCateModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/18.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMShopGoodModel.h"

@interface WMShopCateModel : NSObject
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSArray *products;

// 当前分类下客户选择的商品数量
@property(nonatomic,assign)int cate_choosedCount;

// 数据库中的ID
@property(nonatomic,copy)NSString *cateDB_id;

#pragma mark ====== 团购购物车的属性 =======
// 当前分类下客户选择的商品数量
@property(nonatomic,assign)int current_shopcart_choosedCount;

@end
