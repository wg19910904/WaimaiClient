//
//  JHWMCreateOrderPayTypeSheetView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMCreateOrderPayTypeSheetView.h"
#import "JHWMPayOrderMoneyCell.h"
#import "JHWaimaiOrderPayTypeCell.h"
#import "AppDelegate.h"
#import "NSString+Tool.h"
#import "UIControl+TimeInterVal.h"

@interface JHWMCreateOrderPayTypeSheetView()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger selIndex;//选中的索引
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,weak)UIControl *control;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)id<JHWMCreateOrderPayTypeSheetViewDelegate> delegate;
@property(nonatomic,assign)float cellHeight;
@property(nonatomic,assign)CGFloat tabH;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,assign)BOOL is_use_money;//使用余额（包含余额不足不包含0）
@property(nonatomic,assign)BOOL is_can_user_other;// 使用其他方式支付（除余额外的方式）
@property(nonatomic,copy)NSString *pay_code;
@property(nonatomic,copy)NSString *title;
@end

@implementation JHWMCreateOrderPayTypeSheetView

-(JHWMCreateOrderPayTypeSheetView *)initWithTitle:(NSString *)title amount:(NSString *)amount delegate:(id<JHWMCreateOrderPayTypeSheetViewDelegate>)delegate{
    
    self = [[JHWMCreateOrderPayTypeSheetView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    self.delegate = delegate;
    
    UIControl *control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    control.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [control addTarget:self action:@selector(sheetHidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    self.control=control;
    
    UIView *topView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    [control addSubview:topView];
    
    self.title = title;
    UILabel *titleLab = [UILabel new];
    [topView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    titleLab.font = FONT(16);
    titleLab.textColor = TEXT_COLOR;
    titleLab.textAlignment = NSTextAlignmentCenter;
    if (amount.length == 0) {
        titleLab.text = title;
    }else{
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title];
        
        [attStr appendAttributedString:[NSString getAttributeString:[NSString stringWithFormat:@" %@%@",NSLocalizedString(@"¥", nil),amount] strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff6600", 1.0)}]];
        titleLab.attributedText = attStr;
    }
    self.titleLab = titleLab;
    
    UIButton *hiddenBtn = [UIButton new];
    [topView addSubview:hiddenBtn];
    [hiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=13;
        make.centerY.offset=0;
        make.width.offset=28;
        make.height.offset=28;
    }];
    [hiddenBtn setImage:IMAGE(@"index_btn_close") forState:UIControlStateNormal];
    [hiddenBtn addTarget:self action:@selector(sheetHidden) forControlEvents:UIControlEventTouchUpInside];

    self.cellHeight = 60;
    self.tabH = 245 + 50;
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT+50, WIDTH, self.tabH) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [control addSubview:tableView];
    tableView.scrollEnabled=NO;
    tableView.backgroundColor=[UIColor whiteColor];
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    tableView.tableHeaderView = topView;
    self.dataSource =@[
                       @{@"title":NSLocalizedString(@"余额支付", nil),@"img":@"icon_moneyPay",@"code":@"money"},
                       @{@"title":NSLocalizedString(@"支付宝支付", nil),@"img":@"icon_aliPay",@"code":@"alipay"},
                       @{@"title":NSLocalizedString(@"微信支付", nil),@"img":@"icon_wechatPay",@"code":@"wxpay"}
                       ];
    [topView layoutIfNeeded];
    return self;
    
}

-(void)setAmount:(NSString *)amount{
    
    _amount = amount;
    self.is_use_money = [[JHUserModel shareJHUserModel].money floatValue] > 0;
    _pay_code = ([[JHUserModel shareJHUserModel].money floatValue] >= [self.amount floatValue]) ? @"money" : @"alipay";
    selIndex =[[JHUserModel shareJHUserModel].money floatValue] >= [self.amount floatValue] ? 0 :  1;
    [self dealWithMoneyPayOrder];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.title ];
    [attStr appendAttributedString:[NSString getAttributeString:[NSString stringWithFormat:@" %@%@",NSLocalizedString(@"¥", nil),amount] strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff6600", 1.0)}]];
    self.titleLab.attributedText = attStr;
    
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 0) {
        static NSString *str = @"JHWMPayOrderMoneyCell";
        JHWMPayOrderMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWMPayOrderMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.is_hidden_line = YES;
        }
        
        [cell relaodCellWith:self.amount];
        __weak typeof(self) weakSelf=self;
        cell.changeStatus =^(BOOL is_money){
            weakSelf.is_use_money = is_money;
            [weakSelf dealWithMoneyPayOrder];
        };
        return cell;
    }else{
        static NSString *str = @"JHWaimaiOrderPayTypeCell";
        JHWaimaiOrderPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderPayTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            cell.isHid = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = self.dataSource[indexPath.row];
        cell.typeImg = dic[@"img"];
        cell.title   = dic[@"title"];
        if (indexPath.row == selIndex) {
            cell.rightImg = self.is_can_user_other ? @"index_selector_enable" : @"index_selector_disable";
        }else{
            cell.rightImg = @"index_selector_disable";
        }
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight == 0 ? 50 : self.cellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
  return self.footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row > 0 && self.is_can_user_other) {
        selIndex = indexPath.row;
        NSDictionary *dic = self.dataSource[indexPath.row];
        _pay_code = dic[@"code"];
        [tableView reloadData];
    }
}

#pragma mark ====== Functions =======
// 使用余额支付的处理
-(void)dealWithMoneyPayOrder{

    if (self.is_use_money) {
        _pay_code = ([[JHUserModel shareJHUserModel].money floatValue] >= [self.amount floatValue]) ? @"money" : _pay_code;
    }else{
        selIndex = 1;
        _pay_code = [_pay_code isEqualToString:@"money"] ? @"alipay" : _pay_code;
    }
    self.is_can_user_other = !([_pay_code isEqualToString:@"money"] && self.is_use_money);
    [self.tableView reloadData];

}

// 支付
-(void)goPay{

    if (self.delegate && [self.delegate respondsToSelector:@selector(payOrderWith:use_money:)]) {
        [self.delegate payOrderWith:self.pay_code use_money:self.is_use_money];
    }
}

-(void)sheetShow{
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self.control];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.control.alpha=1;
    }];
    
    [self.tableView reloadData];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.y=HEIGHT-self.tabH;
        [self.control layoutIfNeeded];
    }];   
}

-(void)sheetHidden{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelPayOrder)]) {
        [self.delegate cancelPayOrder];
    }

    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.y=HEIGHT+50;
    }];
    
    
    [UIView animateWithDuration:0.4 animations:^{
        self.control.alpha=0;
    }];
    [self removeFromSuperview];
    
}

#pragma mark ====== 懒加载=======
-(UIView *)footerView{
    if (_footerView==nil) {
        
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 65)];
        view.backgroundColor = BACK_COLOR;
        
        UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, 5, WIDTH, 60)];
        [view addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        
        UIButton *payBtn = [[UIButton alloc] initWithFrame:FRAME(10, 10, WIDTH-20, 40)];
        [backView addSubview:payBtn];
        payBtn.layer.cornerRadius=4;
        payBtn.clipsToBounds=YES;
        payBtn.backgroundColor = HEX(@"ff6600", 1.0);
        payBtn.titleLabel.font = FONT(16);
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn setTitle:NSLocalizedString(@"去支付", nil) forState:UIControlStateNormal];
        payBtn.responderTimeInterval = 1.5;
        [payBtn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
        
        _footerView = view;
    }
    return _footerView;
}

@end
