//
//  JHWMCreateOrderVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMCreateOrderVC.h"
#import "NSString+Tool.h"
#import "SevenSwitch.h"
#import "LeftAndRightLabCell.h"
#import "LeftAndRightLabWithArrowCell.h"
#import "OrderGoodCell.h"
#import "OrderAddressCell.h"
#import "JHCreateOrderSheetView.h"
#import "YFPayTool.h"
#import "JHWMCreateOrderAddNoticeVC.h"
#import "JHShowShopLocationVC.h"
#import "WMCreateOrderModel.h"
#import "JHWaiMaiAddressVC.h"
#import "JHWaimaiOrderDetailVC.h"
#import "JHWMHuanGouGoodCell.h"
#import "YFBuyMemberPeiSongCardView.h"
#import "JHOrderPeiSongMemberCardCell.h"
#import "AppDelegate.h"
#import "YFTabBarController.h"
#import "JHWMChooseFirstYouHuiCell.h"
#import "YFSegmentedControl.h"
#import "WMCreateOrderZitiAddrCell.h"
#import "JHOrderBuyHongBaoCardCell.h"
#import "JHPaySheetVC.h"

@interface JHWMCreateOrderVC ()<UITableViewDelegate,UITableViewDataSource,JHCreateOrderSheetViewDelegate>{
    BOOL isNeedZiti;
}
@property(nonatomic,weak)YFSegmentedControl *segment;

@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,strong)JHCreateOrderSheetView *payWaySheet;
@property(nonatomic,strong)JHCreateOrderSheetView *timeSheet;

@property(nonatomic,strong)YFBuyMemberPeiSongCardView *buyCardSheet;
@property(nonatomic,strong)YFBuyMemberPeiSongCardView *chooseCardSheet;

// 是否选择了选择了在线支付
@property(nonatomic,assign)BOOL is_choosed_pay_online;
// 是否选择了选择了自提
@property(nonatomic,assign)BOOL is_choosed_ziti;

@property(nonatomic,copy)NSString *notice;

@property(nonatomic,assign)NSInteger dateline;
@property(nonatomic,copy)NSString *dateline_str;// 选择的时间
@property(nonatomic,strong)WMCreateOrderModel *orderModel;
// 订单id
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,strong)NSDictionary *choosedCardInfo;// 选择的会员卡信息
@property(nonatomic,strong)NSArray *choosedHuanGouGoodInfo;// 选择的换购商品
@property(nonatomic,assign)int huangou_count;// 选择换购商品的数量
@property(nonatomic,assign)BOOL use_first_youhui;// 是否使用首单优惠
@property(nonatomic,assign)BOOL buy_peisong_card;// 是否购买配送会员卡
@property(nonatomic,assign)BOOL buy_hongbao_package;// 是否购买红包套餐
@end

@implementation JHWMCreateOrderVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.is_choosed_ziti = NO;
    [self setUpView];
    [self getData];
    if ([self.isZiti isEqualToString:@"1"]) {
         isNeedZiti = YES;
    }

}

-(void)setUpView{
    
    self.navigationItem.title = NSLocalizedString(@"提交订单", nil);
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    [tableView registerClass:[LeftAndRightLabCell class] forCellReuseIdentifier:@"LeftAndRightLabCell"];
    [tableView registerClass:[LeftAndRightLabWithArrowCell class] forCellReuseIdentifier:@"LeftAndRightLabWithArrowCell"];
    [tableView registerClass:[OrderGoodCell class] forCellReuseIdentifier:@"OrderGoodCell"];
    [tableView registerClass:[OrderAddressCell class] forCellReuseIdentifier:@"OrderAddressCell"];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=NAVI_HEIGHT;
        make.right.offset=0;
        make.bottom.offset=-WMShopCartBottomViewH;
    }];
   
    [self createBottomView];

}

