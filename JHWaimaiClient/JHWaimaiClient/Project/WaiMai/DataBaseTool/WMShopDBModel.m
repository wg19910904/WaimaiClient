//
//  WMShopDBModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/19.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopDBModel.h"
#import "JRPersistent.h"
#import "NSString+Tool.h"
#import <NSObject+JRDB.h>
#import <JRDBChain.h>
#import <JRDBMgr.h>

@implementation WMShopDBModel

-(int)shop_choosedCount{
    // 表不存在
    if (![[[JRDBMgr shareInstance] getHandler] jr_tableExists:[WMShopDBModel jr_tableName]]) {
        return 0;
    }
    
    NSArray *goodArr = J_Select(WMShopGoodModel).WhereJ(shop_id = ?).ParamsJ(_shop_id).list;
    int count = 0;
    for (WMShopGoodModel *good in goodArr) {
        if (Current_Is_Other_ShopCart) {
            count += good.current_shopcart_choosedCount;
        }else{
            count += good.good_choosedCount;
        }
    }
    return count;
}

// 清空商品的当前选择数量
-(void)clearGoodCurrentChoosedCount{
    for (WMShopGoodModel *model in _current_shopcart_choosedGoodsArr) {
        WMShopGoodModel *good = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ?").ParamsJ(self.shop_id,model.product_id).list.firstObject;
        good.current_shopcart_choosedCount = 0;
        J_Update(good).WhereIdIs(good.ID).updateResult;
    }
    
     [self.current_shopcart_choosedGoodsArr removeAllObjects];

}

-(void)clearData{
    [self.current_shopcart_choosedGoodsArr removeAllObjects];
    [self.choosedGoodsArr removeAllObjects];
    self.shop_id = @"";
    self.shop_logo = @"";
    self.shop_title = @"";
    self.order_products = @"";
    self.amount = 0;
    self.current_amount = 0;
    self.all_amount = 0;
    self.shop_choosedCount = 0;
    self.current_shopcartNum = 0;
    self.dbDateline = 0;
}

-(NSString *)order_products{
    NSString *str= @"";
    for (WMShopGoodModel *good in self.choosedGoodsArr) {
        NSString *goodStr;
        NSString *size_id = @"0";
        if (good.choosedSize_id.length != 0) {
            size_id = good.choosedSize_id;
        }
        if (str.length == 0) {
            goodStr = [NSString stringWithFormat:@"%@:%@:%d:&%@",good.product_id,size_id,good.good_choosedCount,good.create_order_proprety];
        }else{
            goodStr = [NSString stringWithFormat:@",%@:%@:%d:&%@",good.product_id,size_id,good.good_choosedCount,good.create_order_proprety];
        }
        str = [str stringByAppendingString:goodStr];
    }
    return str;
}

+(NSString *)jr_customPrimarykey{
    return @"shop_id";
}

/// 自定义主键属性值
- (id)jr_customPrimarykeyValue {
    return self.shop_id;
}

-(NSInteger)dbDateline{
   return [[NSDate date] timeIntervalSince1970];
}

static id _instance=nil;

+(instancetype)shareWMShopDBModel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] init];
        [_instance createDBTable];
    });
    return _instance;
}

-(void)createDBTable{

  
    BOOL new_version =  [[NSUserDefaults standardUserDefaults] boolForKey:@"jhcms_new_version"];
    BOOL deleted =  [[NSUserDefaults standardUserDefaults] boolForKey:@"jhcms_delete_db"];// 删除了数据库
    if (new_version && !deleted) {
        [self deleteFile];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
       NSString *filePath = [NSString stringWithFormat:@"%@/wm_shop_list.sqlite",path];
       
       NSLog(@"filePath  %@",filePath) ;
       //    [JRDBMgr shareInstance].debugMode = YES;
       [[JRDBMgr shareInstance] setDefaultDatabasePath:filePath];
       [[JRDBMgr shareInstance] registerClazzes:@[[WMShopDBModel class],
                                                  [WMShopGoodModel class],
                                                  [WMShopCateModel class]
                                                  ]];
   });
    
   
    
}

-(void)deleteFile {
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [NSString stringWithFormat:@"%@/wm_shop_list.sqlite",path];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (!blHave) {
        NSLog(@"no  have");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"jhcms_delete_db"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (blDele) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"jhcms_delete_db"];
            NSLog(@"dele success");
        }else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"jhcms_delete_db"];
            NSLog(@"dele fail");
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

