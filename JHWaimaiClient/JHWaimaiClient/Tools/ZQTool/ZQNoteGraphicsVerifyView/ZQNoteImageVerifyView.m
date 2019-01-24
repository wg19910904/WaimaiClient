//
//  ZQNoteImageVerifyView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/29.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQNoteImageVerifyView.h"

#import <UIButton+WebCache.h>
@interface ZQNoteImageVerifyView()<UITextFieldDelegate>
@property(nonatomic,strong)UIView *centerView;//中间的View
@property(nonatomic,strong)UILabel *label;//提示
@property(nonatomic,strong)UITextField *textFiled;//输入框
@property(nonatomic,strong)UIButton *rightBtn;//右边的按钮
@property(nonatomic,strong)UIButton *cancelBtn;//取消的按钮
@property(nonatomic,strong)UIButton *sureBtn;//确定的按钮
@property(nonatomic,strong)UILabel *errL;//显示输入的验证图片码有误的
@end
@implementation ZQNoteImageVerifyView
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
    [self addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
    [self centerView];
    [self label];
    [self textFiled];
    [self sureBtn];
    [self cancelBtn];
    [self errL];
   
}
-(void)clickToRemove{
    _sureBtn.userInteractionEnabled = NO;
    [_textFiled resignFirstResponder];
    [self removeAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
    
}
#pragma mark - 中间的承载的View
-(UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc]init];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.masksToBounds = YES;
        _centerView.layer.cornerRadius = YES;
        [self addSubview:_centerView];
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY).offset = -50*SCALE;
            make.left.offset = 25*SCALE;
            make.right.offset = -25*SCALE;
            make.height.offset = 130*SCALE;
        }];
    }
    return _centerView;
}
//提示
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text =NSLocalizedString(@"请填写图形验证码",nil) ;
        _label.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        _label.font = [UIFont systemFontOfSize:15*SCALE];
        [_centerView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10*SCALE;
            make.top.offset = 15*SCALE;
            make.height.offset = 20*SCALE;
        }];
    }
    return _label;
}
//输入框
-(UITextField *)textFiled{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc]init];
        _textFiled.delegate = self;
        _textFiled.placeholder = NSLocalizedString(@"请输入图中内容",nil);
        _textFiled.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _textFiled.layer.cornerRadius = 3;
        _textFiled.layer.masksToBounds = YES;
        _textFiled.font = FONT(15*SCALE);
        _textFiled.rightViewMode = UITextFieldViewModeAlways;
        _textFiled.leftViewMode = UITextFieldViewModeAlways;
        [_centerView addSubview:_textFiled];
        [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10*SCALE;
            make.top.mas_equalTo(_label.mas_bottom).offset = 10*SCALE;
            make.right.offset = -10*SCALE;
            make.height.offset = 40*SCALE;
        }];
        UIView *rview = [UIView new];
        rview.backgroundColor = [UIColor clearColor];
        rview.frame = FRAME(0, 0, 90*SCALE, 30*SCALE);
        _rightBtn = [[UIButton alloc]initWithFrame:FRAME(0, 0, 80*SCALE, 30*SCALE)];
        [_rightBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [rview addSubview:_rightBtn];
        _textFiled.rightView = rview;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.frame = FRAME(0, 0, 15, 40*SCALE);
        _textFiled.leftView = view;
    }
    return _textFiled;
}
#pragma mark - 点击图片刷新图片的
-(void)clickBtn{
    [self getVerfyImage];
}
//取消的按钮
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        //设置取消按钮
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:THEME_COLOR_Alpha(1) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14*SCALE];
        [_cancelBtn addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_sureBtn.mas_left).offset = -10*SCALE;
            make.top.mas_equalTo(_textFiled.mas_bottom).offset = 10*SCALE;
            make.width.offset = 50*SCALE;
            make.height.offset = 30*SCALE;
        }];
    }
    return _cancelBtn;
}
//确定的按钮
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]init];
        [_sureBtn setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:THEME_COLOR_Alpha(1) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14*SCALE];
        [_sureBtn addTarget:self action:@selector(clickToTrue) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10*SCALE;
            make.top.mas_equalTo(_textFiled.mas_bottom).offset = 10*SCALE;
            make.width.offset = 50*SCALE;
            make.height.offset = 30*SCALE;
        }];

    }
    return _sureBtn;
}
#pragma mark - 点击确定的方法
-(void)clickToTrue{
    if (_textFiled.text.length == 0) {
        _errL.text = NSLocalizedString(@"请输入图中文字!",nil);
        _errL.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _errL.hidden = YES;
        });
        return;
    }
    [self clickToRemove];
    [HttpTool postWithAPI:_verifyApi withParams:@{@"mobile":_phone,@"img_code":_textFiled.text} success:^(id json) {
        if ([json[@"error"] isEqualToString:@"0"]) {//验证成功
            if (self.successBlock) {
                self.successBlock();
            }
        }else{
//            _textFiled.text = @"";
//            _errL.hidden = NO;
//            _errL.text = NSLocalizedString(@"输入有误,请重新输入",nil);
//            [self getVerfyImage];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                _errL.hidden = YES;
//            });
            if (self.failBlock) {
                self.failBlock(NSLocalizedString(@"输入有误,请重新输入",nil));
            }
        }
    } failure:^(NSError *error) {
        if (self.failBlock) {
            self.failBlock(NSLocalizedString(@"验证失败...",nil));
        }
//        _textFiled.text = @"";
//        _errL.text = NSLocalizedString(@"验证失败...",nil);
//        _errL.hidden = NO;
//        [self getVerfyImage];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            _errL.hidden = YES;
//        });
    }];
}
//输入错误的提示
-(UILabel *)errL{
    if (!_errL) {
        _errL = [[UILabel alloc]init];
        _errL.textColor = [UIColor redColor];
        _errL.font = [UIFont systemFontOfSize:12.5];
        _errL.hidden = YES;
        [_centerView addSubview:_errL];
        [_errL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10*SCALE;
            make.centerY.mas_equalTo(_cancelBtn.mas_centerY);
            make.height.offset = 20*SCALE;
        }];
    }
    return _errL;
}
-(void)showAnimation{
    [self getVerfyImage];
    _sureBtn.userInteractionEnabled =YES;
    self.textFiled.text = @"";
    self.backgroundColor = HEX(@"000000", 0.3);
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    _textFiled.text = @"";
    self.frame = [UIScreen mainScreen].bounds;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.35;
    animation.values = @[@(0),@(1)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [_centerView.layer addAnimation:animation forKey:nil];
}
-(void)removeAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.35;
    animation.values = @[@(1),@(1.1),@(0)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [_centerView.layer addAnimation:animation forKey:nil];
}
-(void)getVerfyImage{
    _sureBtn.userInteractionEnabled = YES;
    [HttpTool postTogetImageWithAPI:_getCodeApi withParams:@{} success:^(id json) {
         [_rightBtn setBackgroundImage:json forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        [self getVerfyImage];
    }];
}
@end
