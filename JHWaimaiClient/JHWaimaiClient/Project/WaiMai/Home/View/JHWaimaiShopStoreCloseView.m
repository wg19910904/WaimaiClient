//
//  JHWaimaiShopStoreCloseView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiShopStoreCloseView.h"
@interface JHWaimaiShopStoreCloseView()
@property(nonatomic,strong)UIImageView *imgV;//展示图片的
@end
@implementation JHWaimaiShopStoreCloseView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
        [self imgV];
    }
    return self;
}
#pragma mark - 基础配置
-(void)config{
    self.backgroundColor = HEX(@"000000", 0.5);
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToRemove)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}
#pragma mark - 点击移除的方法
-(void)clickToRemove{
    [self hiddleAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
   
}
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.image = IMAGE(@"dayang");
        float a = _imgV.image.size.width/_imgV.image.size.height;
        [self addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.offset = 350;
            make.width.offset = 350*a;
        }];
    }
    return _imgV;
}
//展示的动画
-(void)showAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.4;
    animation.values = @[@(0),@(1)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [_imgV.layer addAnimation:animation forKey:nil];
    
}
-(void)hiddleAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.4;
    animation.values = @[@(1),@(1.2),@(0)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [_imgV.layer addAnimation:animation forKey:nil];
}
@end
