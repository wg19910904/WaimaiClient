//
//  JHCreateOrderSheetView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHCreateOrderSheetView.h"
#import "CreateOrderSheetCellOne.h"
#import "CreateOrderSheetCellTwo.h"
#import "AppDelegate.h"
#import "NSString+Tool.h"
#import "CreateOrderChooseTimeView.h"
#import "UIControl+TimeInterVal.h"

@interface JHCreateOrderSheetView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,weak)UIControl *control;
@property(nonatomic,weak)UILabel *titleLab;

@property(nonatomic,assign)float cellHeight;
@property(nonatomic,assign)CGFloat tabH;
@property(nonatomic,assign)JHCreateOrderSheetViewType sheetType;


@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)CreateOrderChooseTimeView *timeTableView;

@property(nonatomic,copy)NSString *title;
@end

@implementation JHCreateOrderSheetView

-(JHCreateOrderSheetView *)initWithTitle:(NSString *)title amount:(NSString *)amount delegate:(id<JHCreateOrderSheetViewDelegate>)delegate sheetViewType:(JHCreateOrderSheetViewType)sheetType dataSource:(NSArray *)dataSource{

    self = [[JHCreateOrderSheetView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    self.delegate=delegate;
    
    UIControl *control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    control.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [control addTarget:self action:@selector(sheetHidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    self.control=control;
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [control addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.width.offset=WIDTH;
        make.height.offset=50;
    }];
    topView.backgroundColor = [UIColor whiteColor];
    
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

    self.sheetType = sheetType;
    
    self.dataSource=dataSource;
    
 #pragma mark =================

    if (sheetType == SheetViewChooseTime) {
        
        [control addSubview:self.timeTableView];
        self.timeTableView.leftArr = dataSource;
        self.timeTableView.height = self.tabH;
         __weak typeof(self) weakSelf=self;
        self.timeTableView.chooseBlock = ^(NSInteger left,NSInteger right,NSString *str){
            [weakSelf dealWithDelegateAction:str index:-1];
        };
        
        [topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.timeTableView.mas_top).offset=0;
        }];
        
    }else{
        
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT+50, WIDTH, self.tabH) style:UITableViewStyleGrouped];
        tableView.delegate=self;
        tableView.dataSource=self;
        [control addSubview:tableView];
        tableView.scrollEnabled=NO;
        tableView.backgroundColor=[UIColor whiteColor];
        tableView.showsVerticalScrollIndicator=NO;
        self.tableView=tableView;
        
        [topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tableView.mas_top).offset=0;
        }];
        
        tableView.height = self.tabH;
        [self.tableView reloadData];
        self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
    }
    
    if (dataSource.count > 6 ) {
        self.tableView.scrollEnabled = YES;
    }
    
    if (sheetType == SheetViewChoosePayType) {
        
        self.dataSource = @[@{@"title":NSLocalizedString(@"支付宝支付", @"JHCreateOrderSheetView"),@"icon":@"icon_aliPay"},
                            @{@"title":NSLocalizedString(@"微信支付", @"JHCreateOrderSheetView"),@"icon":@"icon_wechatPay"},
                            @{@"title":NSLocalizedString(@"余额支付", @"JHCreateOrderSheetView"),@"icon":@"icon_moneyPay"}];
    }
    
    if (sheetType == SheetViewChooseMoneyPayType) {
        self.dataSource = @[@{@"title":NSLocalizedString(@"支付宝支付", @"JHCreateOrderSheetView"),@"icon":@"icon_aliPay"},
                            @{@"title":NSLocalizedString(@"微信支付", @"JHCreateOrderSheetView"),@"icon":@"icon_wechatPay"}];
    }
    
    [self.control layoutIfNeeded];
    
    return self;
    
}