-(void)createBottomView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.right.offset=0;
        make.height.offset=WMShopCartBottomViewH;
    }];
    
    UIButton *goPayBtn = [UIButton new];
    [view addSubview:goPayBtn];
    [goPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=0;
        make.top.offset=0;
        make.width.offset=115;
        make.height.offset=49;
    }];
    goPayBtn.titleLabel.font = FONT(16);
    goPayBtn.backgroundColor = HEX(@"ff6600", 1.0);
    [goPayBtn setTitle:NSLocalizedString(@"立即下单", @"JHWMCreateOrderVC") forState:UIControlStateNormal];
    [goPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goPayBtn addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *priceLab = [UILabel new];
    [view addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(goPayBtn.mas_left).offset= -10;
        make.centerY.equalTo(goPayBtn.mas_centerY).offset=0;
        make.left.offset=10;
        make.height.offset=20;
    }];
    priceLab.font = FONT(14);
    priceLab.textColor = TEXT_COLOR;
    priceLab.textAlignment = NSTextAlignmentRight;
    self.priceLab = priceLab;
    
    UIView *lineView=[UIView new];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.orderModel) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr:nil btnTitle:nil inView:tableView];
        return 0;
    }else{
        [self hiddenEmptyView];
    }
    return self.orderModel.huangous.count > 0 ? 6 : 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 1:// 时间、支付方式 和  红包、优惠劵 会员卡 是否使用首单优惠
        {
            return [self getSectionCellNames].count;
        }
            break;
        case 2:// 商品信息
            return self.orderModel.product_lists.count;
            break;
        case 3:// 配送费、打包费 和满减优惠
        {
            NSInteger count = self.is_choosed_ziti ? 1 : 2;
            return count + self.orderModel.youhui.count;
        }
            break;
        case 4:// 配送费、打包费 和满减优惠
        {
            if (self.orderModel.huangous.count > 0) {
                return  self.orderModel.huangous.count;
            }else return 1;
            
        }
            break;
        default:
            return 1;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf=self;
    UITableViewCell *returnCell = [UITableViewCell new];
    switch (indexPath.section) {
        case 0:
        {
            if (self.is_choosed_ziti) {
                WMCreateOrderZitiAddrCell *cell = [WMCreateOrderZitiAddrCell initWithTableView:tableView reuseIdentifier:@"WMCreateOrderZitiAddrCell"];
                [cell reloadCellWithModel:self.orderModel];
                returnCell = cell;
            }else{
                OrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderAddressCell" forIndexPath:indexPath];
                if (self.orderModel.m_addr.addr_id.length == 0 || [self.orderModel.m_addr.addr_id isEqualToString:@"0"]) {
                    [cell reloadCell:nil addrStr:nil];
                }else{
                    NSString *str1 = [NSString stringWithFormat:@"%@ %@",self.orderModel.m_addr.contact,self.orderModel.m_addr.mobile];
                    NSString *str2 = [NSString stringWithFormat:@"%@ %@",self.orderModel.m_addr.addr,self.orderModel.m_addr.house];
                    [cell reloadCell:str1 addrStr:str2];
                }

                returnCell = cell;
            }
           
        }
            break;
        case 1:// 时间、支付方式 和  红包、优惠劵
        {
            
            NSArray *arr = [self getSectionCellNames];
            NSString *cellName = arr[indexPath.row];
            if ([cellName isEqualToString:@"LeftAndRightLabWithArrowCell"]) {
                LeftAndRightLabWithArrowCell *cell = [LeftAndRightLabWithArrowCell initWithTableView:tableView reuseIdentifier:@"LeftAndRightLabWithArrowCell"];
                cell.arrowImgView.hidden = NO;
                
                NSString *str0 = self.is_choosed_ziti ? NSLocalizedString(@"自提时间", @"JHWMCreateOrderVC") : NSLocalizedString(@"送达时间", @"JHWMCreateOrderVC");
                NSArray * arr = @[str0,NSLocalizedString(@"支付方式", @"JHWMCreateOrderVC"),NSLocalizedString(@"红包", nil),NSLocalizedString(@"优惠劵", nil),NSLocalizedString(@"配送会员卡", @"JHWMCreateOrderVC")];
                
                NSString *time = self.dateline_str;
                NSDictionary *time_dic = [[self.orderModel getTimesArr:self.is_choosed_ziti] firstObject];
                NSString *first_time =[NSString stringWithFormat:@"%@ %@",time_dic[@"day"],time_dic[@"times"][0]];
                if ([first_time containsString: NSLocalizedString(@"立即", NSStringFromClass([self class]))]) {
                    first_time = time_dic[@"times"][0];
                }else{
                    if ([time_dic[@"day"] containsString: NSLocalizedString(@"今天", NSStringFromClass([self class]))]) {
                        first_time = time_dic[@"times"][0];
                    }
                }
                
                NSString *str1 = self.dateline  == 0 ? first_time : time;
                NSString *str2 = self.is_choosed_pay_online ? NSLocalizedString(@"在线支付", @"JHWMCreateOrderVC") : NSLocalizedString(@"货到付款", @"JHWMCreateOrderVC");
                NSString *str3 = self.orderModel.hongbaos.count == 0 ? NSLocalizedString(@"暂无可用", @"JHWMCreateOrderVC") : ([self.orderModel.hongbao_id intValue] == 0 ? NSLocalizedString(@"不使用红包", nil): self.orderModel.hongbao_amount);
                NSString *str4 = self.orderModel.coupons.count == 0 ? NSLocalizedString(@"暂无可用", @"JHWMCreateOrderVC") : ([self.orderModel.coupon_id intValue] == 0 ? NSLocalizedString(@"不使用优惠劵", nil) : self.orderModel.coupon_amount);
                NSString *str5 = self.orderModel.have_peicard ? NSLocalizedString(@"暂无可用", NSStringFromClass([self class])) : NSLocalizedString(@"未购买", NSStringFromClass([self class]));
                
                if (!self.is_choosed_pay_online) {
                    // 货到付款时红包的处理
                    str3 = self.orderModel.support_hongbao ? str3 : NSLocalizedString(@"不支持使用红包", NSStringFromClass([self class]));
                    // 货到付款时优惠劵的处理
                    str4 = self.orderModel.support_youhui ? str4 : NSLocalizedString(@"不支持使用优惠劵", NSStringFromClass([self class]));
                }
                
                if (self.orderModel.have_peicard && self.orderModel.cards.count == 0) {
                    str5 = NSLocalizedString(@"暂无可用", NSStringFromClass([self class]));
                }
                
                UIColor *color = indexPath.row > 1 ? color = HEX(@"999999", 1.0) : HEX(@"14aae4", 1.0);
                BOOL is_money = indexPath.row > 1 ? YES : NO;
                if ((indexPath.row == 2 && ([self.orderModel.hongbao_id intValue] != 0 && self.orderModel.hongbaos.count != 0)) || (indexPath.row == 3 && ([self.orderModel.coupon_id intValue] != 0 && self.orderModel.coupons.count != 0))) {
                    color = HEX(@"ff6600", 1.0);
                }
                
                if (indexPath.row >= 4) {
                    if(self.buy_peisong_card || [self.orderModel.peicard_id intValue] > 0) {
                        is_money = YES;
                        str5 = self.orderModel.peicard_amount;
                        color = HEX(@"ff6600", 1.0);
                    }else{
                        if ([self.orderModel.peicards count] > 0) {
                            str5 = NSLocalizedString(@"未使用", NSStringFromClass([self class]));
                        }
                        color = HEX(@"999999", 1.0);
                        is_money = NO;
                    }
                }
                
                NSArray * normalRightArr = @[str1,str2,str3,str4,str5];
                if (indexPath.row < 4) {
                    cell.arrowImgView.hidden = NO;
                    [cell reloadCell:arr[indexPath.row] rightStr:normalRightArr[indexPath.row] rightColor:color is_money:is_money];
                }else{
                    cell.arrowImgView.hidden = !self.orderModel.have_peicard;
                    [cell reloadCell:arr.lastObject rightStr:normalRightArr.lastObject rightColor:color is_money:is_money];
                }

                returnCell = cell;
            }
            if ([cellName isEqualToString:@"JHWMChooseFirstYouHuiCell"]) {
                JHWMChooseFirstYouHuiCell *cell = [JHWMChooseFirstYouHuiCell initWithTableView:tableView reuseIdentifier:@"JHWMChooseFirstYouHuiCell"];
                cell.youhuiSwitch.on = self.use_first_youhui;
                // 是否使用首单优惠
                cell.swChangeValueBlock = ^(BOOL success, NSString *msg) {
                    [weakSelf changeOrderInfoWithChangeInfo:@{@"is_first":@(success)}];
                };
                returnCell = cell;
            }

            // 购买的会员卡
            if ([cellName isEqualToString:@"JHOrderPeiSongMemberCardCell"]) {
                JHOrderPeiSongMemberCardCell *cell = [JHOrderPeiSongMemberCardCell initWithTableView:tableView reuseIdentifier:@"JHOrderPeiSongMemberCardCell"];
                [cell reloadCellWithInfo:self.choosedCardInfo selected:self.buy_peisong_card];
                cell.chooesedBlock = ^(BOOL success, NSString *msg) {
                    weakSelf.buy_peisong_card = success;
                    NSString *pcard_id = success ? self.choosedCardInfo[@"card_id"] : @"";
                    [weakSelf changeOrderInfoWithChangeInfo:@{@"pcard_id":pcard_id}];
                };
                cell.showPeiSongList = ^(BOOL success, NSString *msg) {
                    [weakSelf showPeiSongCardList];
                };
                returnCell = cell;
            }
            
            // 购买的红包套餐
            if ([cellName isEqualToString:@"JHOrderBuyHongBaoCardCell"]) {
                JHOrderBuyHongBaoCardCell *cell = [JHOrderBuyHongBaoCardCell initWithTableView:tableView reuseIdentifier:@"JHOrderBuyHongBaoCardCell"];
                [cell reloadCellWithInfo:self.orderModel.hongbaoPackage selected:self.buy_hongbao_package];
                cell.chooesedBlock = ^(BOOL success, NSString *msg) {
                    weakSelf.buy_hongbao_package = success;
                    if (success) {
                       [weakSelf changeOrderInfoWithChangeInfo:@{@"hongbao_package_id":weakSelf.orderModel.hongbaoPackage[@"package_id"]}];
                    }else{
                       [weakSelf changeOrderInfoWithChangeInfo:@{@"hongbao_package_id":@""}];
                    }
                };
                returnCell = cell;
            }
            
        }
            break;
        case 2:// 商品信息
        {
            OrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderGoodCell" forIndexPath:indexPath];
            NSDictionary *dic = self.orderModel.product_lists[indexPath.row];
            [cell reloadCellWithGoodInfo:dic];
            returnCell = cell;
        }
            break;
        case 3:// 配送费、打包费 和满减优惠
        {
            LeftAndRightLabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftAndRightLabCell" forIndexPath:indexPath];
            int count = self.is_choosed_ziti ? 1 : 2;

            if (indexPath.row < count) {
                NSString *str = @"";
                NSString *amount = @"";
                if (self.is_choosed_ziti) {
                    str = NSLocalizedString(@"餐盒打包费", @"JHWMCreateOrderVC");
                   amount = self.orderModel.package_price;
                    [cell reloadCell:str rightStr:amount];
                }else{
                    str = indexPath.row == 0 ? NSLocalizedString(@"配送费", nil) : NSLocalizedString(@"餐盒费", @"JHWMCreateOrderVC");
                    amount = indexPath.row == 0 ? self.orderModel.freight_stage : self.orderModel.package_price;
                }
               
                [cell reloadCell:str rightStr:amount];
            }else{
                NSDictionary *dic = self.orderModel.youhui[indexPath.row - count];
                cell.clickQuestionBlock = ^(BOOL success, NSString *msg) {
                    [weakSelf showAlertWithTitle:weakSelf.orderModel.un_reduce_freight_info msg:@"" btnTitle:@"确定" action:^{}];
                };
                [cell reloadCellWithYouHuiDic:dic];
            }
            
            returnCell = cell;
        }
            break;
        case 4:
        {
            BOOL have_huangou = self.orderModel.huangous.count > 0;
            if(have_huangou){// 换购商品
                JHWMHuanGouGoodCell *cell = [JHWMHuanGouGoodCell initWithTableView:tableView reuseIdentifier:@"JHWMHuanGouGoodCell.h"];
                [cell reloadCellWithModel:self.orderModel.huangous[indexPath.row]];
                // 换购商品数量发生变化
                cell.chooseGoodReloadBlock = ^(id model, NSString *msg) {
                    [weakSelf changeHuanGouGoodCount:model];
                };
                
                returnCell = cell;
            }else{
                static NSString *ID=@"NoticeCell";
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    UILabel *lab = [UILabel new];
                    [cell.contentView addSubview:lab];
                    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset=10;
                        make.centerY.offset=0;
                        make.height.offset=20;
                        make.width.offset = 70;
                    }];
                    lab.font = FONT(14);
                    lab.textColor = TEXT_COLOR;
                    lab.text = NSLocalizedString(@"买家留言", @"JHWMCreateOrderVC");
                    
                    UILabel *noticeLab = [UILabel new];
                    [cell.contentView addSubview:noticeLab];
                    [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(lab.mas_right).offset=0;
                        make.right.offset = -10;
                        make.centerY.offset=0;
                        make.height.offset=20;
                    }];
                    noticeLab.font = FONT(14);
                    noticeLab.lineBreakMode = NSLineBreakByTruncatingTail;
                    noticeLab.textColor = HEX(@"999999", 1.0);
                    noticeLab.tag = 100;
                }
                
                UILabel *noticeLab = [cell viewWithTag:100];
                noticeLab.text = [self.notice length] == 0 ? NSLocalizedString(@"点击输入(选填)", @"JHWMCreateOrderVC") : self.notice ;
                noticeLab.textAlignment = [self.notice length]== 0 ? NSTextAlignmentLeft : NSTextAlignmentRight;
                
                returnCell = cell;
            }
            
        }
            break;
        case 5:// 买家留言
        {
            static NSString *ID=@"NoticeCell";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                UILabel *lab = [UILabel new];
                [cell.contentView addSubview:lab];
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset=10;
                    make.centerY.offset=0;
                    make.height.offset=20;
                    make.width.offset = 70;
                }];
                lab.font = FONT(14);
                lab.textColor = TEXT_COLOR;
                lab.text = NSLocalizedString(@"买家留言", @"JHWMCreateOrderVC");
                
                UILabel *noticeLab = [UILabel new];
                [cell.contentView addSubview:noticeLab];
                [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lab.mas_right).offset=0;
                    make.right.offset = -10;
                    make.centerY.offset=0;
                    make.height.offset=20;
                }];
                noticeLab.font = FONT(14);
                noticeLab.lineBreakMode = NSLineBreakByTruncatingTail;
                noticeLab.textColor = HEX(@"999999", 1.0);
                noticeLab.tag = 100;
            }
            
            UILabel *noticeLab = [cell viewWithTag:100];
            noticeLab.text = [self.notice length] == 0 ? NSLocalizedString(@"点击输入(选填)", @"JHWMCreateOrderVC") : self.notice ;
            noticeLab.textAlignment = [self.notice length]== 0 ? NSTextAlignmentLeft : NSTextAlignmentRight;
            
            returnCell = cell;
            
        }
            break;
    }
    returnCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return returnCell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ((section == 0 && self.orderModel.is_ziti) || section == 2) {
        return 40;
    }else if (section == 4){// 换购商品
        return self.orderModel.huangous.count > 0 ? 58 : 10;
    }else if (section == 5){
        return 10;
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 40;
    }else if (section == 2) {
        return CGFLOAT_MIN;
    }else if (section == 4 && self.orderModel.huangous.count > 0){
        // 换购商品
        return 96;
    }
    return 10;
}

