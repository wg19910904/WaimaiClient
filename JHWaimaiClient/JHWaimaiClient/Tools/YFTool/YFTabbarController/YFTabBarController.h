//
//  YFTabBarController.h
//  YFTabar
//
//  Created by jianghu3 on 16/4/20.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YFTabBarControllerTypeAll,
    YFTabBarControllerTypeWai,
    YFTabBarControllerTypeTuan,
    YFTabBarControllerTypeMall,
    YFTabBarControllerTypePaoTui,
} YFTabBarControllerType;

@interface YFTabBarController : UITabBarController

@property(nonatomic,assign)YFTabBarControllerType tabbarType;
// 前往一个新的模块
@property(nonatomic,assign)BOOL is_goNew;

@property(nonatomic,assign)BOOL showNew;

-(void)setUpViewWithViewControllers:(NSArray *)subControllers titleArr:(NSArray *)titleArr normalImageArr:(NSArray *)normalArr selectedArr:(NSArray *)selectedArr;

//-(void)normalTableView;

-(void)waimaiTabbar;
//
//-(void)mallTabbar;
//
//-(void)tuanGouTabbar;
//
//-(void)paoTuiTabbar;
@end

/*
 -(void)getYFBarItem{
 for (UIViewController * vc in self.tabBarController.viewControllers) {
 for (UIViewController *sub in vc.childViewControllers) {
 if (sub == self) {
 NSInteger index = [self.tabBarController.viewControllers indexOfObject:vc];
 YFTabBarItem * item = [((YFTabBar *)self.tabBarController.tabBar) getItemWithIndex:index];
 item.badgeValue = @"10";
 }
 }
 }
 }
 
 */
