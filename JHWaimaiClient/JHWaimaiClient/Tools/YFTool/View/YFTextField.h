//
//  YFTextField.h
//  baocmsAPP
//
//  Created by jianghu3 on 15/12/31.
//  Copyright © 2015年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFTextField : UITextField
// 左边或者右边的偏移量
@property(nonatomic,assign)CGFloat letfMargin;
@property(nonatomic,assign)CGFloat rightMargin;

@property(nonatomic,strong)UIFont *placeholdeFont;
@property(nonatomic,strong)UIColor *placeholdeColor;

// 忽略左边的偏移
@property(nonatomic,assign)BOOL ignoreLeftMargin;
// 忽略右边的偏移
@property(nonatomic,assign)BOOL ignoreRightMargin;


-(id)initWithFrame:(CGRect)frame leftView:(UIView *)leftView;

-(id)initWithFrame:(CGRect)frame rightView:(UIView *)rightView;

-(id)initWithFrame:(CGRect)frame leftView:(UIView *)leftView rightView:(UIView *)rightView;
@end