#pragma mark ======SectionHeaderView/FooterView =======
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 && self.orderModel.is_ziti) {
        UIView *view  = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];

        YFSegmentedControl *segment = [[YFSegmentedControl alloc] initWithFrame:FRAME(0, 0, WIDTH/3 * 2, 40) titleArr:@[@{@"title":NSLocalizedString(@"外卖配送", nil)},@{@"title":NSLocalizedString(@"到店自提", @"ContentView")}]];
        [view addSubview:segment];
        [segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.top.offset=0;
            make.right.offset=0;
            make.height.offset=40;
        }];
        segment.indicatorWidth = WIDTH/3.0 * 0.5;
        segment.textFont = FONT(16);
        segment.showIndicator = YES;
        segment.selectedColor = HEX(@"4A92F6", 1.0);
        segment.backgroundColor = [UIColor whiteColor];
        segment.normalColor = HEX(@"666666", 1.0);
        [segment addTarget:self action:@selector(segementClick:) forControlEvents:UIControlEventValueChanged];
        segment.selectedSegmentIndex = self.is_choosed_ziti ? 1 : 0;
        self.segment = segment;
        
        UIView *lineView=[UIView new];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.bottom.offset=-0.5;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor=LINE_COLOR;
        
        return view;
    }else if( section == 2){
        
        UIView *view  = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [UIImageView new];
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.width.offset=16;
            make.centerY.offset = 0;
            make.height.offset=15;
        }];
        imgView.image = IMAGE(@"icon_wai_te");
        
        UILabel *titleLab = [UILabel new];
        [view addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset=10;
            make.centerY.offset = 0;
            make.width.lessThanOrEqualTo(@170);
            make.height.offset=20;
        }];
        titleLab.font =FONT(14);
        titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLab.textColor = TEXT_COLOR;
        titleLab.text = self.orderModel.shop_title;
        
        UIView *lineView=[UIView new];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.bottom.offset= -0.5;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor=LINE_COLOR;
        
        return view;
    }else if( section == 4 && self.orderModel.huangous.count > 0){// 有换购商品的时候
        
        UIView *backView = [UIView new];
        backView.backgroundColor = BACK_COLOR;
        
        UIView *view  = [[UIView alloc] initWithFrame:FRAME(0, 10, WIDTH, 48)];
        [backView addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLab = [UILabel new];
        [view addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.centerY.offset = 0;
            make.height.offset=20;
        }];
        titleLab.font =FONT(16);
        titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLab.textColor = TEXT_COLOR;
        titleLab.text =  NSLocalizedString(@"超值换购", NSStringFromClass([self class]));
        
        UIView *lineView=[UIView new];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.bottom.offset= -0.5;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor=LINE_COLOR;
        
        return backView;
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 3) {
        UIView *view  = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView=[UIView new];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.top.offset=0;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor=LINE_COLOR;
        
        UILabel *priceLab = [UILabel new];
        [view addSubview:priceLab];
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-10;
            make.centerY.offset=0;
            make.height.offset=20;
        }];
        priceLab.textColor = TEXT_COLOR;
        priceLab.font = FONT(18);
        priceLab.textAlignment = NSTextAlignmentRight;

        NSString *price = self.orderModel.amount;//[self.orderModel getOrderAmountWith:self.is_choosed_pay_online ziti:self.is_choosed_ziti];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"合计: ", nil)];
        NSString *priceStr = [NSString stringWithFormat:@"¥ %@",price];
        [attStr appendAttributedString: [NSString getAttributeString:priceStr strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff6600", 1.0)}]];
        priceLab.attributedText = attStr;
        
        UILabel *countLab = [UILabel new];
        [view addSubview:countLab];
        [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(priceLab.mas_left).offset=-10;
            make.centerY.offset=0;
            make.height.offset=20;
        }];
        countLab.textColor = HEX(@"999999", 1.0);
        countLab.font = FONT(14);
        countLab.text = [NSString stringWithFormat: @"%@%@%@",NSLocalizedString(@"共", nil),self.orderModel.product_number,NSLocalizedString(@"件商品", @"JHWMCreateOrderVC")];
        
        return view;
    }else if( section == 4 && self.orderModel.huangous.count > 0){// 有换购商品的时候
        
        UIView *view  = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 95)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView=[UIView new];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.top.offset=0;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor=LINE_COLOR;
        
        UIView *lineView2=[UIView new];
        [view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.centerY.offset=0;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView2.backgroundColor=LINE_COLOR;
        
        UILabel *lab = [UILabel new];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10;
            make.centerY.offset=-24;
            make.height.offset=20;
        }];
        lab.textColor = TEXT_COLOR;
        lab.font = FONT(16);
        lab.text =  NSLocalizedString(@"餐盒费", NSStringFromClass([self class]));

        UILabel *canHePriceLab = [UILabel new];
        [view addSubview:canHePriceLab];
        [canHePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-10;
            make.centerY.equalTo(lab.mas_centerY).offset=0;
            make.height.offset=20;
        }];
        canHePriceLab.textColor = HEX(@"ff6600", 1.0);
        canHePriceLab.font = FONT(16);
        canHePriceLab.textAlignment = NSTextAlignmentRight;
        canHePriceLab.text = [NSString stringWithFormat: NSLocalizedString(@"¥ %g", NSStringFromClass([self class])),self.orderModel.huangou_package_price];
        
        UILabel *priceLab = [UILabel new];
        [view addSubview:priceLab];
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-10;
            make.centerY.offset=24;
            make.height.offset=20;
        }];
        priceLab.textColor = TEXT_COLOR;
        priceLab.font = FONT(18);
        priceLab.textAlignment = NSTextAlignmentRight;

        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"合计: ", nil)];
        NSString *priceStr = [NSString stringWithFormat:@"¥ %g",self.orderModel.huangou_amount];
        [attStr appendAttributedString: [NSString getAttributeString:priceStr strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff6600", 1.0)}]];
        priceLab.attributedText = attStr;
        
        UILabel *countLab = [UILabel new];
        [view addSubview:countLab];
        [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(priceLab.mas_left).offset=-10;
            make.centerY.equalTo(priceLab.mas_centerY);
            make.height.offset=20;
        }];
        countLab.textColor = HEX(@"999999", 1.0);
        countLab.font = FONT(14);
        countLab.text = [NSString stringWithFormat: @"%@%d%@",NSLocalizedString(@"共", nil),self.huangou_count,NSLocalizedString(@"件商品", @"JHWMCreateOrderVC")];
        
        return view;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:// 选择时间
                _timeSheet.dataSource = [self.orderModel getTimesArr:self.is_choosed_ziti];
                [self.timeSheet sheetShow];
                break;
            case 1:// 选择支付方式
                [self.payWaySheet sheetShow];
                break;
            case 2:// 选择红包
            {
                 __weak typeof(self) weakSelf=self;
                ClickIndexBlock clickIndexBlock = ^(NSInteger index, NSString *str){
                    NSString *hongbao_id;
                    if (index == 0) {
                        hongbao_id = @"0";
                    }else{
                        NSDictionary *dic = weakSelf.orderModel.hongbao_list[index-1];
                        hongbao_id = dic[@"hongbao_id"];
                    }
                    [weakSelf changeOrderInfoWithChangeInfo:@{@"hongbao_id":hongbao_id}];
                };
                
                [self pushToNextVcWithVcName:@"JHWMChooseRedBagOrQuanVC" params:@{@"is_redbag":@(YES),@"chooesed_id":self.orderModel.hongbao_id,@"dataSource":self.orderModel.hongbao_list,@"clickIndexBlock":clickIndexBlock}];
            }
                break;
            case 3:// 选择优惠劵
            {
                __weak typeof(self) weakSelf=self;
                ClickIndexBlock clickIndexBlock = ^(NSInteger index, NSString *str){
                    NSString *coupon_id;
                    if (index == 0) {
                        coupon_id = @"0";
                    }else{
                        NSDictionary *dic = weakSelf.orderModel.coupon_list[index-1];
                        coupon_id = dic[@"coupon_id"];
                    }
                    [weakSelf changeOrderInfoWithChangeInfo:@{@"coupon_id":coupon_id}];
                };
                
                [self pushToNextVcWithVcName:@"JHWMChooseRedBagOrQuanVC" params:@{@"is_redbag":@(NO),@"chooesed_id":self.orderModel.coupon_id,@"dataSource":self.orderModel.coupon_list,@"clickIndexBlock":clickIndexBlock}];
                
            }
                break;
            default:// 选择会员卡
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
                // 配送会员卡
                if ([cell isKindOfClass:[LeftAndRightLabWithArrowCell class]]) {
                    if ([self.orderModel.peicards count] > 0) {// 拥有会员卡
                        self.chooseCardSheet.dataSource = self.orderModel.peicards;
                        if (self.choosedCardInfo) {
                            self.chooseCardSheet.choosed_card_id = self.choosedCardInfo[@"cid"];
                        }else {
                            self.chooseCardSheet.choosed_card_id = _orderModel.peicard_id;
                        }
                        [self.chooseCardSheet yf_sheetShowAnimation];
                    }
                }
                
            }
                break;
        }
    }else if (indexPath.section == 0) { // 添加notice
        if (self.is_choosed_ziti) {// 显示商家地址
            
            JHShowShopLocationVC *locationVC = [JHShowShopLocationVC new];
            locationVC.lat = self.orderModel.shop_lat;
            locationVC.lng = self.orderModel.shop_lng;
            locationVC.shopName = self.orderModel.shop_title;
            [self.navigationController pushViewController:locationVC animated:YES];
            
        }else{// 选择收货地址
            JHWaiMaiAddressVC *addr = [JHWaiMaiAddressVC new];
            addr.shop_id = self.orderModel.shop_id;
            addr.order_price = [self.orderModel.product_price floatValue];
            addr.addr_id = self.orderModel.m_addr.addr_id;
             __weak typeof(self) weakSelf=self;
            [addr setSelectorBlock:^(JHWaimaiMineAddressListDetailModel * addr) {
                [weakSelf changeOrderInfoWithChangeInfo:@{@"addr_id":addr.addr_id}];
//                [weakSelf changeAddr:addr];
            }];
            [self.navigationController pushViewController:addr animated:YES];
        }
        
    }else  if (indexPath.section == 4 && self.orderModel.huangous.count == 0) { // 添加notice

        JHWMCreateOrderAddNoticeVC *noticeVC = [JHWMCreateOrderAddNoticeVC new];
         __weak typeof(self) weakSelf=self;
        noticeVC.clickSure = ^(NSString *notice){
            weakSelf.notice = notice;
            [weakSelf.tableView reloadData];
        };
        noticeVC.notice = self.notice;
        [self.navigationController pushViewController:noticeVC animated:YES];
    }else if (indexPath.section == 5) { // 添加notice
        
        JHWMCreateOrderAddNoticeVC *noticeVC = [JHWMCreateOrderAddNoticeVC new];
        __weak typeof(self) weakSelf=self;
        noticeVC.clickSure = ^(NSString *notice){
            weakSelf.notice = notice;
            [weakSelf.tableView reloadData];
        };
        noticeVC.notice = self.notice;
        [self.navigationController pushViewController:noticeVC animated:YES];
    }
}

