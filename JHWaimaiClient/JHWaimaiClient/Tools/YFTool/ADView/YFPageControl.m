//
//  YFPageControl.m
//
//  Created by ios_yangfei on 17/4/17.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import "YFPageControl.h"

@implementation YFPageControl

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    
    _dotHeight = 10;
    _dotWidth = 0;
    _interSpace = 10;
    _currentPageIndicatorTintColor = [UIColor grayColor];
    _pageIndicatorTintColor = [UIColor whiteColor];
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)drawRect:(CGRect)rect {
    
    if (_numberOfPages > 1) {
        
        for (NSInteger i=0; i<self.numberOfPages; i++) {
            
            CGPoint startPoint = [self getDotStartPointWith: i + 1];
            
            CGFloat width = self.dotHeight + self.dotWidth;
            CGFloat height = self.dotHeight;
            
            CGFloat radius = height/2.0;
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            // 移动到初始点
            CGContextMoveToPoint(context, startPoint.x + radius, 0);
            
            // 绘制第1条线和第1个1/4圆弧
            CGContextAddArc(context,startPoint.x + width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
            
            // 绘制第2条线和第2个1/4圆弧
            CGContextAddArc(context,startPoint.x + width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
            
            // 绘制第3条线和第3个1/4圆弧
            CGContextAddArc(context,startPoint.x + radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
            
            // 绘制第4条线和第4个1/4圆弧
            CGContextAddArc(context, startPoint.x + radius, radius, radius, M_PI, 1.5 * M_PI, 0);
            
            // 闭合路径
            CGContextClosePath(context);
            
            if (_currentPage == i) {
                [self.currentPageIndicatorTintColor setFill];
            }else{
                [self.pageIndicatorTintColor setFill];
            }
            CGContextDrawPath(context, kCGPathFill);
        }
        
    }
    
}

-(void)setCurrentPage:(NSInteger)currentPage{
    if (self.numberOfPages > 1) {
         _currentPage =  currentPage;
        [self setNeedsDisplay];
    }
}

// 获取每个dot的起始位置
-(CGPoint)getDotStartPointWith:(NSInteger)index{
    
    CGFloat width = [self getPageCountSize].width;
    CGFloat offset_x = (self.frame.size.width - width) / 2;
    CGFloat y = (self.frame.size.height - self.dotHeight) / 2;
    CGFloat x = offset_x + (index - 1) * (self.interSpace + self.dotWidth + self.dotHeight);
    return CGPointMake(x, y);
    
}

#pragma mark ======所有的dot和间隔的宽度=======
-(CGSize)getPageCountSize{
    
    CGFloat width = self.numberOfPages * (self.interSpace + self.dotWidth + self.dotHeight ) - self.interSpace;
    CGFloat height = self.dotHeight;
    return  CGSizeMake(width, height);
}

#pragma mark ======Setter=======
-(void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    [self setNeedsDisplay];
}

-(void)setDotWidth:(CGFloat)dotWidth{
    _dotWidth = dotWidth;
    [self setNeedsDisplay];
}

-(void)setDotHeight:(CGFloat)dotHeight{
    _dotHeight = dotHeight;
    [self setNeedsDisplay];
}

-(void)setInterSpace:(CGFloat)interSpace{
    _interSpace = interSpace;
    [self setNeedsDisplay];
}

-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    [self setNeedsDisplay];
}

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    [self setNeedsDisplay];
}

@end