#pragma mark ====== 删除购物车数据库 =======
-(void)deleteDB{
    
    J_DropTable(WMShopDBModel);
    J_DropTable(WMShopCateModel);
    J_DropTable(WMShopGoodModel);
//    J_DropTable(WMShopGoodPropretyModel);
}

#pragma mark ====== 清空某个商家的购物车 =======
-(void)deleteAllGoodsWith:(NSString *)shop_id{

    WMShopDBModel *shop = J_Select(WMShopDBModel).WhereJ(shop_id = ?).ParamsJ(shop_id).Limit(0, 1).list.firstObject;
    if (!shop)  return ;
    J_Delete(shop).updateResult;
    
    NSArray *goodArr = J_Select(WMShopGoodModel).WhereJ(shop_id = ?).ParamsJ(shop_id).list;
    for (WMShopGoodModel *good in goodArr) {
        J_Delete(good).updateResult;
    }
    
    NSArray *cateArr = J_Select(WMShopCateModel).WhereJ(shop_id = ?).ParamsJ(shop_id).list;
    for (WMShopCateModel *cate in cateArr) {
        J_Delete(cate).updateResult;
    }
    
    if ([shop_id isEqualToString:self.shop_id]) {
        if (Current_Is_Other_ShopCart) {
            self.current_amount = 0;
            [self.current_shopcart_choosedGoodsArr removeAllObjects];
        }else{
            self.amount = 0;
            self.shop_choosedCount = 0;
            [self.choosedGoodsArr removeAllObjects];
        }
    }
    
}

#pragma mark ====== 从数据库中获取购物车中的所有商家数据 =======
-(void)getShopCartDataFormDB:(void (^)(NSArray * arr))block{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *shopArr = J_Select(WMShopDBModel).Order(@"dbDateline").Desc(YES).list;
        for (WMShopDBModel *shop in shopArr) {
            [shop.choosedGoodsArr removeAllObjects];
            NSArray *goodArr = J_Select(WMShopGoodModel).WhereJ(shop_id = ?).ParamsJ(shop.shop_id).list;
            [shop.choosedGoodsArr addObjectsFromArray:goodArr];
        }
        
        block(shopArr);
    });
    
}

#pragma mark ====== 从数据库中获取某个商家的数据 =======
-(void)getShopDataFormDB:(DataBlock)block{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 表不存在
        if (![[[JRDBMgr shareInstance] getHandler] jr_tableExists:[WMShopGoodModel jr_tableName]]) {
            block(nil,@"");
            return;
        }
        
        WMShopDBModel *shop = J_Select(WMShopDBModel).WhereJ(shop_id = ?).ParamsJ(self.shop_id).Limit(0, 1).list.firstObject;
        if (!shop) {
            block(nil,@"");
            return;
        }
        [self.current_shopcart_choosedGoodsArr removeAllObjects];
        [self.choosedGoodsArr removeAllObjects];
        shop.shop_title = self.shop_title;
        shop.shop_logo = self.shop_logo;
        
        NSArray *goodArr = J_Select(WMShopGoodModel).WhereJ(shop_id = ?).ParamsJ(self.shop_id).list;
        NSMutableArray *arr = [NSMutableArray array];
        for (WMShopGoodModel *good in goodArr) {
            [arr addObject:@{
                             @"cate_id" : good.cate_id,
                             @"specification":good.choosed_proprety,
                             @"package_price" : (good.is_spec ? good.spec_package_price : good.package_price),
                             @"product_id" : good.product_id,
                             @"product_name" : good.title,
                             @"cate_str" : good.cate_str,
                             @"product_number" : @(good.good_choosedCount),
                             @"product_price" : (good.is_spec ? good.choosedSize_price : good.price),
                             @"spec_id" : (good.choosedSize_id.length > 0 ? good.choosedSize_id : @""),
                             @"spec_name" : (good.choosedSize_Name.length > 0 ? good.choosedSize_Name : @""),
                             @"is_discount" : @(good.is_discount),
                             @"oldprice" : good.oldprice,
                             @"diffprice" : @(good.diffprice),
                             @"disclabel" : (good.disclabel.length > 0 ? good.disclabel : @""),
                             @"quotalabel" : (good.quotalabel.length > 0 ? good.quotalabel : @""),
                             @"current_shopcart_choosedCount" : @(0)
                             }];

        }
        block(arr.copy,nil);
    });
    
}