#pragma mark ====== JHCreateOrderSheetViewDelegate =======
-(void)sheetView:(JHCreateOrderSheetView *)sheetView clickIndex:(NSInteger)index choosedValue:(NSString *)str{
    if (sheetView == _timeSheet) {// 选择时间的回调
        
        NSArray *arr = [str componentsSeparatedByString:@","];
        self.dateline_str = arr.lastObject;
        NSString *datelineStr = arr.firstObject;
        
        if ([datelineStr containsString: NSLocalizedString(@"立即", NSStringFromClass([self class]))]) {
            datelineStr = @"0";
        }
        NSInteger dateline = [NSString getDatelineOfDate:datelineStr formate:@"yyyy-MM-dd HH:mm"];
        
        self.dateline = dateline;
        [self.tableView reloadData];
        
    }else if (sheetView == _payWaySheet){//  选择支付方式的回调
        // index == 0 在线支付
        int online_pay = index == 0 ? 1 : 0;
        [self changeOrderInfoWithChangeInfo:@{@"online_pay":@(online_pay)}];
        
    }
}

#pragma mark ====== Functions =======
// 获取订单信息
-(void)getData{
    SHOW_HUD
    [WMCreateOrderModel getCreateOrderDetailWith:self.shop_id isZiti:self.isZiti ?self.isZiti :@"0" block:^(WMCreateOrderModel* model, NSString *msg) {
        HIDE_HUD
        if (model) {
            self.orderModel = model;
            self.chooseCardSheet.dataSource = model.peicards;
            self.buyCardSheet.dataSource = model.cards;
            self.is_choosed_pay_online = model.online_pay;
            self.use_first_youhui = model.is_first;
            self.choosedCardInfo = model.cards.firstObject;
            [self setPrice];
            [self.tableView reloadData];
            [self zitiOpen];
        }else{
            [self showToastAlertMessageWithTitle:msg];
        }
    }];
}

