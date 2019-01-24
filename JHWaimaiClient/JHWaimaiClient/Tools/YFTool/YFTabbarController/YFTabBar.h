//
//  YFTabBar.h
//  PresentAnimationTest
//
//  Created by ios_yangfei on 17/4/24.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFTabBarItem.h"

typedef void(^ClickBarItem)(NSInteger index);

@interface YFTabBar : UITabBar
@property(nonatomic,copy)ClickBarItem clickBarItem;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,assign)BOOL showNew;

-(void)setUpViewWithTitleArr:(NSArray *)titleArr normalImageArr:(NSArray *)normalArr selectedArr:(NSArray *)selectedArr;

-(YFTabBarItem *)getItemWithIndex:(NSInteger)index;

@end