#pragma mark ====== 获取数据库中用户在此商家选择的商品个数 =======
-(void)getShopChoosedCountFromDB:(NSString *)shop_id block:(void(^)(int count))block{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 表不存在
        if (![[[JRDBMgr shareInstance] getHandler] jr_tableExists:[WMShopDBModel jr_tableName]]) {
            block(0);
            return ;
        }
        
        NSArray *goodArr = J_Select(WMShopGoodModel).WhereJ(shop_id = ?).ParamsJ(shop_id).list;

        int count = 0;
        for (WMShopGoodModel *good in goodArr) {
            if (Current_Is_Other_ShopCart) {
                count += good.current_shopcart_choosedCount;
            }else{
                count += good.good_choosedCount;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(count);
        });
        
    });
    
}

#pragma mark ====== 获取数据库中用户在此商家某个分类选择的商品个数 =======
-(int)getShopCateChoosedCountFromDB:(NSString *)cate_id{
    
    // 表不存在
    if (![[[JRDBMgr shareInstance] getHandler] jr_tableExists:[WMShopCateModel jr_tableName]] ) {
        return 0;
    }
    
    WMShopCateModel *cate = J_Select(WMShopCateModel).Where(@"shop_id = ? and cate_id = ?").ParamsJ(self.shop_id,cate_id).Limit(0, 1).list.firstObject;
    if (Current_Is_Other_ShopCart){
      return cate ? cate.current_shopcart_choosedCount : 0;
    }
    return cate ? cate.cate_choosedCount : 0;
    
}

#pragma mark ====== 获取数据库中用户在此商家此商品选择的数量 =======
-(int)getShopGoodChoosedCountFromDB:(NSString *)product_id choosedSize_id:(NSString *)choosedSize_id propretyStr:(NSString *)choosed_proprety good:(WMShopGoodModel *)willDealGood{
    
    WMShopGoodModel *good = nil;
    NSArray *arr = nil;
    if (choosedSize_id.length > 0 && choosed_proprety.length > 0) {
        // 该规格该属性商品数量
        good = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ? and choosedSize_id = ? and choosed_proprety = ?").ParamsJ(self.shop_id,product_id,choosedSize_id,choosed_proprety).list.firstObject;
        willDealGood.remain_count = good.remain_count;
    }else if (choosedSize_id.length > 0 && choosed_proprety.length == 0) {
        // 该规格所有属性商品数量
        arr = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ? and choosedSize_id = ?").ParamsJ(self.shop_id,product_id,choosedSize_id).list;

    }else if (choosedSize_id.length == 0 && choosed_proprety.length > 0) {
        // 该属性的商品数量
        good = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ? and choosed_proprety = ?").ParamsJ(self.shop_id,product_id,choosed_proprety).list.firstObject;
        willDealGood.remain_count = good.remain_count;
    }else{
        // 该商品所有属性商品数量
        arr = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ?").ParamsJ(self.shop_id,product_id).list;
    }

    if (!good || arr.count > 0) {
        WMShopGoodModel *other_good = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ? and choosedSize_id= ?").ParamsJ(self.shop_id,product_id,willDealGood.choosedSize_id).list.firstObject;
        if (!other_good) {
            if (choosedSize_id.length>0) {
                willDealGood.remain_count = willDealGood.choosedSize_sale_ku;
            }else{
                willDealGood.remain_count = willDealGood.sale_sku;
            }
        }else{
            willDealGood.remain_count = other_good.remain_count;
        }
    }
    
    if (arr) {
        int count = 0;
        for (WMShopGoodModel *subGood in arr) {
            if (Current_Is_Other_ShopCart) {
                count += subGood.current_shopcart_choosedCount;
            }
            else count += subGood.good_choosedCount;
        }
        if (willDealGood) {
            
        }
        return count;
    }
    
    if (Current_Is_Other_ShopCart) {
        return good ? good.current_shopcart_choosedCount : 0;
    }
    return good ? good.good_choosedCount : 0;
    
}


/**
 获取摸个商品的剩余可选数量

 @param shop_id             商家id
 @param product_id          商品id
 @param choosedSize_id      规格商品的选择的规格id
 @return                    剩余可选的数量
 */
