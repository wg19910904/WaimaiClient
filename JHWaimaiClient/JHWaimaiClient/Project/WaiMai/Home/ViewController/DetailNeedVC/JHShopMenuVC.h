//
//  JHShopMenuVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "JHWMShopTuiJianView.h"

@class JHWMShopCartVC;
@class WMShopGoodModel;
@class WMShopModel;

typedef void(^ChooseType)();

@interface JHShopMenuVC : JHBaseVC

@property(nonatomic,weak)JHWMShopTuiJianView *tuiJianView;

@property(nonatomic,weak)JHWMShopCartVC *shopCartVC;
@property(nonatomic,copy)ChooseType chooseType;
@property(nonatomic,weak)UITableView *leftTableView;
@property(nonatomic,weak)JHBaseVC *superVC;
@property(nonatomic,strong)WMShopModel *shopModel;
@property(nonatomic,copy)NSString *good_id;
// 再来一单的商品处理
/*
 {
 "cate_id" = 3;
 "package_price" = "2.00";
 "product_id" = 2;
 "product_name" = "\U6d4b\U8bd5\U5546\U54c12";
 "product_number" = 3;
 "product_price" = "8.00";
 "spec_id" = 0;
 "spec_name" = "";
 }
 
 */
@property(nonatomic,strong)NSArray *onceAgainProductsArr;
// 调整shopCartVC的View
-(void)adjustShopCartView;

// 商品数量变化时的界面变化
-(void)dealWithChooseProduct:(WMShopGoodModel *)good is_add:(BOOL)is_add;

@end
