//
//  JHWMSearchOnShopVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "WMShopModel.h"
@class JHWMShopCartVC;
@class JHShopMenuVC;

// good为nil,点击清除购物车
typedef void(^GoodChooseChange)(WMShopGoodModel * good,BOOL is_add);

@interface JHWMSearchOnShopVC : JHBaseVC
@property(nonatomic,strong)WMShopModel *shopModel;
@property(nonatomic,copy)GoodChooseChange goodChooseChange;
@property(nonatomic,weak)JHWMShopCartVC *shopCartVC;
@property(nonatomic,weak)JHShopMenuVC *shopMenuVC;
@end