-(int)getShopGoodRemainCountFromDBWith:(NSString *)shop_id product_id:(NSString *)product_id choosedSize_id:(NSString *)choosedSize_id{
    // 表不存在
    if (![[[JRDBMgr shareInstance] getHandler] jr_tableExists:[WMShopGoodModel jr_tableName]] || self.choosedGoodsArr.count == 0) {
        return 0;
    }
    WMShopGoodModel *good;
    if (choosedSize_id.length > 0) {// 规格商品
        good = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ? and choosedSize_id = ?").ParamsJ(shop_id,good.product_id,good.choosedSize_id).Limit(0,1).list.firstObject;
    }else{// 非规格商品
        good = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ?").ParamsJ(shop_id,good.product_id).Limit(0,1).list.firstObject;
    }
    return good.remain_count;
}

#pragma mark ====== 更新某个商品 =======
-(void)updateGood:(WMShopGoodModel *)good{

    WMShopGoodModel *db_good = nil;
    if (good.is_spec) {// 规格商品
        db_good = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ? and choosedSize_id = ? and choosed_proprety = ?").Params(@[self.shop_id,good.product_id,good.choosedSize_id,good.choosed_proprety]).Limit(0, 1).list.firstObject;
    }else{// 非规格商品
        db_good = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ? and choosed_proprety = ?").Params(@[self.shop_id,good.product_id,good.choosed_proprety]).Limit(0, 1).list.firstObject;
    }
    
    if (db_good) {// 处理已经存在的商品
        db_good.title = good.title;
        db_good.photo = good.photo;
        db_good.cate_id = good.cate_id;
//        db_good.price = good.price;
        db_good.sale_sku = good.sale_sku;
        db_good.package_price = good.package_price;
        db_good.choosedSize_id = good.choosedSize_id;
        db_good.choosedSize_Name = good.choosedSize_Name;
        db_good.spec_package_price = good.spec_package_price;
        db_good.choosedSize_sale_ku = good.choosedSize_sale_ku;
        db_good.is_specification = good.is_specification;
        db_good.choosed_proprety = good.choosed_proprety;
        db_good.unit = good.unit;
        db_good.good_choosedCount += good.good_choosedCount;
        
        db_good.current_shopcart_choosedCount = good.current_shopcart_choosedCount;
        
        for (NSInteger i=0; i<self.current_shopcart_choosedGoodsArr.count; i++) {
            if ([[self.current_shopcart_choosedGoodsArr[i] product_id] isEqualToString:db_good.product_id] && [[self.current_shopcart_choosedGoodsArr[i] choosedSize_id] isEqualToString:db_good.choosedSize_id]) {
                if (db_good.current_shopcart_choosedCount == 0) {
                    [self.current_shopcart_choosedGoodsArr removeObjectAtIndex:i];
                }else{
                    [self.current_shopcart_choosedGoodsArr replaceObjectAtIndex:i withObject:db_good];
                }
                break;
            }
        }
        for (NSInteger i=0; i<self.choosedGoodsArr.count; i++) {
            if ([[self.choosedGoodsArr[i] product_id] isEqualToString:db_good.product_id] && [[self.choosedGoodsArr[i] choosedSize_id] isEqualToString:db_good.choosedSize_id]) {
                if (db_good.good_choosedCount == 0) {
                    [self.choosedGoodsArr removeObjectAtIndex:i];
                }else{
                    [self.choosedGoodsArr replaceObjectAtIndex:i withObject:db_good];
                }
                break;
            }
        }
        
        if (db_good.good_choosedCount <= 0) {// 数量为0
            J_Delete(db_good).WhereIdIs(db_good.ID).updateResult;
        }else{// 数量不为0
            J_Update(db_good).WhereIdIs(db_good.ID).updateResult;
        }
    }

}

#pragma mark ====== 再来一单的处理 =======
-(void)addOnceAgainOrderToDB:(NSString *)shop_id products:(NSArray *)goodArr cates:(NSArray *)cateArr block:(MsgBlock)block{

    BOOL table_is_exist =  [[[JRDBMgr shareInstance] getHandler] jr_tableExists:[WMShopDBModel jr_tableName]];
    
    if (!table_is_exist) {
        [[JRDBMgr shareInstance] registerClazzes:@[[WMShopDBModel class]]];
        J_CreateTable(WMShopDBModel);
    }
    
    for (WMShopGoodModel *good in goodArr) {

        [self dealGood:good is_add:YES is_onceAgain:YES];
    }
    
    for (WMShopCateModel *cate in cateArr) {
        [self dealCate:cate is_add:YES];
    }
    [self resetAmount];
    J_Insert(self).updateResult;
    block(YES,nil);
  

    
}

