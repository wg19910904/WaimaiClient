//
//  ZQWebViewProgressBar.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/11/29.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQWebViewProgressBar.h"
@interface ZQWebViewProgressBar(){
    CAShapeLayer *shaperLayer;
}
@end
@implementation ZQWebViewProgressBar
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (!shaperLayer && frame.size.width > 0) {
         [self creatSubLayer];
    }
   
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if (!shaperLayer && frame.size.width > 0) {
             [self creatSubLayer];
        }
    }
    return self;
}
-(void)creatSubLayer{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width,0)];
    shaperLayer = [[CAShapeLayer alloc]init];
    shaperLayer.path = path.CGPath;
    shaperLayer.fillColor = [UIColor clearColor].CGColor;
    shaperLayer.lineWidth = self.bounds.size.height;
    shaperLayer.lineCap = kCALineCapButt;
    [self.layer addSublayer:shaperLayer];
}
/**
 一开始需要加载的动画
 */
-(void)initAnimation{
    shaperLayer.strokeColor = _tintColor?_tintColor.CGColor:[UIColor blueColor].CGColor;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(0),@(0.3),@(0.5)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [shaperLayer addAnimation:animation forKey:nil];
}

/**
 网页加载完成需要的动画
 */
-(void)completionAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.25;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(0.5),@(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [shaperLayer addAnimation:animation forKey:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shaperLayer removeAllAnimations];
        shaperLayer.strokeColor = [UIColor clearColor].CGColor;
    });
}
@end