// 点击立即下单
-(void)payOrder{
    if (self.orderModel.m_addr.addr_id.length == 0 && !self.is_choosed_ziti) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请选择收货地址" , nil)];
        return;
    }
    NSString *hg_str = [self getHuanGouProductStr];

    int is_ziti = self.is_choosed_ziti ? 3 : 0;
    int online_pay = self.is_choosed_pay_online ? 1 : 0;
    self.notice =  self.notice ? self.notice : @"" ;
    NSDictionary *dic = @{
                          @"shop_id":self.orderModel.shop_id,
                          @"addr_id":self.orderModel.m_addr.addr_id,
                          @"coupon_id":self.orderModel.coupon_id,
                          @"hongbao_id":self.orderModel.hongbao_id,
                          @"pei_type":@(is_ziti),
                          @"pei_time":@(_dateline),
                          @"online_pay":@(online_pay),
                          @"products":self.orderModel.products,
                          @"intro":self.notice ,
                          @"is_first":@(self.use_first_youhui ? 1 : 0),
                          @"hg_products":hg_str,// 换购商品
                          @"peicard_id" :_orderModel.peicard_id,//已经购买的会员卡ID
                          @"pcard_id": self.buy_peisong_card ?  self.choosedCardInfo[@"card_id"] : @"", //需要购买的会员卡ID
                          @"hongbao_package_id": self.buy_hongbao_package ? self.orderModel.hongbaoPackage[@"package_id"] : @"",
                          };
     __weak typeof(self) weakSelf=self;
    SHOW_HUD
    [WMCreateOrderModel getOrder_idWith:dic block:^(BOOL success, NSString *msg) {
        HIDE_HUD
        if (success) {
            self.order_id = msg;
            [[WMShopDBModel shareWMShopDBModel] deleteAllGoodsWith:_shop_id];
            if (self.is_choosed_pay_online) {// 在线支付
                NSString *price = [NSString stringWithFormat:@"%g",([self.orderModel.amount floatValue] + self.orderModel.huangou_amount)];
                MsgBlock block = ^(BOOL success ,NSString * msg){
                    [weakSelf gotoOrderDetail];
                };
                [self presentToNextVcWithVcName:@"JHPaySheetVC" params:@{@"superVC":weakSelf,@"order_id":self.order_id,@"amount":price,@"paySuccessBlock":block,@"is_show_friendPay":@(YES)}];
            }else{// 货到付款
                [self gotoOrderDetail];
            }
        }else{
            [self showToastAlertMessageWithTitle:msg];
        }
    }];
}