#pragma mark ====== 购物车商品数量变化的处理 =======
-(void)goodCountChange:(WMShopGoodModel *)good cate:(WMShopCateModel *)cate is_add:(BOOL)is_add{

    if (cate) {
        [self dealCate:cate is_add:is_add];
    }
    [self dealGood:good is_add:is_add is_onceAgain:NO];
    [self dealShopIs_add:is_add];
    
    [self resetAmount];
}

// 商品数量变化时的价格处理
-(void)resetAmount{
    self.amount = 0;
    self.current_amount = 0;
    self.all_amount = 0;
    BOOL have_discount = NO;// 是否选择了折扣商品

    if (Current_Is_Other_ShopCart) {
        NSArray *arr = [_current_shopcart_choosedGoodsArr sortedArrayUsingComparator:^NSComparisonResult(WMShopGoodModel * good1, WMShopGoodModel * good2) {
            return good1.diffprice < good2.diffprice;
        }];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        int count = 0;
        for (WMShopGoodModel *good in arr) {
            float current_price = 0;
            for (NSInteger i=0; i<good.current_shopcart_choosedCount; i++) {// 一个一个算价格
                count++;
                if (good.is_discount && (count <= _quota || _quota == 0)) { // 折扣优惠商品
                    have_discount = YES;
                    if (good.is_spec) {
                        self.current_amount += [good.choosedSize_price floatValue] + [good.spec_package_price floatValue];
                        current_price += [good.choosedSize_price floatValue];
                    }else{
                        self.current_amount += [good.price floatValue] + [good.package_price floatValue];
                        current_price += [good.price floatValue];
                    }
                }else{ // 非折扣优惠商品 或者 超出限购数量
                    if (good.is_spec) {
                        self.current_amount += [good.oldprice floatValue] + [good.spec_package_price floatValue];
                        current_price += [good.oldprice floatValue];
                    }else{
                        self.current_amount += [good.oldprice floatValue] + [good.package_price floatValue];
                        current_price += [good.oldprice floatValue];
                    }
                }
                
                if (good.is_spec) {
                   self.all_amount += [good.oldprice floatValue] + [good.spec_package_price floatValue];
                }else{
                    self.all_amount += [good.oldprice floatValue] + [good.package_price floatValue];
                }
                
            }
            
            float all_price = [good.oldprice floatValue] * good.current_shopcart_choosedCount;
            dic[good.goodDB_id] = @{
                                    @"all_price":[NSString getStrFromFloatValue:all_price bitCount:2],
                                    @"current_price":[NSString getStrFromFloatValue:current_price bitCount:2]
                                    };
        }
        self.current_good_price_dic = dic.copy;

    }else{
        NSArray *arr = [_choosedGoodsArr sortedArrayUsingComparator:^NSComparisonResult(WMShopGoodModel * good1, WMShopGoodModel * good2) {
            return good1.diffprice < good2.diffprice;
        }];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        int count = 0;
        
        for (WMShopGoodModel *good in arr) {
            float current_price = 0;
            for (NSInteger i=0; i<good.good_choosedCount; i++) {// 一个一个算价格
                count++;
                if (good.is_discount && (count <= _quota || _quota == 0)) { // 折扣优惠商品
                    have_discount = YES;
                    if (good.is_spec) {
                        self.amount += [good.choosedSize_price floatValue] + [good.spec_package_price floatValue];
                        current_price += [good.choosedSize_price floatValue];
                    }else{
                        self.amount += [good.price floatValue] + [good.package_price floatValue];
                        current_price += [good.price floatValue];
                    }
                }else{ // 非折扣优惠商品 或者 超出限购数量
                    if (good.is_spec) {
                        self.amount += [good.oldprice floatValue] + [good.spec_package_price floatValue];
                        current_price += [good.oldprice floatValue];
                    }else{
                        self.amount += [good.oldprice floatValue] + [good.package_price floatValue];
                        current_price += [good.oldprice floatValue];
                    }
                }
                
                if (good.is_spec) {
                    self.all_amount += [good.oldprice floatValue] + [good.spec_package_price floatValue];
                }else{
                    self.all_amount += [good.oldprice floatValue] + [good.package_price floatValue];
                }
            }
            
            float all_price = [good.oldprice floatValue] * good.good_choosedCount;
            dic[good.goodDB_id] = @{
                                    @"all_price":[NSString getStrFromFloatValue:all_price bitCount:2],
                                    @"current_price":[NSString getStrFromFloatValue:current_price bitCount:2]
                                    };
        }
        self.good_price_dic = dic.copy;
    }

}

