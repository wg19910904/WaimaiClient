//
//  JHLoginVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/4/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHLoginVC.h"
#import "JHLoginAndRegisterViewModel.h"
#import <UMSocialCore/UMSocialCore.h>
#import "JHFastLoginVC.h"
@interface JHLoginVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *nameField;//名字输入框
@property(nonatomic,strong)UITextField *psdField;//密码输入框
@property(nonatomic,strong)UIButton *weixinBtn;//点击微信登录的按钮
@end

@implementation JHLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //创建账号和密码的输入框
    [self creatTextField];
    //添加登录注册
    [self creatLoginAndRegisterBtn];
    //添加快捷登录和忘记密码?
    [self creatFastLoginAndForgotpsd];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        //点击微信登录的按钮
        [self weixinBtn];
        //显示第三方登录的标题的
        [self addLineAndtitle];
    }
    //注册退出的通知的监听
    [NoticeCenter addObserver:self selector:@selector(loginOut) name:QuitLogin object:nil];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UMSocialManager defaultManager]cancelAuthWithPlatform:UMSocialPlatformType_WechatSession completion:nil];
}
-(void)loginOut{
     // [self showToastAlertMessageWithTitle:NSLocalizedString(@"您已修改个人信息,请重新登录!", nil)];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - 初始化一些数据
-(void)initData{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"icon_close") style:UIBarButtonItemStylePlain target:self action:@selector(clickReturn)];
    //leftItem.imageInsets = UIEdgeInsetsMake(2, -6, 3, 1);
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTintColor:TEXT_COLOR];
    self.navigationItem.title = NSLocalizedString(@"账号登录", nil);
}
-(void)clickReturn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 创建账号和密码的输入框
-(void)creatTextField{
    NSArray *placeHolderArr = @[NSLocalizedString(@"账号", nil),
                                NSLocalizedString(@"密码", nil)];
    for (int i = 0; i < 2; i ++) {
        UITextField *textF = [[UITextField alloc]init];
        textF.placeholder = placeHolderArr[i];
        textF.font = FONT(15);
        textF.backgroundColor = HEX(@"f2f2f2", 1.0);
        textF.layer.cornerRadius = 4;
        textF.layer.masksToBounds = YES;
        textF.delegate = self;
        textF.textColor = HEX(@"333333", 1.0);
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:textF.placeholder];
        [attribute addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1)} range:NSMakeRange(0, textF.placeholder.length)];
        textF.attributedPlaceholder = attribute;
        textF.leftViewMode = UITextFieldViewModeAlways;
        UIView *view = [[UIView alloc]initWithFrame:FRAME(0, 0, 15, 40)];
        textF.leftView = view;
        //右边的删除按钮
        textF.rightViewMode = UITextFieldViewModeNever;
        UIButton *rightBtn = [[UIButton alloc]init];
        rightBtn.frame = FRAME(0, 0, 30, 30);
        rightBtn.tag = i;
        [rightBtn setImage:IMAGE(@"btn_reset") forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(clickRemoveText:) forControlEvents:UIControlEventTouchUpInside];
        textF.rightView = rightBtn;
        [self.view addSubview:textF];
        if (i == 1) {
            textF.secureTextEntry = YES;
            _psdField = textF;
        }else{
            _nameField = textF;
            textF.keyboardType = UIKeyboardTypeNumberPad;
        }
        [textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 144+(40+25)*i;
            make.left.offset = 20;
            make.right.offset = -20;
            make.height.offset = 40;
        }];
    }
}
#pragma mark - 点击删除输入框的文本
-(void)clickRemoveText:(UIButton *)sender{
    if (sender.tag == 0) {
        _nameField.text = @"";
        _nameField.rightViewMode = UITextFieldViewModeNever;
    }else{
        _psdField.text = @"";
        _psdField.rightViewMode = UITextFieldViewModeNever;
    }
}
#pragma mark - 输入框的代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     textField.rightViewMode = UITextFieldViewModeAlways;
    if (textField.text.length == 1 && string.length == 0) {
         textField.rightViewMode = UITextFieldViewModeNever;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.rightViewMode = UITextFieldViewModeNever;
}
#pragma mark - 创建登录注册的按钮
-(void)creatLoginAndRegisterBtn{
    NSArray *titleArr = @[NSLocalizedString(@"注册", nil),
                          NSLocalizedString(@"登录", nil)];
    NSArray *backGroundColorArr = @[[UIColor whiteColor],THEME_COLOR_Alpha(1.0)];
     NSArray *titleColor = @[THEME_COLOR_Alpha(1.0),[UIColor whiteColor]];
    CGFloat w = (WIDTH - 60)/2;
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = backGroundColorArr[i];
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = THEME_COLOR_Alpha(1.0).CGColor;
        btn.layer.borderWidth = 0.5;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:titleColor[i] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(16);
        [btn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20+(w+20)*i;
            make.height.offset = 44;
            make.top.mas_equalTo(_psdField.mas_bottom).offset = 29;
            make.width.offset = w;
        }];
    }
}
#pragma mark - 点击登录注册的按钮
-(void)clickLoginBtn:(UIButton *)sender{
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
    if (sender.tag == 0) {
        //点击了注册
        [self classJump:@"JHRegisterVC"];
    }else{
        if (_nameField.text.length == 0) {
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入您的账号!", nil)];
        }else if(_psdField.text.length == 0){
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入您的密码!", nil)];
        }else{
            SHOW_HUD
            //点击了登录
            [JHLoginAndRegisterViewModel postToLoginWithDic:@{@"mobile":_nameField.text,@"passwd":_psdField.text,@"register_id":[JHUserModel shareJHUserModel].registrationID} block:^(NSString *error) {
                HIDE_HUD
                if (error) {
                    [self showToastAlertMessageWithTitle:error];
                }else{
                    [NoticeCenter postNotificationName:Login_Success object:nil];
                    [self showToastAlertMessageWithTitle:NSLocalizedString(@"您已成功登录!", nil)];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }];
  
        }
    }
}
#pragma mark - 创建快捷登录和忘记密码的按钮
-(void)creatFastLoginAndForgotpsd{
    NSArray *titleArr = @[NSLocalizedString(@"快捷登录", nil),
                          NSLocalizedString(@"忘记密码?", nil),];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = BACK_COLOR;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"333333", 1) forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(15);
        [btn addTarget:self action:@selector(clickFastLoginAndForgotBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20+(WIDTH -120)*i;
            make.height.offset = 30;
            make.top.mas_equalTo(_psdField.mas_bottom).offset = 88;
            make.width.offset = 80;
        }];
    }
}
#pragma mark - 点击登录注册的按钮
-(void)clickFastLoginAndForgotBtn:(UIButton *)sender{
    if (sender.tag == 0) {
        //点击了快捷登录
        [self classJump:@"JHFastLoginVC"];
    }else{
        //点击了忘记密码?
        [self classJump:@"JHForgotVC"];
    }
}
#pragma mark - 创建显示第三方登录标题
-(void)addLineAndtitle{
    UIView *view = [UIView new];
    view.backgroundColor = HEX(@"d8d8d8", 1);
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.right.offset = -20;
        make.height.offset = 1;
        make.bottom.mas_equalTo(_weixinBtn.mas_top).offset = -27*(WIDTH/375);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = BACK_COLOR;
    label.text =  NSLocalizedString(@"第三方登录",nil);
    label.font = FONT(15*(WIDTH/375));
    label.textColor = HEX(@"999999", 1);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.offset = 20*(WIDTH/375);
        make.width.offset = 80*(WIDTH/375);
        make.bottom.mas_equalTo(_weixinBtn.mas_top).offset = -18*(WIDTH/375);
    }];
    
}
#pragma mark - 点击微信登录的按钮
-(UIButton *)weixinBtn{
    if (!_weixinBtn) {
        _weixinBtn = [[UIButton alloc]init];
        [_weixinBtn setImage:IMAGE(@"btn_weixin") forState:UIControlStateNormal];
        [_weixinBtn setTitle:NSLocalizedString(@"微信", nil) forState:UIControlStateNormal];
        [_weixinBtn setTitleColor:HEX(@"666666", 1) forState:UIControlStateNormal];
        _weixinBtn.titleLabel.font = FONT(15);
        _weixinBtn.imageEdgeInsets = UIEdgeInsetsMake(-12.5, 0, 12.5, 0);
        _weixinBtn.titleEdgeInsets = UIEdgeInsetsMake(25,-60, -25, 0);
        [self.view addSubview:_weixinBtn];
        [_weixinBtn addTarget:self action:@selector(clickWeixinLogin) forControlEvents:UIControlEventTouchUpInside];
        [_weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.offset = 60;
            make.height.offset = 85;
            make.bottom.offset = -95*(WIDTH/375);
        }];
    }
    return _weixinBtn;
}
#pragma mark - 点击微信登录
-(void)clickWeixinLogin{
    NSLog(@"点击微信登录");
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (!error) {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            if (!resp.uid) {
                [self showToastAlertMessageWithTitle:NSLocalizedString(@"微信登录失败", nil)];
                return;
            }
            SHOW_HUD
            [JHLoginAndRegisterViewModel postToWeixinLoginWithDic:@{@"register_id":[JHUserModel shareJHUserModel].registrationID,@"wx_openid":resp.openid,@"wx_unionid":resp.uid} block:^(NSString *error) {
                HIDE_HUD
                if (error) {
                    [self showToastAlertMessageWithTitle:error];
                }else{
                    if ([[JHUserModel shareJHUserModel].wxtype isEqualToString:@"wxbind"]) {//需要绑定微信
                        JHFastLoginVC *vc = [[JHFastLoginVC alloc]init];
                        vc.bindWX = YES;
                        vc.wx_openid =resp.openid;
                        vc.wx_unionid =resp.uid;
                        vc.wx_nickname = resp.name;
                        vc.wx_headimgurl = resp.iconurl;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{//直接登录
                        [NoticeCenter postNotificationName:Login_Success object:nil];
                        [self showToastAlertMessageWithTitle:NSLocalizedString(@"您已成功登录!", nil)];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self dismissViewControllerAnimated:YES completion:nil];
                        });
                    }
                }
            }];
        }else{
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"微信登录失败", nil)];
        }
    }];
}
#pragma mark - 通过控制器名字跳转
-(void)classJump:(NSString *)name{
    Class class = NSClassFromString(name);
    JHBaseVC *vc = [[class alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