// 前往订单详情
-(void)gotoOrderDetail{
    [WMShopDBModel shareWMShopDBModel].current_shopcartNum = 0;
    [NoticeCenter postNotificationName:WMCreateOrderSuccess object:nil];
    
    JHWaimaiOrderDetailVC * detail = [[JHWaimaiOrderDetailVC alloc] init];
    detail.FromPayVC = YES;
    detail.order_id = self.order_id;
    
    if (self.presentingViewController) {
        YFTabBarController *tabVC = (YFTabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [tabVC.selectedViewController pushViewController:detail animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }else{
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

// 设置金额
-(void)setPrice{
    
    int count = 0;
    for (WMShopGoodModel *good in self.orderModel.huangous) {
        for (NSDictionary *dic in self.choosedHuanGouGoodInfo) {
            if ([good.product_id isEqualToString:dic[@"product_id"]]) {
                good.current_shopcart_choosedCount = [dic[@"count"] intValue];
                count += good.current_shopcart_choosedCount;
            }
        }
    }
    self.huangou_count = count;
    
    NSString *price = self.orderModel.amount;
    price = [NSString stringWithFormat:@"%g",([price floatValue] + self.orderModel.huangou_amount)];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"待支付: ", @"JHWMCreateOrderVC")];
    [attStr appendAttributedString:[NSString priceLabText:price attributeFont:18]];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEX(@"ff6600", 1.0) range:NSMakeRange(4, attStr.length-4)];
    self.priceLab.attributedText = attStr;
}

// 获取分区1的cell
-(NSArray *)getSectionCellNames{
    
    NSMutableArray *arr = @[@"LeftAndRightLabWithArrowCell",@"LeftAndRightLabWithArrowCell",@"LeftAndRightLabWithArrowCell",@"LeftAndRightLabWithArrowCell"].mutableCopy;
    
    // 是否选择使用首单优惠
    if(self.orderModel.show_first_switch) [arr addObject:@"JHWMChooseFirstYouHuiCell"];
    
    if(!self.is_choosed_ziti){
        [arr addObject:@"LeftAndRightLabWithArrowCell"];
        // 选择购买的会员卡
        if (!self.orderModel.have_peicard && self.orderModel.cards.count > 0)
            [arr addObject:@"JHOrderPeiSongMemberCardCell"];
    }
    // 显示是否可以购买红包
    if (self.orderModel.hongbaoPackage) {
       [arr addObject:@"JHOrderBuyHongBaoCardCell"];
    }

    return arr.copy;
}

-(void)showPeiSongCardList{
    // 购买配送会员卡
    if (self.orderModel.have_peicard)  return;// 购买过会员卡了
    if (!self.orderModel.have_peicard && self.orderModel.cards.count == 0) return;// 没购买会员卡同时也没有可以购买的会员卡
    self.buyCardSheet.dataSource = self.orderModel.cards;
    self.buyCardSheet.choosed_card_id = self.choosedCardInfo[@"card_id"];
    [self.buyCardSheet yf_sheetShowAnimation];
    
}

#pragma mark ====== 订单信息发生变化 =======
// 订单信息发生变化  change_dic 需要修改的key和value
-(void)changeOrderInfoWithChangeInfo:(NSDictionary *)change_dic{
    
    NSString *hg_str = [self getHuanGouProductStr];

    int is_ziti = self.is_choosed_ziti ? 1 : 0;
    int online_pay = self.is_choosed_pay_online ? 1 : 0;
    self.notice =  self.notice ? self.notice : @"" ;
    self.orderModel.m_addr.addr_id = self.orderModel.m_addr.addr_id ? self.orderModel.m_addr.addr_id : @"";
    NSMutableDictionary *dic = @{
                                 @"shop_id":self.orderModel.shop_id,
                                 @"addr_id":self.orderModel.m_addr.addr_id,
                                 @"coupon_id":self.orderModel.coupon_id,
                                 @"hongbao_id":self.orderModel.hongbao_id,
                                 @"is_ziti":@(is_ziti),
                                 @"pei_time":@(_dateline),
                                 @"online_pay":@(online_pay),
                                 @"products":self.orderModel.products,
                                 @"intro":self.notice,
                                 @"is_first":@(self.use_first_youhui ? 1 : 0),
                                 @"hg_products":hg_str,// 换购商品
                                 @"peicard_id" :_orderModel.peicard_id,//已经购买的会员卡ID
                                 @"pcard_id": self.buy_peisong_card ?  self.choosedCardInfo[@"card_id"] : @"", //需要购买的会员卡ID
                                 @"hongbao_package_id": self.buy_hongbao_package ? self.orderModel.hongbaoPackage[@"package_id"] : @"",
                                 }.mutableCopy;
    for (NSString *key in change_dic.allKeys) {
        dic[key] = change_dic[key];
    }
    
    SHOW_HUD
    [WMCreateOrderModel getOrderInfoWhenChangeInfo:dic.copy block:^(WMCreateOrderModel* model, NSString *msg) {
        HIDE_HUD
        if (model) {
            self.orderModel = model;
            [self setPrice];
            self.use_first_youhui = [dic[@"is_first"] boolValue];
            self.is_choosed_pay_online = [dic[@"online_pay"] boolValue];
            BOOL ziti = [dic[@"is_ziti"] boolValue];
            self.is_choosed_ziti = ziti;
            self.timeSheet.titleStr = ziti ? NSLocalizedString(@"选择自提时间" , @"JHWMCreateOrderVC") : NSLocalizedString(@"选择送达时间" , @"JHWMCreateOrderVC");
            if (!self.choosedCardInfo) {
                self.choosedCardInfo = model.cards.firstObject;
            }
        }else{
            [self showToastAlertMessageWithTitle:msg];
        }
        [self.tableView reloadData];
    }];
}

// 判断自提是否开启
-(void)zitiOpen{
    if (isNeedZiti) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.segment.selectedSegmentIndex = 1;
            [self segementClick:self.segment];
        });
    }
}

