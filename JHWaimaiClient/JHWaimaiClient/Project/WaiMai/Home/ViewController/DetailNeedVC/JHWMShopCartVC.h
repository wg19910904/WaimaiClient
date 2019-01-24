//
//  JHWMShopCartVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@class WMShopGoodModel;

// good为nil,点击清除购物车
typedef void(^ShopCartGoodChange)(WMShopGoodModel * good,BOOL is_add);
// 购物车消失的回调
typedef void(^ShopCartHiddenBlock)();
// 创建订单
typedef void(^ClickCreateOrder)(BOOL choose_must_good);
// 购物车数量发生变化
typedef void(^ShopCartCountChange)();

@interface JHWMShopCartVC : JHBaseVC
@property(nonatomic,weak)JHBaseVC *superVC;
// 购物车中的商品发生变化
@property(nonatomic,copy)ShopCartGoodChange shopCartGoodChange;
// 购物车消失的回调
@property(nonatomic,copy)ShopCartHiddenBlock shopCartHiddenBlock;
// 创建订单
@property(nonatomic,copy)ClickCreateOrder createOrder;
// 购物车数量发生变化
@property(nonatomic,copy)ShopCartCountChange shopCartCountChange;
// 购物车数据
@property(nonatomic,strong)NSMutableArray *dataSource;

// 起送价
@property(nonatomic,copy)NSString *startPrice;
// 商品总价
@property(nonatomic,copy)NSString *amount;
// 购物车的数量
@property(nonatomic,assign)int shopCartCount;
// 购物车的展开状态
@property(nonatomic,assign)BOOL is_showShopCartDetail;
// 凑单按钮
@property(nonatomic,weak)UIButton *ziTiBtn;
// 商家已打烊
@property(nonatomic,assign)BOOL isClosed;
// 商家是否还有必选商品
@property(nonatomic,assign)BOOL have_must;
// 包含必点商品
@property(nonatomic,assign)BOOL is_choosed_must_good;

//@property(nonatomic,copy)NSString *shop_id;

// 添加和删除商品到购物车的操作
-(void)cartBtnAnimation:(BOOL)is_add;

// 展开购物车
-(void)showShopCartDetail;

-(void)needPopToRootVC;

@end
