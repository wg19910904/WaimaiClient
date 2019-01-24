//
//  JHPaySheetVC.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/26.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHPaySheetVC.h"
#import "YFPayTypeCell.h"
#import "YFPayTool.h"
#import "JHWaimaiMineViewModel.h"
#import "MineBankModel.h"
#import "NSString+Tool.h"
#import "PresentAnimationTransition.h"

@interface JHPaySheetVC ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>
@property(nonatomic,strong)UITableView *tableView;//表视图
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,copy)NSString *pay_code;// money 只用余额支付
@property(nonatomic,assign)NSInteger selIndex;
@property(nonatomic,assign)BOOL is_use_money;//使用余额（包含余额不足不包含0）
@property(nonatomic,strong)MineBankModel *bankModel;
@end

@implementation JHPaySheetVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setUpView];
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}

-(void)setUpView{
    
    self.navigationItem.title = NSLocalizedString(@"支付页面", nil);
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - 70) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(360);
    }];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self setUpBottomView];

}

-(void)setUpBottomView{
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(60);
    }];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:FRAME(10, 10, WIDTH-20, 40)];
    [bottomView addSubview:payBtn];
    payBtn.layer.cornerRadius=4;
    payBtn.clipsToBounds=YES;
    payBtn.backgroundColor = HEX(@"FF725C", 1.0);
    payBtn.titleLabel.font = FONT(16);
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitle:NSLocalizedString(@"立即支付",nil) forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(clickToPay) forControlEvents:UIControlEventTouchUpInside];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dealChooesePayType:indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  48;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 48)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *closeBtn = [UIButton new];
        [view addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.offset(0);
            make.width.offset(40);
            make.height.offset(40);
        }];
        [closeBtn setImage:IMAGE(@"icon_close") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickCancelPay) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lab = [UILabel new];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.offset(0);
            make.height.offset(20);
        }];
        lab.font = FONT(18);
        lab.textColor = HEX(@"FF725C", 1.0);
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"应支付金额¥%@", NSStringFromClass([self class])),self.amount];
        lab.attributedText = [NSString getAttributeString:str dealStr: NSLocalizedString(@"应支付金额", NSStringFromClass([self class])) strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"333333", 1.0)}];
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
    if (success) {
        if (![self.pay_code isEqualToString:@"friend"]) {
            [self showToastAlertMessageWithTitle:msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
                YF_SAFE_BLOCK(self.paySuccessBlock,success,nil);
            });
        }else{
            // 好友代付
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.superVC pushToNextVcWithVcName:@"JHADWebVC" params:@{@"url":msg,@"is_frendPay_web":@(YES)}];
        }

    }else [self showToastAlertMessageWithTitle:msg];
}

// 取消支付
-(void)clickCancelPay{
    
    [self showToastAlertMessageWithTitle: NSLocalizedString(@"取消支付", NSStringFromClass([self class]))];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YF_SAFE_BLOCK(self.paySuccessBlock,NO,nil);
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
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
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset( 60 * (self.dataSource.count + 2));
    }];
    
    [self.tableView reloadData];
}

#pragma mark ====== PresentAnimationTransition =======
-(instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor clearColor];
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
    
    return  [[PresentAnimationTransition alloc] initWithTransitionType:YFPresentTransitionTypePresentWithAnimation];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return  [[PresentAnimationTransition alloc] initWithTransitionType:YFPresentTransitionTypeDismissWithAnimation];
    
}

#pragma mark ======拦截点击事件=======
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point =  [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(self.tableView.frame, point)) {
        return;
    }
    [self clickCancelPay];
}

@end
