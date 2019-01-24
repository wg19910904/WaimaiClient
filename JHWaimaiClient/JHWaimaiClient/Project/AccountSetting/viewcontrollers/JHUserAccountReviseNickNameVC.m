//
//  JHUserAccountReviseNickNameVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHUserAccountReviseNickNameVC.h"
#import "JHUserModel.h"
#import "JHUserAccountSetViewModel.h"
@interface JHUserAccountReviseNickNameVC ()@property(nonatomic,strong)UITextField *textF;//输入昵称的
@property(nonatomic,strong)UIButton *sureBtn;//确定的按钮
@end

@implementation JHUserAccountReviseNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
   //初始化一些数据的方法
    [self initData];
    //输入昵称的
    [self textF];
    //确定的按钮
    [self sureBtn];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"修改昵称", nil);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 输入框
-(UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.placeholder = NSLocalizedString(@"请输入昵称", nil);
        _textF.font = FONT(15);
        _textF.backgroundColor = [UIColor whiteColor];
        _textF.layer.cornerRadius = 4;
        _textF.layer.masksToBounds = YES;
        _textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textF.text = [JHUserModel shareJHUserModel].nickname;
        [self.view addSubview:_textF];
        [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.offset = 84;
            make.right.offset = -15;
            make.height.offset = 44;
        }];
        UILabel *lab = [[UILabel alloc]init];
        lab.text = NSLocalizedString(@"昵称:", nil);
        lab.textColor = HEX(@"333333", 1);
        lab.font = FONT(15);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.frame = FRAME(0, 0, 75, 44);
        _textF.leftViewMode = UITextFieldViewModeAlways;
        _textF.leftView = lab;
    }
    return _textF;
}
#pragma mark - 确定的按钮
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]init];
        [_sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(@"ffffff", 1) forState:UIControlStateNormal];
        _sureBtn.backgroundColor = THEME_COLOR_Alpha(1);
        _sureBtn.layer.cornerRadius = 4;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.titleLabel.font = FONT(16);
        [self.view addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.mas_equalTo(_textF.mas_bottom).offset = 20;
            make.right.offset = -15;
            make.height.offset = 44;
        }];
    }
    return _sureBtn;
}
#pragma mark - 点击确定的方法
-(void)clickBtn{
    if (_textF.text.length == 0) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入昵称!", nil)];
    }else{
        SHOW_HUD
        [JHUserAccountSetViewModel postToChangeNickNameWithDic:@{@"nickname":_textF.text} block:^(NSString *error) {
            HIDE_HUD
            if (error) {
                [self showToastAlertMessageWithTitle:error];
            }else{
                [self showToastAlertMessageWithTitle:NSLocalizedString(@"修改昵称成功!", nil)];
                [JHUserModel shareJHUserModel].nickname = _textF.text;
                if (_myBlock) {
                    _myBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
}
@end
