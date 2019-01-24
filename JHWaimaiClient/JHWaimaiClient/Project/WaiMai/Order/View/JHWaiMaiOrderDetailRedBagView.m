//
//  JHWaiMaiOrderDetailRedBagView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/9/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiOrderDetailRedBagView.h"
@interface JHWaiMaiOrderDetailRedBagView()
@property(nonatomic,strong)UIImageView *redBgView;//红包的背景视图
@property(nonatomic,strong)UIImageView *cancelBtn;//取消的按钮
@property(nonatomic,strong)UIButton *sureBtn;//确定的按钮
@property(nonatomic,strong)UILabel *textLable;//
@property(nonatomic,strong)UILabel *alertL;//提醒文字
@end
@implementation JHWaiMaiOrderDetailRedBagView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    self.backgroundColor = HEX(@"000000", 0.8);
    self.alpha = 0;
    [self redBgView];
    [self cancelBtn];
    [self sureBtn];
    [self textLable];
    [self alertL];
}
-(UIImageView *)redBgView{
    if (!_redBgView) {
        _redBgView = [[UIImageView alloc]init];
        _redBgView.image = IMAGE(@"pop_up_redbag");
        [self addSubview:_redBgView];
        _redBgView.userInteractionEnabled = YES;
        [_redBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.offset = 35*SCALE;
            make.right.offset = -35*SCALE;
        }];
    }
    return _redBgView;
}
-(UIImageView *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIImageView alloc]init];
        _cancelBtn.image = IMAGE(@"waimai_btn_close");
        [self addSubview:_cancelBtn];
        _cancelBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCancel)];
        [_cancelBtn addGestureRecognizer:tap];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.height.offset = 40*SCALE;
            make.top.mas_equalTo(_redBgView.mas_bottom).offset = 30;
        }];
    }
    return _cancelBtn;
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]init];
        [_sureBtn setBackgroundImage:IMAGE(@"btn_submit") forState:UIControlStateNormal];
        [_sureBtn setTitle:NSLocalizedString(@"发红包",nil) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font =FONT(19);
        _sureBtn.titleEdgeInsets =UIEdgeInsetsMake(-7*SCALE, 0, 0, 0);
        [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
        [_redBgView addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = -30*SCALE;
            make.width.offset = 180*SCALE;
            make.height.offset = 48*SCALE;
            make.centerX.mas_equalTo(_redBgView.mas_centerX);
        }];
    }
    return _sureBtn;
}
-(UILabel *)textLable{
    if (!_textLable) {
        _textLable = [[UILabel alloc]init];
      
        _textLable.font = FONT(20*SCALE);
        _textLable.textColor = HEX(@"fdff71", 1);
        [_redBgView addSubview:_textLable];
        [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_redBgView.mas_centerX);
            make.height.offset = 25*SCALE;
            make.centerY.mas_equalTo(_redBgView.mas_centerY).offset = 10*SCALE;
            make.left.offset = 10;
            make.right.offset = -10;
        }];
        _textLable.textAlignment = NSTextAlignmentCenter;
        _textLable.adjustsFontSizeToFitWidth = YES;
    }
    return _textLable;
}
-(UILabel *)alertL{
    if (!_alertL) {
        _alertL = [[UILabel alloc]init];
       
        _alertL.font = FONT(15*SCALE);
        _alertL.textColor = HEX(@"ffffff", 1);
        _alertL.textAlignment = NSTextAlignmentCenter;
        _alertL.numberOfLines = 0;
        [_redBgView addSubview:_alertL];
        [_alertL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_redBgView.mas_centerX);
            make.height.offset = 40*SCALE;
            make.top.mas_equalTo(_textLable.mas_bottom).offset = 15*SCALE;
            make.left.offset = 10;
            make.right.offset = -10;
        }];
        _alertL.adjustsFontSizeToFitWidth = YES;
    }
    return _alertL;
}
-(void)clickSureBtn{
    [self clickCancel];
    if (self.clickBlock) {
        self.clickBlock();
    }
}
-(void)clickCancel{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
}
-(void)showView{
    _textLable.text = _titleL;
    _alertL.text = _alertTitle;
    [self scaleAniamtion:_redBgView];
    [self scaleAniamtion:_cancelBtn];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
}
-(void)scaleAniamtion:(UIImageView *)view{
    CAKeyframeAnimation *aniamtion = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    aniamtion.duration = 0.35;
    aniamtion.removedOnCompletion = NO;
    aniamtion.fillMode = kCAFillModeForwards;
    aniamtion.values = @[@(0),@(1)];
    [view.layer addAnimation:aniamtion forKey:nil];
}
@end
