//
//  JHRegisterVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/4/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHRegisterVC.h"
#import "RegisterCell.h"
#import <IQKeyboardManager.h>
#import "JHLoginAndRegisterViewModel.h"
#import "JHADWebVC.h"
@interface JHRegisterVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *myTableView;//表视图
@property(nonatomic,strong)UIButton *submitBtn;//提交的按钮
@property(nonatomic,strong)UITextField *phoneField;//手机号输入框
@property(nonatomic,strong)UITextField *securityField;//验证码输入框
@property(nonatomic,strong)UITextField *psdField;//密码输入框
@property(nonatomic,strong)UITextField *surePsdField;//确认密码输入框
@end

@implementation JHRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //创建表
    [self myTableView];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    self.view.backgroundColor = BACK_COLOR;
    self.navigationItem.title = NSLocalizedString(@"注册", nil);
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.backgroundColor = BACK_COLOR;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap)];
            table.userInteractionEnabled = YES;
            [table addGestureRecognizer:tap];
            table;
        });
    }
    return _myTableView;
}
-(void)clickTap{
    [self.view endEditing:YES];
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }
    return 25;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = BACK_COLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 120;
    }
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        UIView *view = [UIView new];
        view.backgroundColor = BACK_COLOR;
        [self submitBtn:view];
        return view;

    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"reristerCell";
    RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[RegisterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.superVC = self;
    cell.index = indexPath.section;
    cell.textF.delegate = self;
    if (indexPath.section == 0) {
        _phoneField = cell.textF;
    }else if (indexPath.section == 1){
         _securityField = cell.textF;
    }else if (indexPath.section == 2){
         _psdField = cell.textF;
    }
    else {
         _surePsdField = cell.textF;
    }
    return cell;
}
#pragma mark - 提交的按钮
-(UIButton *)submitBtn:(UIView *)view{
//    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc]init];
        _submitBtn.layer.cornerRadius = 4;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.titleLabel.font = FONT(16);
        _submitBtn.backgroundColor = THEME_COLOR_Alpha(1);
        [view addSubview:_submitBtn];
        [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20;
            make.right.offset = -20;
            make.height.offset = 44;
            make.top.offset = 25;
        }];
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:NSLocalizedString(@"<查看用户协议>", nil) forState:UIControlStateNormal];
        [btn setTitleColor:THEME_COLOR_Alpha(1) forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(14);
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20;
            make.height.offset = 30;
            make.top.mas_equalTo(_submitBtn.mas_bottom).offset = 10;
        }];
        [btn addTarget:self action:@selector(clickToSeeAgreement) forControlEvents:UIControlEventTouchUpInside];
//    }
    return _submitBtn;
}
//查看用户协议的
-(void)clickToSeeAgreement{
    JHADWebVC *vc = [[JHADWebVC alloc]init];
    vc.url = userAgreeUrl;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 点击提交的方法
-(void)clickSubmitBtn{
    [self.view endEditing:YES];
    NSString *str = nil;
    if (_phoneField.text.length == 0) {
        str = NSLocalizedString(@"请先输入手机号!", nil);
    }else if(_securityField.text.length == 0){
        str = NSLocalizedString(@"请先输入验证码!", nil);
    }else if(_psdField.text.length < 6){
        str = NSLocalizedString(@"请输入6位以上密码!", nil);
    }else if(![_surePsdField.text isEqualToString:_psdField.text]) {
        str = NSLocalizedString(@"两次密码输入不一致,请重新输入!", nil);
    }else if(_surePsdField.text.length == 0) {
        str = NSLocalizedString(@"请再次输入密码!", nil);
    }
    if (str) {
       [self showToastAlertMessageWithTitle:str];
    }else{//注册
       [self postToRegist];
    }
}
#pragma mark - 注册的方法
-(void)postToRegist{
    SHOW_HUD
    __weak typeof(self)ws = self;
    [JHLoginAndRegisterViewModel postToRegisteWithDic:@{@"mobile":_phoneField.text,
                                                        @"passwd":_psdField.text,
                                                        @"sms_code":_securityField.text,
                                                        @"register_id":[JHUserModel shareJHUserModel].registrationID}
                                                block:^(NSString *error) {
                                                    HIDE_HUD
                                                    if (error) {
                                                        [ws showToastAlertMessageWithTitle:error];
                                                    }else{
                                                        [NoticeCenter postNotificationName:Login_Success object:nil];
                                                        [ws showToastAlertMessageWithTitle:NSLocalizedString(@"您已成功登录!", nil)];
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
}
#pragma mark - uitextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
#pragma mark - 滑动表的时候让键盘下落
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
#pragma mark - 这是表结束减速的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 这是表开始拖动的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}

@end
