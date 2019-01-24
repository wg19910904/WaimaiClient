//
//  JHWaimaiOrderDetailVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailVC.h"
#import "JHShowAlert.h"
#import "JHWaimaiOrderDetailHeaderCell.h"
#import "JHWaiMaiOrderDetailMapCell.h"
#import "JHWaimaiOrderDetailMenuCell.h"
#import "JHWaimaiOrderDetailDefaultCell.h"
#import "JHWaimaiOrderDetailYouhuiCell.h"
#import "JHWaimaiOrderDetailFooterView.h"
#import "JHWaimaiOrderDetailAddressCell.h"
#import "JHADWebVC.h"
#import "ZQShareView.h"
#import "JHWaimaiOrderDetailComplaintVC.h"
#import <IQKeyboardManager.h>
#import "JHWaimaiOrderDetailCustomeServiseVC.h"
#import "JHWaimaiOrderBackMoneyVC.h"
#import "JHWaimaiOrderDetailZitimaView.h"
#import "JHPayVC.h"
#import "JHWaimaiOrderDetailEvaluateVC.h"
#import "JHWaimaiOrderDetailSeeEvaluationVC.h"
#import "JHWaiMaiOrderViewModel.h"
#import "JHWaiMaiShopDetailVC.h"

#import "JHWaiMaiOrderDetailRedBagView.h"
#import "JHWaimaiDetailPlaytourCell.h"
#import "JHWMOrderDetailProductBasketCell.h"
#import "JHWMOrderDetailProductCell.h"

@interface JHWaimaiOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,JHOrderStatusActionProtocol>

@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,strong)UIButton *phoneBtn;//打电话的按钮
@property(nonatomic,strong)UIButton *complaintBtn;//投诉的按钮
@property(nonatomic,strong)UIButton *zitiBtn;//展示自提码的按钮
@property(nonatomic,strong)UIButton *redBagBtn;//红包的按钮
@property(nonatomic,strong)UITableView *myTableView;//表视图
@property(nonatomic,strong)NSMutableArray *sec2Arr;//第二个区的信息
@property(nonatomic,strong)NSMutableArray *sec3Arr;//第三个分区的信息
@property(nonatomic,strong)JHWaimaiOrderDetailZitimaView *zitiCodeView;//展示自提单的二维码的View
@property(nonatomic,strong)JHWaimaiOrderDetailModel *detailModel;//详情的数据模型
@property(nonatomic,strong)ZQShareView *shareView;//分享的view
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,strong)JHWaiMaiOrderDetailRedBagView *redBagView;//红包
@end

