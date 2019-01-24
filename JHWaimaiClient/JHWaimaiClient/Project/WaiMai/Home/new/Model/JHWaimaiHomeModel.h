//
//  JHWaimaiHomeModel.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/8/29.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWaimaiHomeModel : NSObject
@property(nonatomic,copy)NSArray *theme;
@property(nonatomic,copy)NSDictionary *hongbao;
//需要返回的控制器名称
@property(nonatomic,copy)NSMutableArray *vcNameArr;
//需要返回的控制器数据索引
@property(nonatomic,copy)NSMutableArray *vcDataIndexArr;
//当前tabbar的样式
@property(nonatomic,copy)NSDictionary *tabbarDic;
@property(nonatomic,copy)NSArray *theme_test;
//当前的导航栏样式
@property(nonatomic,assign)NSUInteger type;

@property(nonatomic,assign)CGFloat header_height;

//是否需要展示弹幕
@property(nonatomic,assign)BOOL showDanmu;

//表头及可变区域的高度
@property(nonatomic,assign)CGFloat section_0_height;

@property(nonatomic,copy)NSString *shopHuodongType;

//tabbar的颜色
- (UIColor *)normalColor;
- (UIColor *)selectedColor;

- (void)handleTabBarVC;
- (void)handleHomeConfig;
- (NSDictionary *)getCurrentDataDic:(NSUInteger)row;

@end



//
@interface JHWaimaiHomeShopListAndHongbao:NSObject

@property(nonatomic,copy)NSArray *items;
@property(nonatomic,copy)NSDictionary *hongbao;

@end
