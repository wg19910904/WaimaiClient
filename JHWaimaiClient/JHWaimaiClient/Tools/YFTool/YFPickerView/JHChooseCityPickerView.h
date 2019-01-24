//
//  JHChooseCityPickerView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "YFPickerView.h"

@interface JHChooseCityPickerView : YFPickerView
/*
 @{province_id : ,
 city_id : ,
 area_id : ,
 province_name : ,
 city_name : ,
 area_name : }
 */
typedef void(^ChooseResultBlock)(NSDictionary *dic);

@property(nonatomic,copy)ChooseResultBlock resultBlock;

@end
