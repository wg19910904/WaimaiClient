//
//  JHWaiMaiShopDetailVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/4.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHWaiMaiShopDetailVC : JHBaseVC
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *good_id;

// 再来一单的商品处理
@property(nonatomic,strong)NSArray *onceAgainProductsArr;

@end
