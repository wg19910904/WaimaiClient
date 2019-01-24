//
//  JHWaimaiRechargeVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiRechargeVC.h"
#import "JHWaimaiOrderPayHeaderCell.h"
#import "JHWaimaiOrderPayTypeCell.h"
#import "JHWaimaiOrderPayBtnCell.h"
#import "JHWMPayOrderMoneyCell.h"
#import "YFPayTool.h"
#import "JHWaimaiMineViewModel.h"
#import "JHWaimaiRechargeMoneyModel.h"
#import "YFTextField.h"
#import "JHWaimaiRechargeMoneyCell.h"

@interface JHWaimaiRechargeVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>{
    JHWaimaiRechargeMoneyModel *selectorModel;
}
@property(nonatomic,copy)NSString * code;
@property(nonatomic,strong)UICollectionView *myCollectionView;
@property(nonatomic,strong)NSMutableArray *infoArr;
@property(nonatomic,weak)YFTextField *monyeField;
@property(nonatomic,assign)NSInteger selIndex;
@property(nonatomic,strong)UITableView *tableView;//表视图
@property(nonatomic,strong)NSArray *dataSource;

@end
@implementation JHWaimaiRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self tableView];
    [self loadData];
    
}

// 初始化一些数据的方法
-(void)initData{
    _code = @"alipay";
    self.selIndex = 0;
    self.navigationItem.title = NSLocalizedString(@"支付页面", nil);
    NSMutableArray *arr = @[
                            @{@"title":NSLocalizedString(@"余额支付", nil),@"img":@"icon_moneyPay",@"code":@"money"},
                            @{@"title":NSLocalizedString(@"支付宝支付", nil),@"img":@"icon_aliPay",@"code":@"alipay"},
                            @{@"title":NSLocalizedString(@"微信支付", nil),@"img":@"icon_wechatPay",@"code":@"wxpay"}
                            ].mutableCopy;
    if (IsHaveBankCardPay) {
        [arr addObject:@{@"title":NSLocalizedString(@"信用卡支付", nil),@"img":@"payWay04",@"code":@"stripe"}];
    }
    self.dataSource = arr.copy;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return 1;
    }
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = BACK_COLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *str = @"JHWaimaiOrderPayHeaderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            [cell.contentView addSubview:self.myCollectionView];
            [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.offset(0);
            }];
        }
      
        return cell;
        
    }else if (indexPath.section == 2){
        static NSString *str = @"JHWaimaiOrderPayBtnCell";
        JHWaimaiOrderPayBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderPayBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof (self)weakSelf = self;
        [cell setMyBlock:^{
            [weakSelf clickPay];
        }];
        return cell;
    }
    else{
       
        static NSString *str = @"JHWaimaiOrderPayTypeCell";
        JHWaimaiOrderPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderPayTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.isHid = indexPath.row == self.dataSource.count - 1;
        
        NSDictionary *dic = self.dataSource[indexPath.row];
        cell.typeImg = dic[@"img"];
        cell.title   = dic[@"title"];
        if (indexPath.row == _selIndex) {
            cell.rightImg = @"btn_dx_checked" ;
        }else{
            cell.rightImg = @"btn_dx";
        }

        return cell;

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? self.myCollectionView.collectionViewLayout.collectionViewContentSize.height : 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSDictionary *dic = self.dataSource[indexPath.row];
        self.selIndex = indexPath.row;
        _code = dic[@"code"];
        [self.tableView reloadData];
    }
    
}

#pragma mark ====== Functions =======

