//
//  JHFastLoginVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/4/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHFastLoginVC.h"
#import "ZQCountDownBtn.h"
#import "JHLoginAndRegisterViewModel.h"
#import "ZQNoteImageVerifyView.h"
#import "JHRegisterVC.h"
#import "JHADWebVC.h"

@interface JHFastLoginVC ()
@property(nonatomic,strong)UITextField *phoneField;//电话号码的输入框
@property(nonatomic,strong)UITextField *securityField;//验证码的输入框
@property(nonatomic,strong)ZQCountDownBtn *countDownBtn;//倒计时的按钮
@property(nonatomic,strong)UIButton *loginBtn;//登录的按钮
@property(nonatomic,strong)ZQNoteImageVerifyView *noteImageView;//图形验证
@end

@implementation JHFastLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //电话号码的输入框
    [self phoneField];
    //验证码的输入框
    [self securityField];
    //登录的按钮
    [self loginBtn];
    //
    [self addRegisterBtn];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = _bindWX? NSLocalizedString(@"微信绑定", nil):NSLocalizedString(@"快捷登录", nil);
}
#pragma mark - 添加右上角注册按钮
- (void)addRegisterBtn{
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 50, 44)];
    [registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:(UIControlStateNormal)];
    [registerBtn setTitleColor:HEX(@"FA4C34", 1.0) forState:UIControlStateNormal];
    registerBtn.titleLabel.font = FONT(16);
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:registerBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 手机号输入框
-(UITextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[UITextField alloc]init];
        _phoneField.font = FONT(15);
        _phoneField.placeholder = NSLocalizedString(@"手机号", nil);
        _phoneField.backgroundColor = HEX(@"f2f2f2", 1.0);
        _phoneField.layer.cornerRadius = 4;
        _phoneField.layer.masksToBounds = YES;
        _phoneField.textColor = HEX(@"333333", 1.0);
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view  addSubview:_phoneField];
        _phoneField.leftViewMode = UITextFieldViewModeAlways;
        _phoneField.rightViewMode = UITextFieldViewModeAlways;
        UIView *view = [[UIView alloc]initWithFrame:FRAME(0, 0, 15, 40)];
        _phoneField.leftView = view;
        UIView *view1 = [[UIView alloc]initWithFrame:FRAME(0, 0, 100, 40)];
        view1.backgroundColor = HEX(@"f2f2f2", 1.0);
        _phoneField.rightView = view1;
        [view1 addSubview:self.countDownBtn];
        [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 144;
            make.left.offset = 20;
            make.right.offset = -20;
            make.height.offset = 40;
        }];
    }
    return _phoneField;
}

