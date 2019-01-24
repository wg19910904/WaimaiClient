//
//  JHHomeShaiXuanView.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/27.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFWMFilterView.h"
@interface JHHomeShaiXuanView : UIView
@property(nonatomic,copy)void(^clickFenlei)();
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)YFWMFilterView *filterView;
@property(nonatomic,strong)NSMutableDictionary *filterDic;
@end