// 自提单选择
-(void)segementClick:(YFSegmentedControl *)seg{
    
    BOOL ziti = seg.selectedSegmentIndex == 1;
    // 相同状态返回
    if (ziti && self.is_choosed_ziti) return;
    
    int is_ziti = ziti ? 1 : 0;
    [self changeOrderInfoWithChangeInfo:@{@"is_ziti":@(is_ziti)}];
    
}

#pragma mark ====== 换购商品的处理 =======
-(NSString *)getHuanGouProductStr{
    NSMutableArray  *arr = [NSMutableArray array];
    NSString *hg_str = @"";
    if (self.orderModel.huangous.count > 0) {
        for (WMShopGoodModel *good in self.orderModel.huangous) {
            if (good.current_shopcart_choosedCount > 0) {
                NSDictionary *dic = @{@"product_id":good.product_id,@"count":@(good.current_shopcart_choosedCount)};
                [arr addObject:dic];
                if (hg_str.length == 0) {
                    hg_str = [NSString stringWithFormat:@"%@:%d",good.product_id,good.current_shopcart_choosedCount];
                }else{
                    hg_str = [NSString stringWithFormat:@"%@,%@:%d",hg_str,good.product_id,good.current_shopcart_choosedCount];
                }
            }
        }
    }
    
    self.choosedHuanGouGoodInfo = arr.copy;
    return hg_str;
}

