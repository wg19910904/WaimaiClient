//
//  MaybeLikeGood.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/4/28.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaybeLikeGood : NSObject
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *product_id;
@property(nonatomic,copy)NSString *sales;
@property(nonatomic,copy)NSString *shop_title;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *shop_id;

/**
 搜索获取商品列表
 
 @param keyword 关键词
 @param page    分页
 @param block 回调的block
 */
+(void)searchWMProductsListWithKW:(NSString *)keyword page:(int)page block:(DataBlock)block;
@end