@implementation JHWaimaiOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //展示的表
    [self myTableView];
    //投诉的按钮
    [self complaintBtn];
    //打电话的按钮
    [self phoneBtn];
    //红包的按钮
    [self redBagBtn];
    //展示自提码的按钮
    [self zitiBtn];
}
-(JHWaiMaiOrderDetailRedBagView *)redBagView{
    if (!_redBagView) {
        _redBagView = [[JHWaiMaiOrderDetailRedBagView alloc]init];
        __weak typeof (self)weakSelf = self;
        [_redBagView setClickBlock:^{
             [weakSelf.shareView showAnimation];
        }];
    }
    return _redBagView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
    [IQKeyboardManager sharedManager].enable = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [IQKeyboardManager sharedManager].enable = YES;
}
-(void)clickBackBtn{
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
   if(self.tabBarController.selectedIndex == 2 || self.tabBarController.selectedIndex == 3 || self.tabBarController.selectedIndex == 1){
        JHBaseVC * vc = self.navigationController.viewControllers[1];
        if (self.FromPayVC || [vc isKindOfClass:[JHWaiMaiShopDetailVC class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES]; 
        }
    }else{
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)getData{
    if (!_detailModel) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr:NSLocalizedString(@"正在刷新数据中...", nil) btnTitle:nil inView:self.view];
    }
    SHOW_HUD
    [JHWaiMaiOrderViewModel postToGetOrderDetailInfoWithDic:@{@"order_id":self.order_id} block:^(JHWaimaiOrderDetailModel *model, NSString *err) {
        HIDE_HUD
        if (err) {
            [self showToastAlertMessageWithTitle:err];
        }else{
            self.detailModel = model;
            
            [self makeData];
            [self.myTableView reloadData];
            [self hiddenEmptyView];
            if (self.FromPayVC && model.pay_status.integerValue == 1 && !_redBagView) {
                [self showHongBao:self.detailModel.hongbao_num];
            }
        }
        [self.myTableView endRefresh];
    }];
}
-(void)showHongBao:(NSString *)count{
    if (count.integerValue == 0) {
        return;
    }
    self.redBagView.titleL = [NSString stringWithFormat:NSLocalizedString(@"恭喜您获得%@个红包",nil),count];
    self.redBagView.alertTitle = NSLocalizedString(@"分享红包给好友\n可用于抵扣在线支付金额",nil);
    [self.redBagView showView];
}
-(void)startTimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(getData) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 处理数据刷新后的一些数据处理
-(void)makeData{
   
    //配送中
    if ([_detailModel.order_status integerValue] == 3 ||([_detailModel.order_status integerValue] == 2 && [_detailModel.staff_id integerValue] > 0)) {
        self.status = 3;
        if ([_detailModel.pei_type isEqualToString:NSLocalizedString(@"平台送", nil)]) {
            if (!self.navigationController) {// 控制器消失了，释放timer
                [self stopTimer];
            }else{
                [self startTimer];
            }
        }
    }else{//其他情况不做处理
        self.status = 0;
        [self stopTimer];
    }
    _sec3Arr = @[NSLocalizedString(@"订单信息", nil),
                 [NSLocalizedString(@"订单号:", nil) stringByAppendingString:_detailModel.order_id],
                 [NSLocalizedString(@"支付方式:", nil) stringByAppendingString:_detailModel.payment_type],
                 [NSLocalizedString(@"下单时间:", nil) stringByAppendingString:_detailModel.dateline],
                 [NSLocalizedString(@"订单备注:", nil) stringByAppendingString:_detailModel.intro.length == 0?NSLocalizedString(@"无", nil) :_detailModel.intro]].mutableCopy;
    _sec2Arr = @[NSLocalizedString(@"配送信息", nil),
                 [NSLocalizedString(@"送达时间:", nil) stringByAppendingString:_detailModel.pei_time],
                 [NSString stringWithFormat:@"%@\n%@\n%@\n%@",_detailModel.contact,_detailModel.mobile,_detailModel.addr,_detailModel.house],
                 [NSLocalizedString(@"配送方式:", nil) stringByAppendingString:_detailModel.pei_type],
                 [NSString stringWithFormat:NSLocalizedString(@"配送人员: %@ %@", nil),_detailModel.staff[@"name"],_detailModel.staff[@"mobile"]]].mutableCopy;
    if ([_detailModel.order_status integerValue] > 0 || ([_detailModel.order_status integerValue] == 0 && [_detailModel.pay_status integerValue] == 1)) {
        _redBagBtn.hidden = NO;
        _redBagBtn.hidden = [_detailModel.hongbao_num isEqualToString:@"0"];
        [_redBagBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 44;
        }];
    }else{
        _redBagBtn.hidden = YES;
        [_redBagBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0.01;
        }];
    }
    if ([_detailModel.online_pay integerValue] == 0) {
        _redBagBtn.hidden = YES;
        [_redBagBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0.01;
        }];
    }
    
    if ([_detailModel.online_pay integerValue] == 0 && [_detailModel.order_status integerValue] < 4) {
        [_redBagBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0.01;
        }];
    }
    if ([_detailModel.order_status integerValue] == 0) {
        _complaintBtn.hidden = YES;
    }else{
        _complaintBtn.hidden = NO;
    }
    if (_detailModel.spend_number.length == 0 || [_detailModel.pay_status integerValue] == 0 || ([_detailModel.order_status integerValue] == 0 && [_detailModel.pay_status integerValue] == 1)||[_detailModel.order_status integerValue] < 0) {
        _zitiBtn.hidden = YES;
    }else{
        _zitiBtn.hidden = NO;
    }
    if ([_detailModel.order_status integerValue] > 0 && [_detailModel.online_pay integerValue] == 0 && _detailModel.spend_number.length > 0) {
        _zitiBtn.hidden = NO;
    }
 
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"订单详情", nil);
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.rowHeight = UITableViewAutomaticDimension;
            table.estimatedRowHeight = 100;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = BACK_COLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];

            __weak typeof(self) weakSelf=self;
            //--下拉加载
            [table bindHeadRefreshHandler:^{
                [weakSelf downRefresh];
            }];
            table;
        });
    }
    return _myTableView;
}
#pragma mark - 这是下拉刷新
-(void)downRefresh{
    [self getData];
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if (![_detailModel.pei_type isEqualToString:NSLocalizedString(@"平台送", nil)]) {
                return 1;
            }
            if (_status != 3) {
                return 1;
            }
            return 2;
        }
        case 1:{
            if ([_detailModel.staff_id integerValue] > 0) {
                return 1;
            }
            return 0;
        }
        case 2:
        {
            NSDictionary *dic = [self.detailModel.products firstObject];
            NSInteger productCellCount = self.detailModel.products.count == 1 ? [dic[@"product"] count] : self.detailModel.products.count;
            if (_detailModel.youhui.count == 0) {
                return 3 + productCellCount;
            }else{
                return 4 + productCellCount;
            }
            
        }
        case 3:
        {
            if ([_detailModel.pei_type isEqualToString:NSLocalizedString(@"自提", nil)]) {
                return 2;
            }
            if ([_detailModel.staff_id integerValue] > 0) {
                return 5;
            }
            else{
                return 4;
            }
        }
        
        default:
        {
            return 5;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!_detailModel) return 0;
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ( section == 4 || section == 3 || (section == 2 && [_detailModel.staff_id integerValue] > 0)) {
        return 10;
    }
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3 || section == 4|| (section == 2 && [_detailModel.staff_id integerValue] > 0)) {
        UIView *view = [UIView new];
        view.backgroundColor = BACK_COLOR;
        return view;
    }
    return nil;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else if (section == 2){
        return 40;
    }
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [UIView new];
        view.backgroundColor = BACK_COLOR;
        return view;
    }else if (section == 2){
        static NSString *str = @"JHWaimaiOrderDetailFooterView";
        JHWaimaiOrderDetailFooterView * footerView = [[JHWaimaiOrderDetailFooterView alloc]initWithReuseIdentifier:str];
        footerView.model = _detailModel;
        return footerView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     __weak typeof(self) weakSelf=self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *str = @"JHWaimaiOrderDetailHeaderCell";
            JHWaimaiOrderDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHWaimaiOrderDetailHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            cell.delegate = self;
            cell.model = _detailModel;
            cell.showOrderScheduleBlock = ^(BOOL success, NSString *msg) {
                JHADWebVC *vc = [JHADWebVC new];
                vc.url = weakSelf.detailModel.link;
                vc.titleStr =  NSLocalizedString(@"订单进度", NSStringFromClass([self class]));
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;

        }else{
            static NSString *str = @"JHWaiMaiOrderDetailMapCell";
            JHWaiMaiOrderDetailMapCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHWaiMaiOrderDetailMapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            cell.superVC = self;
            [cell reloadCellWithModel:self.detailModel];
            return cell;
        }
    }else if(indexPath.section == 1){
        static NSString *str = @"JHWaimaiDetailPlaytourCell";
        JHWaimaiDetailPlaytourCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiDetailPlaytourCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.superVC = self;
        cell.model = _detailModel;
        return cell;
        
    }
    else if(indexPath.section == 2){
        NSDictionary *dic = [self.detailModel.products firstObject];
        NSInteger productCellCount = self.detailModel.products.count == 1 ? [dic[@"product"] count] : self.detailModel.products.count;
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            UIView *lineView=[UIView new];
            [cell.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=0;
                make.bottom.offset=-0.5;
                make.right.offset=0;
                make.height.offset=0.5;
            }];
            lineView.backgroundColor=LINE_COLOR;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = IMAGE(@"icon-shop");
            cell.textLabel.textColor = HEX(@"222222", 1);
            cell.textLabel.text = _detailModel.waimai[@"title"];
            cell.textLabel.font = FONT(14);
            return cell;
        }else if (indexPath.row <= productCellCount){
            if (self.detailModel.products.count == 1) { // 单人订餐
                JHWMOrderDetailProductCell *cell = [JHWMOrderDetailProductCell initWithTableView:tableView reuseIdentifier:@"JHWMOrderDetailProductCell"];
                NSDictionary *goodDic = dic[@"product"][indexPath.row - 1];
                [cell reloadCellWithModel:goodDic];
                return cell;
            }else{// 多人订餐
                JHWMOrderDetailProductBasketCell *cell = [JHWMOrderDetailProductBasketCell initWithTableView:tableView reuseIdentifier:@"JHWMOrderDetailProductBasketCell"];
                NSDictionary *subDic = self.detailModel.products[indexPath.row-1];
                [cell reloadCellWithModel:subDic];
                return cell;
            }

        }else if (indexPath.row == productCellCount + 1 || indexPath.row == productCellCount + 2){
            static NSString *str = @"JHWaimaiOrderDetailDefaultCell";
            JHWaimaiOrderDetailDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHWaimaiOrderDetailDefaultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
                UIView *lineView=[UIView new];
                [cell.contentView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset=0;
                    make.top.offset=0;
                    make.right.offset=0;
                    make.height.offset=0.5;
                }];
                lineView.backgroundColor=LINE_COLOR;
            }
            cell.leftTitle = indexPath.row == productCellCount + 1 ?NSLocalizedString(@"配送费", nil):NSLocalizedString(@"餐盒打包费", nil);
            NSString *rightStr = indexPath.row == productCellCount + 1 ?_detailModel.freight:_detailModel.package_price;
            cell.rightTitle = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥", NSStringFromClass([self class])),rightStr];
            return cell;
        }else{
            static NSString *str = @"JHWaimaiOrderDetailYouhuiCell";
            JHWaimaiOrderDetailYouhuiCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHWaimaiOrderDetailYouhuiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            cell.arr = _detailModel.youhui;
            return cell;
        }
    }else if(indexPath.section == 3){
        if (indexPath.row != 2) {
            static NSString *str = @"PeiCell";
            JHWaimaiOrderDetailDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHWaimaiOrderDetailDefaultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            if (indexPath.row == 0) {
                cell.leftLabel.font = FONT(14);
                cell.leftLabel.textColor = HEX(@"333333", 1);
            }else{
                cell.leftLabel.font = FONT(12);
                cell.leftLabel.textColor = HEX(@"666666", 1);
            }
            cell.leftTitle = _sec2Arr[indexPath.row];
            return cell;
        }else{
            static NSString *str = @"JHWaimaiOrderDetailAddressCell";
            JHWaimaiOrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHWaimaiOrderDetailAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            cell.addressTitle = _sec2Arr[indexPath.row];
            
            return cell;
 
        }
       
    }else{
        static NSString *str = @"DetailCell";
        JHWaimaiOrderDetailDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderDetailDefaultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        if (indexPath.row == 0) {
            cell.leftLabel.font = FONT(14);
            cell.leftLabel.textColor = HEX(@"333333", 1);
        }else{
            cell.leftLabel.font = FONT(12);
            cell.leftLabel.textColor = HEX(@"666666", 1);
        }
        cell.leftTitle = _sec3Arr[indexPath.row];
        return cell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0) {
        JHWaiMaiShopDetailVC *vc = [[JHWaiMaiShopDetailVC alloc]init];
        vc.shop_id = _detailModel.waimai[@"shop_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 打电话的按钮
-(UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [[UIButton alloc]init];
        [_phoneBtn setBackgroundImage:IMAGE(@"btn_fr_order") forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(clickToCall) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_phoneBtn];
        [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.width.height.offset = 44;
            make.bottom.mas_equalTo(_complaintBtn.mas_top).offset = -10;
        }];
    }
    return _phoneBtn;
}
#pragma mark - 打电话的方法
-(void)clickToCall{
    NSArray *titleArr;
    NSArray *phoneArr;
    if ([_detailModel.staff_id integerValue] > 0) {
        titleArr = @[NSLocalizedString(@"联系商家", nil),
                     NSLocalizedString(@"联系骑手", nil),
                     NSLocalizedString(@"联系客服", nil),
                     ];
        phoneArr = @[_detailModel.waimai[@"phone"],_detailModel.staff[@"mobile"],_detailModel.kefu_phone];
    }else{
        titleArr = @[NSLocalizedString(@"联系商家", nil),
                     NSLocalizedString(@"联系客服", nil)];
        phoneArr = @[_detailModel.waimai[@"phone"],_detailModel.kefu_phone];
    }
    [JHShowAlert showSheetAlertWithTextArr:titleArr withController:self withClickBlock:^(NSInteger tag) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneArr[tag]]]];
    }];
}
#pragma mark - 投诉的按钮
-(UIButton *)complaintBtn{
    if (!_complaintBtn) {
        _complaintBtn = [[UIButton alloc]init];
        [_complaintBtn setBackgroundImage:IMAGE(@"btn_fr_complain") forState:UIControlStateNormal];
        [_complaintBtn addTarget:self action:@selector(clickToComplaint) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_complaintBtn];
        [_complaintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.bottom.offset = -25;
            make.width.height.offset = 44;
        }];
    }
    return _complaintBtn;
}
#pragma mark - 点击去投诉的方法
-(void)clickToComplaint{
    NSLog(@"点击了去投诉");
//    if ([_detailModel.complaint integerValue] == 1) {
//        [self showToastAlertMessageWithTitle:NSLocalizedString(@"您已投诉过该商家", nil)];
//        return;
//    }
//    if ([_detailModel.pay_status integerValue] == 0&&[_detailModel.online_pay integerValue] != 0) {
//        [self showToastAlertMessageWithTitle:NSLocalizedString(@"您还不能对该商家进行投诉!", nil)];
//        return;
//    }
    if ([_detailModel.staff_id integerValue] > 0) {
        [JHShowAlert showSheetAlertWithTextArr:@[NSLocalizedString(@"投诉配送员",nil),NSLocalizedString(@"投诉商家",nil)] withController:self withClickBlock:^(NSInteger tag) {
            [self jumpTouSu:tag];
        }];
    }else{
        [self jumpTouSu:1];
    }
   
    
}
-(void)jumpTouSu:(NSInteger)tag{
    JHWaimaiOrderDetailComplaintVC *vc = [[JHWaimaiOrderDetailComplaintVC alloc]init];
    if (tag == 0) {
        vc.staff_id = _detailModel.staff_id;
    }else{
        vc.shop_id = _detailModel.waimai[@"shop_id"];
    }
    vc.order_id = _detailModel.order_id;
    vc.mobile = _detailModel.waimai[@"phone"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击发送红包的按钮
-(UIButton *)redBagBtn{
    if (!_redBagBtn) {
        _redBagBtn = [[UIButton alloc]init];
        [_redBagBtn setBackgroundImage:IMAGE(@"btn_fr_redbag") forState:UIControlStateNormal];
        [_redBagBtn addTarget:self action:@selector(clickToSendRedBag) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_redBagBtn];
        [_redBagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.bottom.mas_equalTo(_phoneBtn.mas_top).offset = -10;
            make.width.height.offset = 44;
        }];
    }
    return _redBagBtn;
}
#pragma mark - 点击发送红包的方法
-(void)clickToSendRedBag{
    NSLog(@"点击发送红包");
    [self.shareView showAnimation];
}
-(ZQShareView *)shareView{
    if (!_shareView) {
        _shareView = [[ZQShareView alloc]init];
        _shareView.isUrlImg = YES;
        _shareView.superVC = self;
        _shareView.shareStr = _detailModel.hongbao[@"desc"];
        _shareView.shareUrl = _detailModel.hongbao[@"link"];
        _shareView.shareTitle = _detailModel.hongbao[@"title"];
        _shareView.shareImgName = _detailModel.hongbao[@"imgUrl"];
        
    }
    return _shareView;
}
#pragma mark - 点击展示自提码的按钮
-(UIButton *)zitiBtn{
    if (!_zitiBtn) {
        _zitiBtn = [[UIButton alloc]init];
        [_zitiBtn setBackgroundImage:IMAGE(@"btn_fr_ma") forState:UIControlStateNormal];
        [_zitiBtn addTarget:self action:@selector(clickToShowZitiMa) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_zitiBtn];
        [_zitiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.bottom.mas_equalTo(_redBagBtn.mas_top).offset = -10;
            make.width.height.offset = 44;
        }];
    }
    return _zitiBtn;

}
#pragma mark - 点击展示自提码的方法
-(void)clickToShowZitiMa{
    NSLog(@"点击展示自提码的二维码");
    _zitiCodeView = [[JHWaimaiOrderDetailZitimaView alloc]init];
    _zitiCodeView.code = _detailModel.spend_number;
    _zitiCodeView.ziti_status = [_detailModel.spend_status integerValue];
    [_zitiCodeView showView];
}

