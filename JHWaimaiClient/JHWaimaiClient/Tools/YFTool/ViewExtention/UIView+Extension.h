//
//  UIView+Extension.h
//  baocmsAPP
//
//  Created by Apple on 16/1/3.
//  Copyright © 2016年 jianghu3. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

- (void)roundedCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius colcor:(UIColor *)lineColor;
- (void)roundedCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;

-(void)addViewRadius:(CGFloat)cornerRadius;

-(void)addViewBorder:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

-(void)addViewShadow:(UIColor *)shadowColor shadowOffset:(CGSize)size;
    
-(void)addViewShadow:(UIColor *)shadowColor shadowOffset:(CGSize)size radius:(CGFloat)cornerRadius;

-(void)yf_addTarget:target action:(nonnull SEL)action;
@end
