//
//  JHTiXianView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2018/2/7.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHTiXianView.h"
@interface JHTiXianView()<UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIView *centerView;
@property(nonatomic,strong)UITextView *textV;//输入账号
@property(nonatomic,strong)UITextField *textF;//输入金额
@end
@implementation JHTiXianView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = HEX(@"000000", 0.5);
        self.frame = FRAME(0, 0, WIDTH, HEIGHT);
        [self centerView];
        [self addTarget:self action:@selector(clickRemove) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(UIView *)centerView{
    if (!_centerView) {
        _centerView = [UIView new];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.cornerRadius = 3;
        _centerView.layer.masksToBounds = YES;
        [self addSubview:_centerView];
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.offset = 20;
            make.right.offset = -20;
            make.height.offset = 200;
        }];
        //取消订单的提示字符
        UILabel *lab = [UILabel new];
        lab.text = NSLocalizedString(@"申请提现",nil);
        lab.font = FONT(16);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = HEX(@"333333", 1);
        [_centerView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.right.offset = 0;
            make.top.offset = 17;
            make.height.offset = 20;
        }];
        //输入框
        _textV = [UITextView new];
        _textV.layer.borderWidth = 0.5;
        _textV.layer.borderColor = LINE_COLOR.CGColor;
        _textV.font = FONT(12);
        _textV.delegate = self;
        [_centerView addSubview:_textV];
        [_textV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20;
            make.top.equalTo(lab.mas_bottom).offset = 15;
            make.right.offset = -20;
            make.height.offset = 60;
        }];
        _textF = [[UITextField alloc]init];
        _textF.layer.borderWidth = 0.5;
        _textF.layer.borderColor = LINE_COLOR.CGColor;
        _textF.layer.cornerRadius = 3;
        _textF.layer.masksToBounds = YES;
        _textF.keyboardType = UIKeyboardTypeDecimalPad;
        _textF.font = FONT(12);
        _textF.delegate = self;
        _textF.placeholder = NSLocalizedString(@"  请输入申请提现金额",nil);
        [_centerView addSubview:_textF];
        [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20;
            make.top.equalTo(_textV.mas_bottom).offset = 5;
            make.right.offset = -20;
            make.height.offset = 30;
        }];
        UIView *hLine = [UIView new];
        hLine.backgroundColor = LINE_COLOR;
        [_centerView addSubview:hLine];
        [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset = 0;
            make.height.offset = 0.5;
            make.bottom.offset = -40;
        }];
        //确定的按钮
        UIButton *sureBtn = [UIButton new];
        [sureBtn setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
        [sureBtn setTitleColor:HEX(@"ff3300", 1) forState:UIControlStateNormal];
        sureBtn.titleLabel.font = FONT(14);
        [sureBtn addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = 0;
            make.height.offset = 40;
            make.width.offset = (WIDTH-20)/2;
            make.bottom.offset = 0;
        }];
        //取消的按钮
        UIButton *waitBtn = [UIButton new];
        [waitBtn setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
        [waitBtn setTitleColor:HEX(@"999999", 1) forState:UIControlStateNormal];
        waitBtn.titleLabel.font = FONT(14);
        [_centerView addSubview:waitBtn];
        [waitBtn addTarget:self action:@selector(clickWait) forControlEvents:UIControlEventTouchUpInside];
        [waitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.height.offset = 40;
            make.width.offset = (WIDTH-20)/2;
            make.bottom.offset = 0;
        }];
        UIView *line = [UIView new];
        line.backgroundColor = HEX(@"999999", 1);
        [waitBtn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.offset = 0;
            make.width.offset = 0.5;
        }];
    }
    return _centerView;
}
-(void)clickSure{
    if ([_textV.text isEqualToString:NSLocalizedString(@"请输入银行卡号或支付宝微信账号",nil)] || _textV.text.length == 0) {
        [self.superVC showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入提现账号",nil) inView:_centerView];
        return;
    }
    if (_textF.text.length == 0) {
        [self.superVC showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入提现金额",nil) inView:_centerView];
        return;
    }
    SHOW_HUD_INVIEW(_centerView)
    [HttpTool postWithAPI:@"client/member/money/apply" withParams:@{@"money":_textF.text,@"intro":_textV.text} success:^(id json) {
        HIDE_HUD_FOR_VIEW(_centerView)
        if (ISPostSuccess) {
            [self removeAnimation];
            [self.superVC showToastAlertMessageWithTitle:NSLocalizedString(@"申请提现成功,注意查看账户!",nil)];
        }else{
            [self.superVC showToastAlertMessageWithTitle:Error_Msg inView:_centerView];
        }
        
    } failure:^(NSError *error) {
        [self.superVC showToastAlertMessageWithTitle:NSLocalizedString(@"请求出错,请稍后再试",nil) inView:_centerView];
    }];
}
-(void)clickWait{
    [self removeAnimation];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset = WIDTH == 320? -70:-30;
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
    }];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text containsString:NSLocalizedString(@"请输入银行卡号",nil)]) {
        textView.text = @"";
        _textV.textColor = HEX(@"333333", 1);
    }
    [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset = WIDTH == 320? -70:-30;
    }];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        _textV.text = NSLocalizedString(@"请输入银行卡号或支付宝微信账号",nil);
        _textV.textColor = HEX(@"999999", 1);
    }
    [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
    }];
}
-(void)showAniamtion{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    self.alpha = 0;
    _textV.text = NSLocalizedString(@"请输入银行卡号或支付宝微信账号",nil);
    _textV.textColor = HEX(@"999999", 1);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}
-(void)clickRemove{
    if (_textV.isFirstResponder || _textF.isFirstResponder) {
        [_textV resignFirstResponder];
        [_textF resignFirstResponder];
    }else{
        [self removeAnimation];
    }
}
-(void)removeAnimation{
    [_textV resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