#pragma mark ====== JHOrderStatusActionProtocol =======
// 取消订单  is_timer 是否是倒计时
-(void)cancleOrderWithOrder_id:(NSString *)order_id is_timer:(BOOL)is_timer{
    if (is_timer) {
        [JHWaiMaiOrderViewModel postToCancelOrderWithDic:@{@"order_id":_detailModel.order_id} block:^(NSString *err) {
            [self getData];
        }];
    }else{
        [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"确定取消订单吗?", nil) withBtn_cancel:NSLocalizedString(@"取消", nil)withBtn_sure:NSLocalizedString(@"确定", nil) withController:self withCancelBlock:nil withSureBlock:^{
            SHOW_HUD
            [JHWaiMaiOrderViewModel postToCancelOrderWithDic:@{@"order_id":_detailModel.order_id} block:^(NSString *err) {
                if (err) {
                    [self showToastAlertMessageWithTitle:err];
                }else{
                    HIDE_HUD
                    [self getData];
                }
            }];
            
        }];

    }
}
// 去支付
-(void)payOrderWithOrder_id:(NSString *)order_id amount:(NSString *)amount dateline:(NSInteger)dateline{
    JHPayVC *vc = [[JHPayVC alloc]init];
    vc.isDetailVC = YES;
    vc.is_show_friendPay = YES;
    vc.dateline = dateline;
    vc.order_id = _detailModel.order_id;
    vc.amount = [NSString stringWithFormat:@"%.2f",[_detailModel.amount floatValue] - [_detailModel.money floatValue]];
    [self.navigationController pushViewController:vc animated:YES];
}
// 退款
-(void)refundOrderWithOrder_id:(NSString *)order_id phone:(NSString *)phone{
    JHWaimaiOrderBackMoneyVC *vc = [[JHWaimaiOrderBackMoneyVC alloc]init];
    vc.order_id = _detailModel.order_id;
    vc.mobile = _detailModel.waimai[@"phone"];
    [self.navigationController pushViewController:vc animated:YES];
}
// 去评价
-(void)commentOrderWithOrder:(id)order{
    JHWaimaiOrderDetailEvaluateVC *vc = [JHWaimaiOrderDetailEvaluateVC new];
    vc.order_id =  _detailModel.order_id;
    vc.shopImg = _detailModel.waimai[@"logo"];
    vc.shopName =_detailModel.waimai[@"title"];
    vc.timeArr = _detailModel.time;
    vc.jifenNum = _detailModel.jifen_total;
    vc.productsArr = _detailModel.products;
    vc.isziti = [_detailModel.pei_type isEqualToString:NSLocalizedString(@"自提", nil)]?YES:NO;
    [self.navigationController pushViewController:vc animated:YES];

}
// 再来一单
-(void)againOrderWithOrder:(id)order{

    JHWaiMaiShopDetailVC *vc = [JHWaiMaiShopDetailVC new];
    vc.shop_id = _detailModel.waimai[@"shop_id"];
    NSArray *goodArr = [_detailModel.products firstObject][@"product"];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in goodArr) {
        if ([dic[@"huangou_id"] isEqualToString:@"0"]) {// 不是换购商品
            [arr addObject:dic];
        }
    }
    vc.onceAgainProductsArr = arr.copy;
    [self.navigationController pushViewController:vc animated:YES];
}
// 催单
-(void)cuiOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHWaiMaiOrderViewModel postToCuidanOrderWithDic:@{@"order_id":_detailModel.order_id} block:^(NSString *err) {
        HIDE_HUD
        if (err) {
            [self showToastAlertMessageWithTitle:err];
        }else{
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"您已成功催单,请耐心等候!", nil)];
        }
    }];
}
// 确认送达,确认自提
-(void)confirmOrderWithOrder_id:(NSString *)order_id{
    SHOW_HUD
    [JHWaiMaiOrderViewModel postToSureOrderWithDic:@{@"order_id":_detailModel.order_id} block:^(NSString *err) {
        HIDE_HUD
        if (err) {
            [self showToastAlertMessageWithTitle:err];
        }else{
            [self getData];
        }
    }];
}
// 申请客服介入
-(void)applyForCustomerServicesWithOrder_id:(NSString *)order_id{
    [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"确定申请客服介入", nil) withBtn_cancel:NSLocalizedString(@"取消", nil) withBtn_sure:NSLocalizedString(@"确定", nil) withController:self withCancelBlock:nil withSureBlock:^{
        SHOW_HUD
        [JHWaiMaiOrderViewModel postToServiseWithDic:@{@"order_id":_detailModel.order_id} block:^(NSString *err) {
            HIDE_HUD
            if (err) {
                [self showToastAlertMessageWithTitle:err];
            }else{
                [self showToastAlertMessageWithTitle:NSLocalizedString(@"申请成功,等待客服与您联系!", nil)];
                [self getData];
            }
        }];
    }];
}
// 查看评价
-(void)viewCommentWithOrder:(id)order{
    JHWaimaiOrderDetailSeeEvaluationVC * vc = [[JHWaimaiOrderDetailSeeEvaluationVC alloc]init];
    vc.comment_id = _detailModel.comment_id;
    vc.isziti = [_detailModel.pei_type isEqualToString:NSLocalizedString(@"自提", nil)]?YES:NO;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