-(void)changeHuanGouGoodCount:(WMShopGoodModel *)good{
    NSString *hg_str = [self getHuanGouProductStr];
    
    int is_ziti = self.is_choosed_ziti ? 1 : 0;
    int online_pay = self.is_choosed_pay_online ? 1 : 0;
    self.notice =  self.notice ? self.notice : @"" ;
    self.orderModel.m_addr.addr_id = self.orderModel.m_addr.addr_id ? self.orderModel.m_addr.addr_id : @"";
    NSMutableDictionary *dic = @{
                                 @"shop_id":self.orderModel.shop_id,
                                 @"addr_id":self.orderModel.m_addr.addr_id,
                                 @"coupon_id":self.orderModel.coupon_id,
                                 @"hongbao_id":self.orderModel.hongbao_id,
                                 @"is_ziti":@(is_ziti),
                                 @"pei_time":@(_dateline),
                                 @"online_pay":@(online_pay),
                                 @"products":self.orderModel.products,
                                 @"intro":self.notice,
                                 @"hg_products":hg_str,// 换购商品
                                 @"is_first":@(self.use_first_youhui ? 1 : 0),
                                 @"peicard_id" :_orderModel.peicard_id,//已经购买的会员卡ID
                                 @"pcard_id": self.buy_peisong_card ?  self.choosedCardInfo[@"card_id"] : @"", //需要购买的会员卡ID
                                 @"hongbao_package_id": self.buy_hongbao_package ? self.orderModel.hongbaoPackage[@"package_id"] : @"",
                                 }.mutableCopy;
    SHOW_HUD
    [WMCreateOrderModel getOrderInfoWhenChangeInfo:dic.copy block:^(WMCreateOrderModel* model, NSString *msg) {
        HIDE_HUD
        if (model) {
            self.orderModel = model;
            [self setPrice];
        }else{
            [self showToastAlertMessageWithTitle:msg];
            good.current_shopcart_choosedCount -= 1;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark ====== 懒加载 =======
-(JHCreateOrderSheetView *)payWaySheet{
    if (_payWaySheet==nil) {
        _payWaySheet=[[JHCreateOrderSheetView alloc] initWithTitle:NSLocalizedString(@"选择支付方式", @"JHWMCreateOrderVC") amount:nil delegate:self sheetViewType:SheetViewChoosePayWay dataSource:@[NSLocalizedString(@"在线支付", @"JHWMCreateOrderVC"),NSLocalizedString(@"货到付款", @"JHWMCreateOrderVC")]];
        if (self.orderModel.online_pay && self.orderModel.is_daofu) {
            _payWaySheet.payWayType = 0;
        }else if(self.orderModel.online_pay){
            _payWaySheet.payWayType = 1;
        }else{
            _payWaySheet.payWayType = 2;
        }
        
    }else{
        _payWaySheet.lastIndexPath = [NSIndexPath indexPathForRow:(self.is_choosed_pay_online ? 0 : 1) inSection:0];
    }
    return _payWaySheet;
}

-(JHCreateOrderSheetView *)timeSheet{
    if (_timeSheet==nil) {
        NSString *title = self.is_choosed_ziti ? NSLocalizedString(@"选择自提时间", @"JHWMCreateOrderVC") : NSLocalizedString(@"选择送达时间", @"JHWMCreateOrderVC");
        _timeSheet=[[JHCreateOrderSheetView alloc] initWithTitle:title amount:@"" delegate:self sheetViewType:SheetViewChooseTime dataSource:[self.orderModel getTimesArr:self.is_choosed_ziti]];
        
        }
    return _timeSheet;
}

-(YFBuyMemberPeiSongCardView *)chooseCardSheet{
    if (_chooseCardSheet==nil) {
        _chooseCardSheet=[[YFBuyMemberPeiSongCardView alloc] initWithFrame:CGRectZero is_bug:YES];
         __weak typeof(self) weakSelf=self;
        _chooseCardSheet.choosedCardBlock = ^(NSDictionary *cardInfo) {
            weakSelf.choosedCardInfo = cardInfo;
            NSString * peicard_id = @"";
            NSString * pcard_id = @"";
            if (cardInfo) {// 切换会员卡
                peicard_id = cardInfo[@"cid"];
                pcard_id = @"";
            }
            [weakSelf changeOrderInfoWithChangeInfo:@{@"peicard_id" :peicard_id,@"pcard_id":pcard_id}];
        };
    }
    return _chooseCardSheet;
}

-(YFBuyMemberPeiSongCardView *)buyCardSheet{
    if (_buyCardSheet==nil) {
        _buyCardSheet=[[YFBuyMemberPeiSongCardView alloc] initWithFrame:CGRectZero is_bug:NO];
        __weak typeof(self) weakSelf=self;
        _buyCardSheet.choosedCardBlock = ^(NSDictionary *cardInfo) {
            weakSelf.choosedCardInfo = cardInfo;
            NSString * peicard_id = @"";
            NSString * pcard_id = @"";
            if (cardInfo) {// 购买会员卡
                peicard_id = cardInfo[@"peicard_id"];
                pcard_id = cardInfo[@"card_id"];
            }
            [weakSelf changeOrderInfoWithChangeInfo:@{@"peicard_id" :peicard_id,@"pcard_id":pcard_id}];
        };
    }
    return _buyCardSheet;
}

@end
