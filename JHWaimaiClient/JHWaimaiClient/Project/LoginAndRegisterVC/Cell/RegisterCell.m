//
//  RegisterCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/4/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "RegisterCell.h"
#import "ZQCountDownBtn.h"
#import "JHLoginAndRegisterViewModel.h"
#import "ZQNoteImageVerifyView.h"
@interface RegisterCell(){
    NSArray *arr;
}
@property(nonatomic,strong)ZQCountDownBtn *countDownBtn;//倒计时的按钮
@property(nonatomic,strong)ZQNoteImageVerifyView *noteImageView;//图形验证
@end
@implementation RegisterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BACK_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self textF];
        arr = @[NSLocalizedString(@"手机号", nil),
                NSLocalizedString(@"验证码", nil),
                NSLocalizedString(@"密码", nil),
                 NSLocalizedString(@"确认密码", nil)];
    }
    return self;
}
#pragma mark - 输入框
-(UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.font = FONT(15);
        _textF.backgroundColor = HEX(@"f2f2f2", 1.0);
        _textF.layer.cornerRadius = 4;
        _textF.layer.masksToBounds = YES;
        _textF.textColor = HEX(@"333333", 1.0);
        [self addSubview:_textF];
        _textF.leftViewMode = UITextFieldViewModeAlways;
        _textF.rightViewMode = UITextFieldViewModeNever;
        UIView *view = [[UIView alloc]initWithFrame:FRAME(0, 0, 15, 40)];
        _textF.leftView = view;
        UIView *view1 = [[UIView alloc]initWithFrame:FRAME(0, 0, 100, 40)];
        view1.backgroundColor = HEX(@"f2f2f2", 1.0);
        _textF.rightView = view1;
        [view1 addSubview:self.countDownBtn];
        [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 0;
            make.left.offset = 20;
            make.right.offset = -20;
            make.height.offset = 40;
        }];
    }
    return _textF;
}
#pragma mark - 倒计时的按钮
-(ZQCountDownBtn *)countDownBtn{
    if (!_countDownBtn) {
        _countDownBtn = [[ZQCountDownBtn alloc]init];
        _countDownBtn.frame = FRAME(5, 5, 90, 30);
        _countDownBtn.layer.cornerRadius = 2;
        _countDownBtn.layer.masksToBounds = YES;
        _countDownBtn.titleLabel.font = FONT(14);
        _countDownBtn.backgroundColor = [UIColor whiteColor];
        [_countDownBtn setTitleColor:THEME_COLOR_Alpha(1) forState:UIControlStateNormal];
        __weak typeof (self)weakSelf = self;
        [_countDownBtn setClickBlock:^{
            if (weakSelf.textF.text.length == 0) {
                [weakSelf.superVC showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入手机号!", nil)];
                return ;
            }else{
                weakSelf.countDownBtn.enabled = NO;
                [weakSelf endEditing:YES];
                [weakSelf postMsms];
            }
        }];
    }
    return _countDownBtn;
}
#pragma mark - 图形验证的显示
-(ZQNoteImageVerifyView *)noteImageView{
    if (!_noteImageView) {
        _noteImageView = [[ZQNoteImageVerifyView alloc]init];
        _noteImageView.getCodeApi = @"magic/verify";
        _noteImageView.verifyApi = @"magic/sendsms";
        __weak typeof (self)weakSelf = self;
        [_noteImageView setSuccessBlock:^{
            [weakSelf.countDownBtn startCountDown];
        }];
        [_noteImageView setFailBlock:^(NSString  *err){
            [weakSelf.superVC showToastAlertMessageWithTitle:err];
        }];
    }
     _noteImageView.phone = _textF.text;
    return _noteImageView;
}
-(void)setIndex:(NSInteger)index{
    _index = index;
    _textF.placeholder = arr[index];
    if (index == 0) {
        _textF.rightViewMode = UITextFieldViewModeAlways;
    }else{
        _textF.rightViewMode = UITextFieldViewModeNever;
    }
    if (index <= 1) {
         _textF.keyboardType = UIKeyboardTypeNumberPad;
         _textF.secureTextEntry = NO;
    }else{
        _textF.keyboardType = UIKeyboardTypeDefault;
        _textF.secureTextEntry = YES;
    }
}
#pragma mark - 发送验证码
-(void)postMsms{
    [JHLoginAndRegisterViewModel postTosendSmsWithDic:@{@"mobile":_textF.text} block:^(NSString *error,NSString *sms_code) {
        _countDownBtn.enabled = YES;
        if (error) {
            [_superVC showToastAlertMessageWithTitle:error];
        }else{
           if ([sms_code isEqualToString:@"0"]) {
                [self.countDownBtn startCountDown];
           }else if([sms_code isEqualToString:@"1"]){
                [self.noteImageView showAnimation];
          }
        }
    }];
}
@end