#pragma mark - 密码输入框
-(UITextField *)securityField{
    if (!_securityField) {
        _securityField = [[UITextField alloc]init];
        _securityField.font = FONT(15);
        _securityField.placeholder = NSLocalizedString(@"验证码", nil);
        _securityField.backgroundColor = HEX(@"f2f2f2", 1.0);
        _securityField.layer.cornerRadius = 4;
        _securityField.layer.masksToBounds = YES;
        _securityField.textColor = HEX(@"333333", 1.0);
        _securityField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view  addSubview:_securityField];
        _securityField.leftViewMode = UITextFieldViewModeAlways;
        UIView *view = [[UIView alloc]initWithFrame:FRAME(0, 0, 15, 40)];
        _securityField.leftView = view;
        [_securityField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_phoneField.mas_bottom).offset = 25;
            make.left.offset = 20;
            make.right.offset = -20;
            make.height.offset = 40;
        }];
    }
    return _securityField;
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
            if (weakSelf.phoneField.text.length == 0) {
                [weakSelf showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入手机号!", nil)];
                return ;
            }else{
                weakSelf.countDownBtn.enabled = NO;
                [weakSelf.view endEditing:YES];
                [weakSelf postToGetCode];
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
            [weakSelf showToastAlertMessageWithTitle:err];
        }];
    }
    _noteImageView.phone = _phoneField.text;
    return _noteImageView;
}
#pragma mark - 获取验证码的接口
-(void)postToGetCode{
    [JHLoginAndRegisterViewModel postTosendSmsWithDic:@{@"mobile":_phoneField.text} block:^(NSString *error,NSString *sms_code) {
         _countDownBtn.enabled = YES;
        if (error) {
            [self showToastAlertMessageWithTitle:error];
        }else{
           if ([sms_code isEqualToString:@"0"]) {
                 [self.countDownBtn startCountDown];
          }else if([sms_code isEqualToString:@"1"]){
                 [self.noteImageView showAnimation];
         }
        }
    }];
}
#pragma mark - 登录的按钮
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setTitle:_bindWX? NSLocalizedString(@"立即绑定", nil):NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(clickLogintBtn) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.titleLabel.font = FONT(16);
        _loginBtn.backgroundColor = THEME_COLOR_Alpha(1);
        [self.view addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20;
            make.right.offset = -20;
            make.height.offset = 44;
            make.top.mas_equalTo(_securityField.mas_bottom).offset = 25;
        }];
    }
    return _loginBtn;
}
#pragma mark - 注册按钮点击事件
- (void)clickRegisterBtn{
    JHRegisterVC *registerVC = [JHRegisterVC new];
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark - 点击登录的方法/绑定微信
-(void)clickLogintBtn{
    [self.view endEditing:YES];
    __weak typeof(self)ws = self;
    if (_phoneField.text.length == 0) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入手机号!", nil)];
    }else if (_securityField.text.length == 0){
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请输入短信验证码!", nil)];
    }else{
        SHOW_HUD
        if (_bindWX) {//绑定微信
            [JHLoginAndRegisterViewModel postBindWeixinLoginWithDic:@{@"mobile":_phoneField.text,
                                                                      @"sms_code":_securityField.text,
                                                                      @"wx_openid":_wx_openid,
                                                                      @"wx_unionid":_wx_unionid,
                                                                      @"wx_nickname":_wx_nickname,
                                                                      @"wx_headimgurl":_wx_headimgurl}
                                                              block:^(NSString *error) {
                                                                  HIDE_HUD
                                                                  if (error) {
                                                                      [ws showToastAlertMessageWithTitle:error];
                                                                  }else{
                                                                      [NoticeCenter postNotificationName:Login_Success object:nil];
                                                                      [ws showToastAlertMessageWithTitle:NSLocalizedString(@"绑定微信成功,您已登录!", nil)];
                                                                      JHBaseVC *vc = self.navigationController.viewControllers[0];
                                                                      if ([vc isKindOfClass:NSClassFromString(@"JHWaiMaiHomeVC")]) {
                                                                          [self.navigationController popViewControllerAnimated:YES];
                                                                      }else{
                                                                          [vc dismissViewControllerAnimated:YES completion:nil];
                                                                      }
                                                                  }
                                                              }
                                                         newHongbao:^(BOOL have_newhb, NSString *newhb_link) {
                                                             if (have_newhb) {
                                                                 //有新人红包
                                                                 JHADWebVC *newHongbao = [[JHADWebVC alloc] init];
                                                                 
                                                                 newHongbao.url = newhb_link;
                                                                 [ws.navigationController pushViewController:newHongbao animated:YES];
                                                             }else{
                                                                 //没有新人红包
                                                                 JHBaseVC *vc = self.navigationController.viewControllers[0];
                                                                 [vc dismissViewControllerAnimated:YES completion:nil];
                                                             }
                                                         }];
        }else{//快捷登录
            [JHLoginAndRegisterViewModel postToFastLoginWithDic:@{@"mobile":_phoneField.text,@"sms_code":_securityField.text,@"register_id":[JHUserModel shareJHUserModel].registrationID} block:^(NSString *error) {
                HIDE_HUD
                if (error) {
                    [self showToastAlertMessageWithTitle:error];
                }else{
                    [NoticeCenter postNotificationName:Login_Success object:nil];
                    JHBaseVC *vc = self.navigationController.viewControllers[0];
                    if ([vc isKindOfClass:NSClassFromString(@"JHWaiMaiHomeVC")]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [vc dismissViewControllerAnimated:YES completion:nil];
                    }
                    [self showToastAlertMessageWithTitle:NSLocalizedString(@"您已成功登录!", nil)];
                }
            }];
        }
    }
}
@end
