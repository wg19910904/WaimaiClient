//
//  JHPayVC.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHPayVC.h"
#import "YFPayMoneyCell.h"
#import "YFPayTypeCell.h"
#import "YFPayTool.h"
#import "JHWaimaiMineViewModel.h"
#import "MineBankModel.h"
#import "NSString+Tool.h"

@interface JHPayVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;//表视图
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,copy)NSString *pay_code;// money 只用余额支付
@property(nonatomic,assign)NSInteger selIndex;
@property(nonatomic,assign)BOOL is_use_money;//使用余额（包含余额不足不包含0）
@property(nonatomic,strong)MineBankModel *bankModel;
@end

@implementation JHPayVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self initData];
    [self setUpView];
    [self getData];
}

-(void)setUpView{
    
    self.navigationItem.title = NSLocalizedString(@"支付页面", nil);
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 70) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.backgroundColor = BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.scrollEnabled = NO;
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setUpBottomView];
}

-(void)setUpBottomView{
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(70);
    }];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:FRAME(10, 10, WIDTH-20, 40)];
    [bottomView addSubview:payBtn];
    payBtn.layer.cornerRadius=4;
    payBtn.clipsToBounds=YES;
    payBtn.backgroundColor = HEX(@"FF725C", 1.0);
    payBtn.titleLabel.font = FONT(16);
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitle:NSLocalizedString(@"确认支付",nil) forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(clickToPay) forControlEvents:UIControlEventTouchUpInside];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 1 ? self.dataSource.count : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     __weak typeof(self) weakSelf=self;
    if (indexPath.section == 0) {
        YFPayMoneyCell *cell = [YFPayMoneyCell initWithTableView:tableView reuseIdentifier:@"YFPayMoneyCell"];
        cell.timeOverBlock = ^(BOOL success, NSString *msg) {
            [weakSelf showToastAlertMessageWithTitle: NSLocalizedString(@"超时未支付,订单已取消", NSStringFromClass([self class]))];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf clickBackBtn];
            });
        };
        [cell reloadCellWithMoney:self.amount dateline:self.dateline];
        return cell;
    }else{
        YFPayTypeCell *cell = [YFPayTypeCell initWithTableView:tableView reuseIdentifier:@"YFPayTypeCell"];
        NSDictionary *dic = self.dataSource[indexPath.row];
        
        BOOL enough = ([[JHUserModel shareJHUserModel].money floatValue] - [self.amount floatValue]) >= 0;
        BOOL selected = NO;
        if (enough) {
            selected = self.selIndex == indexPath.row;
            if (selected) {
                cell.moneyLab.text = [NSString stringWithFormat: NSLocalizedString(@"(¥%@)", NSStringFromClass([self class])),self.amount];
            }else cell.moneyLab.text = @"";
        }else{
            if (indexPath.row == 0) {
                selected = self.is_use_money;
                if (self.is_use_money) {
                    NSString *money = [NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),[JHUserModel shareJHUserModel].money];
                    NSString *str = [NSString stringWithFormat: NSLocalizedString(@"(抵扣%@)", NSStringFromClass([self class])),money];
                    cell.moneyLab.attributedText = [NSString getAttributeString:str dealStr:money strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"FF725C", 1.0)}];
                }else cell.moneyLab.attributedText = nil;
                
            }else{
                selected = self.selIndex == indexPath.row;
                if (selected) {
                    NSString *money = @"";
                    if (self.is_use_money) {
                        float amount = [self.amount floatValue] - [[JHUserModel shareJHUserModel].money floatValue];
                        money = [NSString stringWithFormat: NSLocalizedString(@"¥%g", NSStringFromClass([self class])),amount];
                    }else{
                       money = [NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),self.amount];
                    }
                    NSString *str = @"";
                    if (self.is_use_money) {
                        str = [NSString stringWithFormat: NSLocalizedString(@"(还需支付%@)", NSStringFromClass([self class])),money];
                    }else{
                        str = [NSString stringWithFormat: NSLocalizedString(@"(%@)", NSStringFromClass([self class])),money];
                    }
                    cell.moneyLab.text = str;
                }else cell.moneyLab.text = @"";
            }
        }
        
        [cell reloadCellWithDic:dic payMoney:self.amount is_selected:selected];
        
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [self dealChooesePayType:indexPath.row];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? CGFLOAT_MIN : 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
        view.backgroundColor = HEX(@"f5f5f5", 1.0);
        
        UILabel *lab = [UILabel new];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.offset(0);
            make.height.offset(20);
        }];
        lab.font = FONT(12);
        lab.textColor = HEX(@"666666", 1.0);
        lab.text =  NSLocalizedString(@"选择支付方式", NSStringFromClass([self class]));
        return view;
    }
    return nil;
}

