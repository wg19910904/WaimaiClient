//
//  UIButton+BackgroundColor.h
//  WaimaiShop
//
//  Created by xixixi on 16/1/13.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BackgroundColor)


/**
 设置按钮的背景颜色

 @param backgroundColor 要设置的背景色
 @param state 要设置颜色的对应状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
