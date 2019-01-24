//
//  JHWMChooseSizeGoodPropertyVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "WMShopGoodModel.h"

// 规格商品的数量发生变化
typedef void(^GoodCountChange)(BOOL is_add);

@interface JHWMChooseSizeGoodPropertyVC : JHBaseVC
@property(nonatomic,copy)GoodCountChange goodCountChange;

@property(nonatomic,weak)WMShopGoodModel *good;
@end
