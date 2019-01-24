//
//  YFTabBarItem.h
//  YFTabar
//
//  Created by jianghu3 on 16/4/20.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFTabBarItem : UIView

@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)BOOL showNew;//显示new标签
@property(nonatomic,assign)BOOL is_animation;// 是否带有动画
// 角标数字
@property(nonatomic,copy)NSString *badgeValue;
// 角标背景颜色
@property(nonatomic,strong)UIColor *badgeColor;

-(YFTabBarItem *)setUpWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage title:(NSString *)title tag:(NSInteger)tag;

@end
