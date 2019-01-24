//
//  JHWMShopGoodDetailVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/23.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "WMShopGoodModel.h"
#import "WMShopModel.h"
@class JHWMShopCartVC;
@class JHShopMenuVC;

@interface JHWMShopGoodDetailVC : JHBaseVC
@property(nonatomic,weak)WMShopModel *shopModel;
@property(nonatomic,weak)WMShopGoodModel *good;
@property(nonatomic,weak)JHWMShopCartVC *shopCartVC;
@property(nonatomic,weak)JHShopMenuVC *shopMenuVC;
@property(nonatomic,weak)UITableView *tableView;
@end
