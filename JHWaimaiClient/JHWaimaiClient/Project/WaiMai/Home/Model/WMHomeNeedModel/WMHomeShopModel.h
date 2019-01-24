//
//  WMHomeShopModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/3.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMShopModel.h"
#import "WMHomeShopProducts.h"

@interface WMHomeShopModel : NSObject
@property(nonatomic,strong)NSArray *products;
@property(nonatomic,strong)WMShopModel *shop;


/**
 通过筛选获取商家列表

 @param dic 筛选条件
 @param block 回调的block
 */
+(void)getWMShopListWithFilterDic:(NSDictionary *)dic block:(DataBlock)block;

/**
 搜索获取商家列表
 
 @param keyword 关键词
 @param page    分页
 @param block 回调的block
 */
+(void)searchWMShopListWithKW:(NSString *)keyword page:(int)page block:(DataBlock)block;

@end
