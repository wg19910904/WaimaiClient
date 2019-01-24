//
//  WMHomeModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/3.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHADModel.h"
#import "WMHomeShopModel.h"

@interface WMHomeModel : NSObject

@property(nonatomic,assign)int msg_count;
@property(nonatomic,strong)NSArray *adv;
@property(nonatomic,strong)NSArray *banner;
@property(nonatomic,strong)NSArray *cate_adv;
@property(nonatomic,strong)NSMutableArray *shop_items;

/*
 hongbao =         {
 intro = "";
 items =             (
 );
 title = "";
 };
 */
@property(nonatomic,strong)NSDictionary *hongbao;// 红包信息


/**
 获取外卖首页的数据

 @param block 回调的block
 */
+(void)getHomeDataWithDic:(NSDictionary *)dic block:(ModelBlock)block;
@end
