//
//  HZQSearchModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZQSearchModel : NSObject
@property(nonatomic,copy)NSString * province;//省份
@property(nonatomic,copy)NSString * city;//市
@property(nonatomic,copy)NSString * district;//区
@property(nonatomic,copy)NSString * address;//路
@property(nonatomic,copy)NSString * name;//建筑物名称
@property(nonatomic,strong)NSString *location;//合称
@property(nonatomic,copy)NSString * latitude;//纬度
@property(nonatomic,copy)NSString * longitude;//经度
@end