#pragma mark ====== Functions =======
// 获取用户信息(主要余额)
-(void)getData{
    SHOW_HUD
    [JHWaimaiMineViewModel postToGetUserInfoWithBlock:^(NSString *error) {
        HIDE_HUD
//        [JHUserModel shareJHUserModel].money = @"0";
        
        BOOL enough = ([[JHUserModel shareJHUserModel].money floatValue] - [self.amount floatValue]) >= 0;
        if (enough) {
            self.selIndex = 0;
            self.pay_code = @"money";
            self.is_use_money = YES;
        }else{
            self.selIndex = 1;
            self.pay_code = @"alipay";
            self.is_use_money = [[JHUserModel shareJHUserModel].money floatValue] > 0;
        }
        [self.tableView reloadData];
        
    }];
}
// 点击去支付
-(void)clickToPay{
    NSLog(@"is_use_money %d code %@",self.is_use_money,self.pay_code);
    SHOW_HUD
    NSDictionary *dic = @{@"order_id":self.order_id,@"code":self.pay_code,@"use_money":@(self.is_use_money).stringValue};
    if ([self.pay_code isEqualToString:@"alipay"]) {
        [YFPayTool AlipayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else if ([self.pay_code isEqualToString:@"wxpay"]){
        [YFPayTool WXPayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else if ([self.pay_code isEqualToString:@"money"]){
        [YFPayTool moneyPayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else  if ([self.pay_code isEqualToString:@"stripe"]){
        [YFPayTool stripePayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else  if ([self.pay_code isEqualToString:@"friend"]){
        [YFPayTool friendPayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
           [self dealWithPayResult:success msg:errStr];
        }];
    }
}

// 处理支付结果
-(void)dealWithPayResult:(BOOL)success msg:(NSString *)msg{
    HIDE_HUD
    //    HIDE_HUD_FOR_VIEW([UIApplication sharedApplication].keyWindow);
    if (![self.pay_code isEqualToString:@"friend"]) {
        [self showToastAlertMessageWithTitle:msg];
        if (success) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                YF_SAFE_BLOCK(self.paySuccessBlock,success,nil);
                if (_isDetailVC) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self pushToNextVcWithVcName:@"JHWaimaiOrderDetailVC" params:@{@"FromPayVC":@(YES),@"order_id":self.order_id}];
                }
                
            });
        }
        
    }else{
        if (success) {
            // 好友代付
            if ([self.pay_code isEqualToString:@"friend"]) {
                [self pushToNextVcWithVcName:@"JHADWebVC" params:@{@"url":msg,@"is_frendPay_web":@(YES)}];
            }
        }else [self showToastAlertMessageWithTitle:msg];
    }
}

// 处理选择不同的支付方式的效果
-(void)dealChooesePayType:(NSInteger)row{
    
    BOOL enough = ([[JHUserModel shareJHUserModel].money floatValue] - [self.amount floatValue]) >= 0;
    
    if (enough) {// 余额充足
        self.is_use_money = row == 0;
        self.selIndex = row;
        self.pay_code = [self.dataSource[row] objectForKey:@"code"];
    }else{// 余额不足
        if (row == 0) {
            if ([[JHUserModel shareJHUserModel].money floatValue] > 0) {
               self.is_use_money = !self.is_use_money;
            }
        }else{
            self.selIndex = row;
            self.pay_code = [self.dataSource[row] objectForKey:@"code"];
        }
    }
    
    [self.tableView reloadData];
    
}

-(void)initData{
    NSMutableArray *arr = @[
                            @{@"title":NSLocalizedString(@"余额支付", nil),@"img":@"icon_moneyPay",@"code":@"money"},
                            @{@"title":NSLocalizedString(@"支付宝支付", nil),@"img":@"icon_aliPay",@"code":@"alipay"},
                            @{@"title":NSLocalizedString(@"微信支付", nil),@"img":@"icon_wechatPay",@"code":@"wxpay"}
                            ].mutableCopy;
    
    BOOL isHaveFriendPay = [JHConfigurationTool shareJHConfigurationTool].is_have_friendPay;
    
    if (isHaveFriendPay && _is_show_friendPay) {
        [arr addObject:@{@"title": NSLocalizedString(@"微信好友代付", NSStringFromClass([self class])),@"img":@"icon_wechatPayF",@"code":@"friend"}];
    }
    
    if (IsHaveBankCardPay) {
        [arr addObject:@{@"title":NSLocalizedString(@"信用卡支付", nil),@"img":@"payWay04",@"code":@"stripe"}];
    }
    self.dataSource = arr.copy;
}

@end
