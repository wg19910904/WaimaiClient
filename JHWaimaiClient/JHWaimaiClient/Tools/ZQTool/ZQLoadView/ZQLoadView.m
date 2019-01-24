//
//  ZQLoadView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQLoadView.h"
@interface ZQLoadView()
@property(nonatomic,strong)ZQLoadView *currentView;
@property(nonatomic,strong)NSArray *colorArr;
@property(nonatomic,strong)UIView *labelLeft;
@property(nonatomic,strong)UIView *labelCenter;
@property(nonatomic,strong)UIView *labelRight;
@property(nonatomic,strong)NSTimer *timer;
@end
@implementation ZQLoadView

+(ZQLoadView *)showInView:(UIView *)view frame:(CGRect)frame{
    ZQLoadView *loadView = [[ZQLoadView alloc]init];
    loadView.frame = FRAME((frame.size.width - 90)/2, (frame.size.height - 20)/2, 90, 20);
    loadView.currentView = loadView;
    [view addSubview:loadView];
    loadView.colorArr = @[[UIColor redColor],[UIColor blueColor],[UIColor yellowColor],[UIColor purpleColor],[UIColor brownColor],[UIColor orangeColor]];
    [loadView labelCenter];
    [loadView labelLeft];
    [loadView labelRight];
    return loadView;
}
-(void)removeView{
    if (self.removeBlock) {
        self.removeBlock();
    }
    [self.currentView removeFromSuperview];
    self.currentView = nil;
}
#pragma mark - 添加中间的球
-(UIView *)labelCenter{
    if (!_labelCenter) {
        _labelCenter = [[UIView alloc]init];
        _labelCenter.frame = FRAME(35, 0, 20, 20);
        _labelCenter.backgroundColor = self.colorArr[arc4random()%6];
        _labelCenter.layer.cornerRadius = 10;
        _labelCenter.layer.masksToBounds = YES;
        [self addSubview:_labelCenter];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.5];
        [UIView setAnimationRepeatCount:CGFLOAT_MAX];
         _labelCenter.backgroundColor = self.colorArr[arc4random()%6];
        [UIView commitAnimations];
    }
    return _labelCenter;
}
#pragma mark - 添加左边的球
-(UIView *)labelLeft{
    if (!_labelLeft) {
        _labelLeft = [[UIView alloc]init];
        _labelLeft.frame = FRAME(0, 0, 20, 20);
        _labelLeft.backgroundColor = self.colorArr[arc4random()%6];
        _labelLeft.layer.cornerRadius = 10;
        _labelLeft.layer.masksToBounds = YES;
        [self addSubview:_labelLeft];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationRepeatCount:CGFLOAT_MAX];
        _labelLeft.backgroundColor = self.colorArr[arc4random()%6];
        [UIView commitAnimations];
        [self leftAnimation];
    }
    return _labelLeft;
}
#pragma mark - 添加右边的球
-(UIView *)labelRight{
    if (!_labelRight) {
        _labelRight = [[UIView alloc]init];
        _labelRight.frame = FRAME(70, 0, 20, 20);
        _labelRight.backgroundColor = self.colorArr[arc4random()%6];
        _labelRight.layer.cornerRadius = 10;
        _labelRight.layer.masksToBounds = YES;
        [self addSubview:_labelRight];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationRepeatCount:CGFLOAT_MAX];
        _labelRight.backgroundColor = self.colorArr[arc4random()%6];
        [UIView commitAnimations];
        [self rightAnimation];
    }
    return _labelRight;
}
#pragma mark - 左边球的动画
-(void)leftAnimation{
    CAKeyframeAnimation *leftAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    leftAnimation.duration = 1.5;
    leftAnimation.repeatCount = CGFLOAT_MAX;
    leftAnimation.fillMode = kCAFillModeForwards;
    leftAnimation.removedOnCompletion = NO;
    leftAnimation.values = @[@(10),@(80),@(10)];
    [_labelLeft.layer addAnimation:leftAnimation forKey:nil];
}
#pragma mark - 右边球的动画
-(void)rightAnimation{
    CAKeyframeAnimation *rightAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    rightAnimation.duration = 1.5;
    rightAnimation.repeatCount = CGFLOAT_MAX;
    rightAnimation.fillMode = kCAFillModeForwards;
    rightAnimation.removedOnCompletion = NO;
    rightAnimation.values = @[@(80),@(10),@(80)];
    [_labelRight.layer addAnimation:rightAnimation forKey:nil];
}
@end