#pragma mark ====== 商家的处理 =======
-(void)dealShopIs_add:(BOOL)is_add{

    self.shop_choosedCount += (is_add ? 1 : (-1));
    self.shop_choosedCount = MAX(self.shop_choosedCount, 0);
    BOOL table_is_exist =  [[[JRDBMgr shareInstance] getHandler] jr_tableExists:[WMShopDBModel jr_tableName]];
    if (table_is_exist) {
        
        WMShopDBModel *shop = J_Select(WMShopDBModel).WhereJ(shop_id = ?).ParamsJ(self.shop_id).Limit(0, 1).list.firstObject;
        if (shop) {
            if (self.shop_choosedCount <= 0) {
                J_Delete(shop).WhereIdIs(shop.ID).updateResult;
            }else{
                shop.shop_title = self.shop_title;
                shop.shop_logo = self.shop_logo;
                shop.shop_choosedCount = self.shop_choosedCount;
                shop.amount = self.amount;
                J_Update(shop).WhereIdIs(shop.ID).updateResult;
            }
            
        }else{
            J_Insert(self).updateResult;
        }
        
    }else{
        if (!is_add) return;
        [[JRDBMgr shareInstance] registerClazzes:@[[WMShopDBModel class]]];
        J_CreateTable(WMShopDBModel);
        J_Insert(self).updateResult;
  
    }
}

#pragma mark ====== 分类的处理 =======
-(void)dealCate:(WMShopCateModel *)cate is_add:(BOOL)is_add{

    BOOL table_is_exist =  [[[JRDBMgr shareInstance] getHandler] jr_tableExists:[WMShopCateModel jr_tableName]];
    if (table_is_exist) {
        
        WMShopCateModel *db_cate = J_Select(WMShopCateModel).Where(@"shop_id = ? and cate_id = ?").Params(@[self.shop_id,cate.cate_id]).Limit(0, 1).list.firstObject;
        if (db_cate) {
            db_cate.title = cate.title;
            db_cate.cate_choosedCount = cate.cate_choosedCount;
            db_cate.current_shopcart_choosedCount = cate.current_shopcart_choosedCount;
            if (db_cate.cate_choosedCount <= 0) {
                J_Delete(db_cate).WhereIdIs(db_cate.ID).updateResult;
            }else{
                J_Update(db_cate).WhereIdIs(db_cate.ID).updateResult;
            }
 
        }else{
            if (!is_add) return;
            J_Insert(cate).updateResult;
        }
        
    }else{
        if (!is_add) return;
        [[JRDBMgr shareInstance] registerClazzes:@[[WMShopCateModel class] ]];
        J_CreateTable(WMShopCateModel);
        J_Insert(cate).updateResult;
    }
    
}