-(void)setAmount:(NSString *)amount{
    
    _amount = amount;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.title ];
    [attStr appendAttributedString:[NSString getAttributeString:[NSString stringWithFormat:@" %@%@",NSLocalizedString(@"¥", nil),amount] strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff6600", 1.0)}]];
     self.titleLab.attributedText = attStr;

}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    self.cellHeight = 50;
    switch (self.sheetType) {
        case SheetViewChooseNormal:
            self.tabH = dataSource.count > 6 ?  6 * self.cellHeight : self.cellHeight * dataSource.count;
            break;
        case SheetViewChoosePayWay:
            self.tabH = 100;
            break;
        case SheetViewChoosePayType:
            self.cellHeight = 60;
            self.tabH = 230;
            break;
        case SheetViewChooseMoneyPayType:
            self.cellHeight = 60;
            self.tabH = 170;
            break;
        case SheetViewChooseHongBao:
            self.tabH = dataSource.count  > 6 ?  6 * self.cellHeight : self.cellHeight * (dataSource.count + 1) ;
            break;
        case SheetViewChooseYouHui:
            self.tabH = dataSource.count > 6 ?  6 * self.cellHeight : self.cellHeight * (dataSource.count + 1) ;
            break;
        case SheetViewChooseTime:
        {
            CGFloat height1 = [dataSource[0][@"times"] count] > 6 ?  6 * self.cellHeight : self.cellHeight *[dataSource[0][@"times"] count];
            CGFloat height2 = dataSource.count > 6 ?  6 * self.cellHeight : self.cellHeight * dataSource.count;
            self.tabH = MAX(height1, height2);
        }
            break;
    }
    [self.control layoutIfNeeded];
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
    
    if (self.sheetType == SheetViewChooseHongBao || self.sheetType == SheetViewChooseYouHui) {
        return self.dataSource.count + 1;
    }
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sheetType == SheetViewChoosePayType || self.sheetType == SheetViewChooseMoneyPayType) {
        
        static NSString *ID=@"CreateOrderSheetCellTwo";
        CreateOrderSheetCellTwo *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[CreateOrderSheetCellTwo alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }

        [cell reloadCellWith:self.dataSource[indexPath.row]];
        
        return cell;
        
    }else{
        
        static NSString *ID=@"CreateOrderSheetCellOne";
        CreateOrderSheetCellOne *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[CreateOrderSheetCellOne alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        NSString *str = @"";
        BOOL hidden = NO;
        if (self.sheetType == SheetViewChoosePayWay ) {
            if (self.payWayType == 1 && indexPath.row == 1) {
                hidden = YES;
            }else if (self.payWayType == 2 && indexPath.row == 0){
                hidden = YES;
            }
            str = self.dataSource[indexPath.row];
        }else if (self.sheetType == SheetViewChooseHongBao){
            if (indexPath.row == self.dataSource.count) {
                str = NSLocalizedString(@"不使用红包", nil);
            }else{
                NSDictionary *dic = self.dataSource[indexPath.row];
                str = [NSString stringWithFormat:@"¥%@%@(%@%@%@)",dic[@"amount"],NSLocalizedString(@"红包", nil),NSLocalizedString(@"满", @"JHCreateOrderSheetView"),dic[@"min_amount"],NSLocalizedString(@"可用", nil)];
            }
        }else if (self.sheetType == SheetViewChooseYouHui){
            if (indexPath.row == self.dataSource.count) {
                str = NSLocalizedString(@"不使用优惠劵", nil);
            }else{
                NSDictionary *dic = self.dataSource[indexPath.row];
                str = [NSString stringWithFormat:@"¥%@%@(%@%@%@)",dic[@"coupon_amount"],NSLocalizedString(@"优惠劵", nil),NSLocalizedString(@"满", @"JHCreateOrderSheetView"),dic[@"order_amount"],NSLocalizedString(@"可用", nil)];
                
            }
            
        }else{
            str = self.dataSource[indexPath.row];
        }
        
        [cell reloadCellWith:str hidden_btn:hidden];
        
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.sheetType == SheetViewChoosePayType || self.sheetType == SheetViewChooseMoneyPayType) {
        return 50;
    }else{
        return CGFLOAT_MIN;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight == 0 ? 50 : self.cellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.sheetType == SheetViewChoosePayType || self.sheetType == SheetViewChooseMoneyPayType) {
        return self.footerView;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.lastIndexPath = indexPath;
    if (self.sheetType == SheetViewChooseHongBao || self.sheetType == SheetViewChooseYouHui) {
        [self dealWithDelegateAction:@"" index:indexPath.row];
    }else{
        NSString *str = self.dataSource[indexPath.row];
        [self dealWithDelegateAction:str index:indexPath.row];
    }
    if (self.sheetType == SheetViewChoosePayType || self.sheetType == SheetViewChooseMoneyPayType) {
        
    }else{
        [self sheetHidden];
    }
}

#pragma mark ====== Functions =======
-(void)setPayWayType:(int)payWayType{
    _payWayType = payWayType;
    if (payWayType == 2) {
        self.lastIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
}

-(void)setTitleStr:(NSString *)titleStr{
    self.titleLab.text = titleStr;
}

// 支付
-(void)goPay{
//    if (!self.canClickPay) {
//        return;
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureToPay)]) {
        [self.delegate sureToPay];
    }
}

