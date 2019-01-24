//
//  JHWMAddBankCardVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMAddBankCardVC.h"
#import "MineAddBankCardChooseBankCell.h"
#import "YFTextField.h"
#import "JHWMBankCardChooseTimePickerView.h"

@interface JHWMAddBankCardVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)YFTextField *nameField;
@property(nonatomic,weak)YFTextField *accountNumField;
@property(nonatomic,weak)YFTextField *timeField;
@property(nonatomic,weak)YFTextField *codeField;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,assign)BOOL is_text_editing;
@property(nonatomic,strong)JHWMBankCardChooseTimePickerView *chooseTimeView;
@property(nonatomic,strong)NSMutableDictionary *cardInfoDic;
@end

@implementation JHWMAddBankCardVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    self.cardInfoDic[@"card_type"] = self.model ? @(self.model.card_type) : @(1);
    
}

-(void)setUpView{
    
    self.dataArr = @[@{@"title": NSLocalizedString(@"卡名称", NSStringFromClass([self class])),@"placeholder":NSLocalizedString(@"请给您的信用卡起个名字", NSStringFromClass([self class]))},
                     @{@"title":NSLocalizedString(@"卡号", nil),@"placeholder": NSLocalizedString(@"请输入16位数信用卡卡号", NSStringFromClass([self class]))},
                     @{@"title": NSLocalizedString(@"有效期", NSStringFromClass([self class])),@"placeholder": NSLocalizedString(@"请选择有效期", NSStringFromClass([self class]))},
                     @{@"title": NSLocalizedString(@"安全码", NSStringFromClass([self class])),@"placeholder": NSLocalizedString(@"请输入信用卡背面安全码", NSStringFromClass([self class]))}];
    self.navigationItem.title = self.model ?  NSLocalizedString(@"解绑信用卡", NSStringFromClass([self class])) :  NSLocalizedString(@"绑定信用卡", NSStringFromClass([self class]));
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *ID=@"MineAddBankCardChooseBankCell";
        MineAddBankCardChooseBankCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[MineAddBankCardChooseBankCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell reloadCellWithCartType:[self.cardInfoDic[@"card_type"] intValue] is_edit:(self.model ? YES : NO)];
         __weak typeof(self) weakSelf=self;
        cell.clickIndex = ^(NSInteger index){// 选择不同类型卡
            weakSelf.cardInfoDic[@"card_type"] = @(index + 1);
            [weakSelf.tableView reloadData];
        };
        
        return cell;
    }else{
        static NSString *ID=@"BankTextFieldCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.font = FONT(14);
            cell.textLabel.textColor = HEX(@"333333", 1.0);
            if (indexPath.row != 0) {
                YFTextField *textField = [YFTextField new];
                [cell addSubview:textField];
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset=70;
                    make.top.offset=0;
                    make.right.offset=0;
                    make.height.offset=40;
                    make.bottom.offset=0;
                }];
                textField.font = FONT(14);
                textField.textColor = HEX(@"666666", 1.0);
                textField.placeholdeColor = HEX(@"cccccc", 1.0);
                textField.placeholdeFont = FONT(14);
                textField.tag = 100;
                textField.clearButtonMode = self.model ? UITextFieldViewModeNever : UITextFieldViewModeWhileEditing;
                textField.returnKeyType = UIReturnKeyDone;
                textField.delegate = self;
                textField.userInteractionEnabled = self.model ? NO : YES;
                
                if (indexPath.row == 1) {
                    self.nameField = textField;
                }else if (indexPath.row == 2){
                    self.accountNumField = textField;
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                }else if (indexPath.row == 3){
                    self.timeField = textField;
                    textField.userInteractionEnabled = NO;
                }else{
                    self.codeField = textField;
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                }
            }
            
        }
        
        cell.textLabel.text = self.dataArr[indexPath.row - 1][@"title"];
        YFTextField *field = [cell viewWithTag:100];
        field.placeholder = self.dataArr[indexPath.row - 1][@"placeholder"];

        if (self.model) {
            self.accountNumField.text = self.model.card_number;
            self.codeField.text = self.model.cvc;
            self.nameField.text = self.model.card_name;
            self.timeField.text = [NSString stringWithFormat:@"%@/%@",self.model.exp_year,self.model.exp_month];
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    UIView *view = [UIView new];
    view.backgroundColor = BACK_COLOR;
    
    UIButton *sureBtn = [UIButton new];
    [view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.bottom.offset=0;
        make.right.offset=-10;
        make.height.offset=40;
    }];
    sureBtn.layer.cornerRadius=4;
    sureBtn.clipsToBounds=YES;
    sureBtn.titleLabel.font = FONT(16);
    sureBtn.backgroundColor = self.model ? HEX(@"ff3300", 1.0) : THEME_COLOR_Alpha(1.0);
    NSString *str = self.model ?  NSLocalizedString(@"解除绑定", NSStringFromClass([self class])) : NSLocalizedString(@"确认绑定", NSStringFromClass([self class]));
    [sureBtn setTitle:str forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.model ? CGFLOAT_MIN : 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.model) {
        return nil;
    }
    UIView *view = [UIView new];
    view.backgroundColor = BACK_COLOR;
    
    UILabel *lab = [UILabel new];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    lab.font = FONT(12);
    lab.textColor = HEX(@"999999", 1.0);
    lab.text =  NSLocalizedString(@"请绑定您的信用卡", NSStringFromClass([self class]));
    
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3 && !self.model) {
        [self.view endEditing:YES];
        [self.view resignFirstResponder];
        [self.chooseTimeView show];
    }
}