#pragma mark ====== 商品的处理 =======
//is_onceAgain 是自来一单，商品的数量不需要单独计算
-(void)dealGood:(WMShopGoodModel *)good is_add:(BOOL)is_add is_onceAgain:(BOOL)is_onceAgain{
    [self.current_shopcart_choosedGoodsArr removeAllObjects];
    [self.choosedGoodsArr removeAllObjects];
    BOOL table_is_exist =  [[[JRDBMgr shareInstance] getHandler] jr_tableExists:[WMShopGoodModel jr_tableName]];
    if (table_is_exist) {
        WMShopGoodModel *db_good = nil;
        if (good.is_spec) {// 规格商品
            db_good = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ? and choosedSize_id = ? and choosed_proprety = ?").Params(@[self.shop_id,good.product_id,good.choosedSize_id,good.choosed_proprety]).Limit(0, 1).list.firstObject;

        }else{// 非规格商品
            db_good = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ? and choosed_proprety = ?").Params(@[self.shop_id,good.product_id,good.choosed_proprety]).Limit(0, 1).list.firstObject;
        }
        
        if (db_good) {// 处理已经存在的商品

            db_good.title = good.title;
            db_good.cate_str = good.cate_str;
            db_good.photo = good.photo;
            db_good.cate_id = good.cate_id;
//            db_good.price = good.price;
            db_good.sale_sku = good.sale_sku;
            db_good.package_price = good.package_price;
            db_good.choosedSize_id = good.choosedSize_id;
            db_good.choosedSize_Name = good.choosedSize_Name;
            db_good.choosedSize_price = good.choosedSize_price;
            db_good.choosedSize_photo = good.choosedSize_photo;
            db_good.spec_package_price = good.spec_package_price;
            db_good.choosedSize_sale_ku = good.choosedSize_sale_ku;
            db_good.choosed_proprety = good.choosed_proprety;
            db_good.is_specification = good.is_specification;
            db_good.unit = good.unit;
            
            // 不是再来一单
            if (!is_onceAgain)
            {
                db_good.good_choosedCount += (is_add ? 1 : (-1));
                if (Current_Is_Other_ShopCart){
                  db_good.current_shopcart_choosedCount += (is_add ? 1 : (-1));
                }
            }
            
            if (db_good.good_choosedCount <= 0) {// 数量为0
                J_Delete(db_good).WhereIdIs(db_good.ID).updateResult;
            }else{// 数量不为0
                J_Update(db_good).WhereIdIs(db_good.ID).updateResult;
            }

        }else{// 处理不存在的商品
            if (!is_add) return;
            if (!is_onceAgain) good.good_choosedCount = 1;
            J_Insert(good).updateResult;
        }

    }else{ // 表不存在
        if (!is_add) return;
        [[JRDBMgr shareInstance] registerClazzes:@[[WMShopGoodModel class]]];
        J_CreateTable(WMShopGoodModel);
        if (!is_onceAgain){
            good.good_choosedCount = 1;
            if (Current_Is_Other_ShopCart){
                good.current_shopcart_choosedCount = 1;
            }
        }
        J_Insert(good).updateResult;
    }
    
    [self dealPropretyGoodWhenGoodCountChange:good];
    NSArray *goodArr = J_Select(WMShopGoodModel).WhereJ(shop_id = ?).ParamsJ(self.shop_id).list;
    [self.choosedGoodsArr addObjectsFromArray:goodArr];
    if (Current_Is_Other_ShopCart) {
        for (WMShopGoodModel *model in goodArr) {
            if (model.current_shopcart_choosedCount > 0) {
              [self.current_shopcart_choosedGoodsArr addObject:model];
            }
        }
    }

}


/**
 当购物车数量发生变化时处理其他与其相关的商品的剩余可选数量

 @param good 发生变化的商品
 */
-(void)dealPropretyGoodWhenGoodCountChange:(WMShopGoodModel *)good{

    NSArray *arr;
    if (good.is_spec) {// 规格商品
        arr = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ? and choosedSize_id = ?").Params(@[self.shop_id,good.product_id,good.choosedSize_id]).list;
        
        int count = 0;
        for (WMShopGoodModel *subGood in arr) {
            count += subGood.good_choosedCount;
        }
        
        for (NSInteger i=0; i<arr.count; i++) {
            WMShopGoodModel *subGood = arr[i];
            subGood.remain_count = subGood.choosedSize_sale_ku - count;
            J_Update(subGood).updateResult;
        }
        
    }else{// 非规格商品
        arr = J_Select(WMShopGoodModel).Where(@"shop_id = ? and product_id = ?").Params(@[self.shop_id,good.product_id]).list;
        
        int count = 0;
        for (WMShopGoodModel *subGood in arr) {
            count += subGood.good_choosedCount;
        }
        
        for (NSInteger i=0; i<arr.count; i++) {
            WMShopGoodModel *subGood = arr[i];
            subGood.remain_count = subGood.sale_sku - count;
            J_Update(subGood).updateResult;
        }
    }
    
}

#pragma mark ====== 懒加载 =======
-(NSMutableArray *)choosedGoodsArr{
    if (_choosedGoodsArr==nil) {
        _choosedGoodsArr=[[NSMutableArray alloc] init];
    }
    return _choosedGoodsArr;
}

-(NSMutableArray *)current_shopcart_choosedGoodsArr{
    if (_current_shopcart_choosedGoodsArr==nil) {
        _current_shopcart_choosedGoodsArr=[[NSMutableArray alloc] init];
    }
    return _current_shopcart_choosedGoodsArr;
}

@end
