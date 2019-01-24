//
//  YFSegmentedControl.h
//  PresentAnimationTest
//
//  Created by ios_yangfei on 17/4/20.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSegmentedControl : UIControl

// 图片和文字 @{@"title":@"",@"icon":@""}
@property(nonatomic,strong)NSArray *titleImgArr;
// 默认颜色
@property(nonatomic,strong)UIColor *normalColor;
// 选中的颜色
@property(nonatomic,strong)UIColor *selectedColor;
// 显示边框颜色
@property(nonatomic,strong)UIColor *borderColor;
// 隐藏 默认YES
@property(nonatomic,assign)BOOL showIndicator;
// 当前选中
@property(nonatomic,assign)NSInteger selectedSegmentIndex;
// 引导条的长度
@property(nonatomic,assign)CGFloat indicatorWidth;
// 文字大小
@property(nonatomic,strong)UIFont *textFont;

// 角标显示的文字数组
@property(nonatomic,strong)NSArray *badgeArr;


/**
 初始化

 @param frame       frame
 @param titleImgArr @[@{@"title":@"",
                        @"icon":@""
                        }]
 @return            YFSegmentedControl
 */
-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleImgArr;
@end
