//
//  ZQProgressHud.h
//  ttt
//
//  Created by ijianghu on 2017/8/3.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQProgressHud : UIView

/**
 主题颜色(默认是黑色)
 */
@property(nonatomic,strong)UIColor *viewTintColor;

/**
 view的宽度(默认是80)
 */
@property(nonatomic,assign)CGFloat viewWidth;

/**
 初始化的方法
 
 @param view 加载在哪个view上
 @return 返回创建的对象
 */
-(instancetype)initWithView:(UIView *)view;

/**
 初始化方法(加载在window上)

 @return 返回创建的对象
 */
-(instancetype)init;

/**
 初始化方法(加载在window上)
 
 @return 返回创建的对象
 */
-(instancetype)initWithFrame:(CGRect)frame;

//显示hud的方法
-(void)showHud;
//移除的方法
-(void)removeHud;

/**
 类方法移除(宏定义时需要)

 @param view 从哪个视图移除
 */
+(void)removeHudInView:(UIView *)view;
@end
