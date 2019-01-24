//
//  JHWaimaiOrderDetailZitimaView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/31.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailZitimaView.h"
#import "UIImage+Extension.h"
@interface JHWaimaiOrderDetailZitimaView()
@property(nonatomic,strong)UIView *centerView;//中间展示的View
@property(nonatomic,strong)UILabel *codeL;//展示二维码的
@property(nonatomic,strong)UIImageView *codeimgV;//展示二维码的图片的
@property(nonatomic,strong)UIImage *image;

@end
@implementation JHWaimaiOrderDetailZitimaView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}
//基础配置
-(void)config{
    self.backgroundColor = HEX(@"000000", 0.4);
    self.alpha = 0;
    [self addTarget:self action:@selector(clickRemove) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
    [self centerView];
}
#pragma mark - 这是点击移除的方法
-(void)clickRemove{
    [self removeAnimaiton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}
#pragma mark - 中间的view
-(UIView *)centerView{
    if (!_centerView) {
        _centerView = [UIView new];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.cornerRadius = 4;
        _centerView.layer.masksToBounds = YES;
        [self addSubview:_centerView];
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.offset = 300*SCALE;
            make.height.offset = 300*SCALE;
        }];
        [self codeL];
        [self codeimgV];
        [self showAnimation];
    }
    return _centerView;
}
-(void)showView{
    _codeL.text = _code;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}
-(void)setCode:(NSString *)code{
    _code = code;
    [NSThread detachNewThreadSelector:@selector(onThread) toTarget:self withObject:nil];
}
-(void)onThread{
    if (![[JHConfigurationTool shareJHConfigurationTool].code isEqualToString:_code]) {
         [JHConfigurationTool shareJHConfigurationTool].code = _code;
         _image = [UIImage createCoreImage:_code centerImg:nil];
         [JHConfigurationTool shareJHConfigurationTool].image_code = _image;
    }else{
         _image =  [JHConfigurationTool shareJHConfigurationTool].image_code;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    self.codeimgV.image = _image;
    });
}
-(void)hiddenView{
    [self clickRemove];
}
#pragma mark - 展示二维码的数字的
-(UILabel *)codeL{
    if (!_codeL) {
        _codeL = [[UILabel alloc]init];
        _codeL.textColor = HEX(@"ff6600", 1);
        _codeL.font = FONT(16);
        _codeL.textAlignment = NSTextAlignmentCenter;
        [_centerView addSubview:_codeL];
        [_codeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset = 0;
            make.height.offset = 20;
            make.top.offset = 15*SCALE;
        }];
    }
    return _codeL;
}
#pragma mark - 展示二维码的图片
-(UIImageView *)codeimgV{
    if (!_codeimgV) {
        _codeimgV = [[UIImageView alloc]init];
        [_centerView addSubview:_codeimgV];
        [_codeimgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 38*SCALE;
            make.top.mas_equalTo(_codeL.mas_bottom).offset = 16*SCALE;
            make.right.offset = -38*SCALE;
            make.height.offset = 224*SCALE;
        }];
    }
    return _codeimgV;
}
-(void)setZiti_status:(NSInteger)ziti_status{
    _ziti_status = ziti_status;
    if (ziti_status == 0) {
        _codeimgV.alpha = 1;
    }else{
        _codeimgV.alpha = 0.2;
    }
}
#pragma mark - 出现的动画
-(void)showAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.25;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(0),@(1)];
    [_centerView.layer addAnimation:animation forKey:nil];
}
#pragma mark - 消失的动画
-(void)removeAnimaiton{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.5;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(1),@(1.1),@(0)];
    [_centerView.layer addAnimation:animation forKey:nil];
}
@end
