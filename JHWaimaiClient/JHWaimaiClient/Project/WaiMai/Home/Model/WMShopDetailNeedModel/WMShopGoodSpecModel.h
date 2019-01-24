//
//  WMShopGoodSpecModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMShopGoodSpecModel : NSObject
@property(nonatomic,copy)NSString *package_price;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *product_id;
@property(nonatomic,copy)NSString *sale_count;
@property(nonatomic,assign)int sale_sku;
@property(nonatomic,copy)NSString *spec_id;
@property(nonatomic,copy)NSString *spec_name;
@property(nonatomic,copy)NSString *spec_photo;

@property(nonatomic,assign)BOOL is_discount;//是否是折扣商品
@property(nonatomic,assign)int disctype;// 折扣类型：0打折 1减价
@property(nonatomic,assign)float discval;// 折扣比例（打折：原价*discval/10，减价：原价-discval
@property(nonatomic,copy)NSString *oldprice;// 商品原价
@property(nonatomic,assign)float diffprice;// 商品差价
@property(nonatomic,copy)NSString *disclabel;// 折扣标签
@property(nonatomic,copy)NSString *quotalabel;// 限购文字（有折扣活动时需要）
@end