-(void)sheetShow{

    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self.control];
   
    [UIView animateWithDuration:0.15 animations:^{
         self.control.alpha=1;
    }];
    
    if (self.sheetType == SheetViewChooseTime) {
        self.timeTableView.leftArr = self.dataSource;
        [self.timeTableView reloadView];
        [UIView animateWithDuration:0.25 animations:^{
            self.timeTableView.y = HEIGHT-self.tabH;
            [self.control layoutIfNeeded];
        }];
        
    }else{
        [self.tableView reloadData];
        
//        [self tableView:self.tableView didSelectRowAtIndexPath:self.lastIndexPath];
        [self.tableView selectRowAtIndexPath:self.lastIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.y=HEIGHT-self.tabH;
            [self.control layoutIfNeeded];
        }];
    }
    
    if (self.sheetType == SheetViewChooseHongBao) {
         [self.tableView selectRowAtIndexPath:[self getHongbaoIndexPath] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else if (self.sheetType == SheetViewChooseYouHui){
         [self.tableView selectRowAtIndexPath:[self getCouponIndexPath] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    self.didAppear = YES;
    
}

-(void)sheetHidden{
    
    self.didAppear = NO;
    if (self.sheetType == SheetViewChoosePayType || self.sheetType == SheetViewChooseMoneyPayType) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancleToPay)]) {
            [self.delegate cancleToPay];
        }
    }
    
    if (self.sheetType == SheetViewChooseTime) {
        [UIView animateWithDuration:0.25 animations:^{
            self.timeTableView.y=HEIGHT+50;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.y=HEIGHT+50;
        }];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.control.alpha=0;
    }];
    [self removeFromSuperview];
    
}

// 代理方法的处理
-(void)dealWithDelegateAction:(NSString *)str index:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sheetView:clickIndex:choosedValue:)]) {
        [self.delegate sheetView:self clickIndex:index choosedValue:str];
    }
}

-(NSIndexPath *)getHongbaoIndexPath{
    if ([self.hongbao_id isEqualToString:@"0"]) {
        return [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
    }
    for (NSDictionary *dic  in self.dataSource) {
        if ([dic[@"hongbao_id"] isEqualToString:self.hongbao_id]) {
            return [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:dic] inSection:0];
        }
    }
   return [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
}

-(NSIndexPath *)getCouponIndexPath{
    if ([self.coupon_id isEqualToString:@"0"]) {
        return [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
    }
    for (NSDictionary *dic  in self.dataSource) {
        if ([dic[@"coupon_id"] isEqualToString:self.coupon_id]) {
            return [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:dic] inSection:0];
        }
    }
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

#pragma mark ====== 懒加载=======
-(UIView *)footerView{
    if (_footerView==nil) {

        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 50)];
        view.backgroundColor = BACK_COLOR;
        
        UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 5)];
        [view addSubview:backView];
        backView.backgroundColor = BACK_COLOR;
        
        UIButton *payBtn = [[UIButton alloc] initWithFrame:FRAME(10, 5, WIDTH-20, 40)];
        [view addSubview:payBtn];
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

-(CreateOrderChooseTimeView *)timeTableView{
    if (_timeTableView==nil) {
        _timeTableView=[[CreateOrderChooseTimeView alloc] initWithFrame:FRAME(0, HEIGHT+50, WIDTH, 0)];
    }
    return _timeTableView;
}

@end