// 这是点击支付的方法
-(void)clickPay{
    int a = -1;
    for (int i = 0; i < _infoArr.count; i++) {
        JHWaimaiRechargeMoneyModel * model = _infoArr[i];
        if (model.isSelector) {
            a = i;
        }
    }
    if (a < 0 && [self.monyeField.text intValue]<= 0) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先选择充值的金额!", nil)];
        return;
    }
    
    NSString *amount = @"0";
    if ([self.monyeField.text intValue]<= 0) {
        amount = selectorModel.chong;
    }else{
        amount = self.monyeField.text;
    }
    
    SHOW_HUD
    NSDictionary *dic = @{@"code":self.code,@"amount":amount};
    if ([self.code isEqualToString:@"alipay"]) {
        [YFPayTool AlipayApi:@"client/payment/money" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else if ([self.code isEqualToString:@"wxpay"]){
        [YFPayTool WXPayApi:@"client/payment/money" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else  if ([self.code isEqualToString:@"stripe"]){
        [YFPayTool stripePayApi:@"client/payment/money" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }
}

// 处理支付结果
-(void)dealWithPayResult:(BOOL)success msg:(NSString *)msg{
    HIDE_HUD
    //    HIDE_HUD_FOR_VIEW([UIApplication sharedApplication].keyWindow);
    [self showToastAlertMessageWithTitle:msg];
    if (success) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

#pragma mark - 获取数据的方法
-(void)loadData{
    SHOW_HUD
    [JHWaimaiMineViewModel postToGetRechargeInfo:^(NSArray *arr, NSString *error) {
        HIDE_HUD
        if (error) {
            [self showToastAlertMessageWithTitle:error];
        }else{
            for (int i = 0; i < arr.count; i++) {
                JHWaimaiRechargeMoneyModel * model = [[JHWaimaiRechargeMoneyModel alloc]init];
                NSDictionary *dic = arr[i];
                model.chong = dic[@"chong"];
                model.song = dic[@"song"];
                model.title = dic[@"title"];
                [self.infoArr addObject:model];
            }
            
            JHWaimaiRechargeMoneyModel * model = [[JHWaimaiRechargeMoneyModel alloc]init];
            model.chong =  NSLocalizedString(@"自定义", NSStringFromClass([self class]));
            [self.infoArr addObject:model];
            [_myCollectionView reloadData];
            [self.tableView reloadData];
        }
    }];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _infoArr.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH - 45)/2, (WIDTH - 45)/4);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if ([selectorModel.chong intValue] > 0 || !selectorModel) return CGSizeZero;
    return CGSizeMake(WIDTH, 60);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 60);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        view.backgroundColor = BACK_COLOR;
        
        YFTextField *field = [[YFTextField alloc] initWithFrame:FRAME(0, 0, WIDTH, 40) leftView:[UIView new]];
        [view addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.offset= 0;
            make.top.offset=10;
            make.height.offset=50;
        }];
        field.letfMargin = 10;
        field.delegate = self;
        field.backgroundColor = [UIColor whiteColor];
        field.font = FONT(16);
        field.placeholdeFont = FONT(16);
        field.textColor = HEX(@"333333", 1.0);
        field.placeholdeColor =HEX(@"cccccc", 1.0);
        field.placeholder =  NSLocalizedString(@"请输入自定义充值金额（不小于1元)", NSStringFromClass([self class]));
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.returnKeyType = UIReturnKeyDone;
        self.monyeField = field;
        
        return view;
    }else{
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        UIView *lab = [view viewWithTag:100];
        [lab removeFromSuperview];
        UILabel *label = [[UILabel alloc]init];
        label.tag = 100;
        label.textColor = HEX(@"333333", 1);
        label.text = NSLocalizedString(@"选择充值面额", nil);
        label.font = FONT(14);
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view.mas_centerX);
            make.height.offset = 20;
            make.top.offset = 20;
        }];
        view.backgroundColor = BACK_COLOR;
        return view;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHWaimaiRechargeMoneyCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    JHWaimaiRechargeMoneyModel *model = _infoArr[indexPath.item];
    cell.model = model;
    __weak typeof (self)weakSelf = self;
    [cell setMyBlock:^{
        [weakSelf choseBtn:indexPath];
    }];
    return cell;
}

#pragma mark - 选择调用的方法
-(void)choseBtn:(NSIndexPath *)indexP{
    for (int i = 0; i < _infoArr.count; i++) {
        JHWaimaiRechargeMoneyModel * model = _infoArr[i];
        model.isSelector = NO;
        if (i == indexP.item) {
            model.isSelector = YES;
        }
    }
    if (selectorModel ==  _infoArr[indexP.item]) {
        return;
    }
    self.monyeField.text = @"";
    selectorModel = _infoArr[indexP.item];
    
    [_myCollectionView reloadData];
    [self.tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark ====== 懒加载 =======
-(NSMutableArray *)infoArr{
    if (!_infoArr) {
        _infoArr = @[].mutableCopy;
    }
    return _infoArr;
}


-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
            table.rowHeight = UITableViewAutomaticDimension;
            table.estimatedRowHeight= 100;
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = BACK_COLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            table;
            
        });
    }
    return _tableView;
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 15;
        _myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH,HEIGHT - NAVI_HEIGHT - 74) collectionViewLayout:layout];
        [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        [_myCollectionView registerClass:[JHWaimaiRechargeMoneyCell class] forCellWithReuseIdentifier:@"cell"];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = BACK_COLOR;
        _myCollectionView.alwaysBounceVertical = YES;
        [self.view addSubview:_myCollectionView];

        
    }
    return _myCollectionView;
}

@end

