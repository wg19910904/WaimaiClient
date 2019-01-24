//
//  JHChooseCityVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/21.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^RefreshCityBlock)(NSString *,NSString *);
@interface JHChooseCityVC : JHBaseVC
@property(nonatomic,strong)NSDictionary *cityDic;
@property(nonatomic,copy)NSString *currentCity;
@property(nonatomic,copy)RefreshCityBlock refreshCityBlock;
@end