#pragma mark ====== UIScrollViewDelegate =======
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.is_text_editing) {
        [self.view endEditing:YES];
        [self.view resignFirstResponder];
    }
}

#pragma mark ====== UITextFieldDelegate =======
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.is_text_editing = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.is_text_editing = NO;
    });
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ====== Functions =======
-(void)clickSure{
    
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
    
    
    if (self.model) {// 解除绑定
        SHOW_HUD
        [MineBankModel unbindBankCardWith:self.model.card_id block:^(BOOL success, NSString *msg) {
            HIDE_HUD
            if (success) {
                YF_SAFE_BLOCK(self.successBlock,YES,nil);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            [self showToastAlertMessageWithTitle:msg];
        }];
    }else{// 确认绑定
        
        if (self.nameField.text.length == 0 || self.accountNumField.text.length == 0 || self.timeField.text.length == 0 || self.codeField.text.length == 0 ) {
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"请填写完整信息", nil)];
            return;
        }
        SHOW_HUD
        _cardInfoDic[@"card_number"] = self.accountNumField.text;
        _cardInfoDic[@"cvc"] = self.codeField.text;
        _cardInfoDic[@"card_name"] = self.nameField.text;
        
        [MineBankModel bindBankCardWith:_cardInfoDic.copy block:^(BOOL success, NSString *msg) {
            HIDE_HUD
            if (success) {
                YF_SAFE_BLOCK(self.successBlock,YES,nil);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            [self showToastAlertMessageWithTitle:msg];
        }];
    }
    
}

#pragma mark ====== 懒加载 =======
-(JHWMBankCardChooseTimePickerView *)chooseTimeView{
    if (_chooseTimeView==nil) {
        __weak typeof(self) weakSelf=self;
        _chooseTimeView=[[JHWMBankCardChooseTimePickerView alloc] initWithType:YFPickerViewTypeTwoRow];
        _chooseTimeView.timeChooseBlock = ^(NSString *year,NSString *month){
            weakSelf.cardInfoDic[@"year"] = [year componentsSeparatedByString: NSLocalizedString(@"年", NSStringFromClass([self class]))].firstObject;
            weakSelf.cardInfoDic[@"mouth"] = [month componentsSeparatedByString: NSLocalizedString(@"月", NSStringFromClass([self class]))].firstObject;
            weakSelf.timeField.text = [NSString stringWithFormat:@"%@/%@",year,month];
        };
        NSArray *arr = @[];
        _chooseTimeView.dataSource = arr;
    }
    return _chooseTimeView;
}

-(NSMutableDictionary *)cardInfoDic{
    if (_cardInfoDic==nil) {
        _cardInfoDic=[[NSMutableDictionary alloc] init];
        _cardInfoDic[@"card_number"] = @"";
        _cardInfoDic[@"card_type"] = @"1";
        _cardInfoDic[@"cvc"] = @"";
        _cardInfoDic[@"card_name"] = @"";
        _cardInfoDic[@"year"] = @"";
        _cardInfoDic[@"mouth"] = @"";
    }
    return _cardInfoDic;
}
@end
