//
//  JHWMShopCartVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMShopCartVC.h"
#import "NSString+Tool.h"
#import "YFTypeBtn.h"
#import "WMShopDetailShopCartCell.h"
#import "UIControl+TimeInterVal.h"
#import "NSString+Tool.h"
#import "JHShowAlert.h"
#import "AppDelegate.h"
#import "JHView.h"

@interface JHWMShopCartVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UILabel *oldPriceLab;
@property(nonatomic,weak)UIButton *orderBtn;
@property(nonatomic,weak)UITableView *shopCartTableView;
@property(nonatomic,weak)UITableView *couDanTableView;
@property(nonatomic,strong)UIControl *backControl;
@property(nonatomic,weak)UIView *shopCartBackView;
@property(nonatomic,weak)UIView *couDanBackView;
@property(nonatomic,weak)UIView *bottomView;
@property(nonatomic,weak)UIButton *cartBtn;
@property(nonatomic,weak)UIView *couDanView; // 显示满减条件和凑单的view
@property(nonatomic,weak)UILabel *couDanDesLab;// 显示满减条件和凑单的描述
@property(nonatomic,assign)BOOL is_showCouDanTable;
@property(nonatomic,weak)UILabel *package_price_lab;

@property(nonatomic,assign)CGFloat shopCartBottomViewH;

@property(nonatomic,assign)BOOL have_choose_discount;//是否选择了折扣商品

@property(nonatomic,assign)float coudan_amount;// 凑单需要的金额

// 凑单的商品数据
@property(nonatomic,strong)NSArray *couDanArr;
@end

@implementation JHWMShopCartVC

-(void)loadView{
    self.view = [[JHView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.shopCartBottomViewH = 40 + ([WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC ? 0 : 30);
    [NoticeCenter addObserver:self selector:@selector(removeShopCart) name:@"RemoveWMShopCart" object:nil];
    [self setUpView];
    
    [(JHView *)self.view setWillToHitView:self.couDanView];
}

-(void)needPopToRootVC{
    [self.superVC.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setUpView{
    
    [self.superVC.navigationController.view addSubview:self.backControl];
    [self.backControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.width.offset=WIDTH;
        make.height.offset=HEIGHT+SYSTEM_GESTURE_HEIGHT;
    }];
    #pragma mark ------- 购物车的backView
    UIView *shopCartBackView = [UIView new];
    [self.backControl  addSubview:shopCartBackView];
    [shopCartBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.right.offset=0;
        make.height.offset=0;
    }];
    self.shopCartBackView = shopCartBackView;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 5)];
    self.shopCartTableView=tableView;
    [shopCartBackView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset= -49;
        make.right.offset=0;
        make.top.offset=40;
    }];
    [self createTableViewTopViewForShopCart];
    
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, self.shopCartBottomViewH)];
    view.clipsToBounds = YES;
    UILabel *pack_price_lab = [UILabel new];
    [view addSubview:pack_price_lab];
    [pack_price_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=0;
        make.height.offset=40;
    }];
    pack_price_lab.textColor = HEX(@"333333", 1.0);
    pack_price_lab.font = FONT(14);
    self.package_price_lab = pack_price_lab;

    UIButton *addMoreCartBtn = [UIButton new];
    [view addSubview:addMoreCartBtn];
    [addMoreCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset=0;
        make.top.offset=40;
        make.height.offset=30;
    }];
    addMoreCartBtn.backgroundColor = HEX(@"f8f8f8", 1.0);
    [addMoreCartBtn setTitle: NSLocalizedString(@"商品如需分开打包,请使用多人订餐 >", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [addMoreCartBtn setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
    addMoreCartBtn.titleLabel.font = FONT(12);
    [addMoreCartBtn addTarget:self action:@selector(clickMoreShopCart) forControlEvents:UIControlEventTouchUpInside];
    
    tableView.tableFooterView = view;
    
    UIView *lineView=[UIView new];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    #pragma mark ------- 凑单的backView
    UIView *couDanBackView = [UIView new];
    [self.backControl  addSubview:couDanBackView];
    [couDanBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.right.offset=0;
        make.height.offset=0;
    }];
    self.couDanBackView = couDanBackView;
    
    UITableView *couDanTableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0) style:UITableViewStylePlain];
    couDanTableView.delegate=self;
    couDanTableView.dataSource=self;
    couDanTableView.backgroundColor = [UIColor whiteColor];
    couDanTableView.showsVerticalScrollIndicator=NO;
    couDanTableView.tableFooterView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 5)];
    self.couDanTableView=couDanTableView;
    [couDanBackView addSubview:couDanTableView];
    [couDanTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset= -49;
        make.right.offset=0;
        make.top.offset=40;
    }];
    [self createTableViewTopViewForCouDan];
    
    [self createBottomView];
    
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.shopCartTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.shopCartTableView setSeparatorInset:UIEdgeInsetsZero];
        [self.shopCartTableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.shopCartTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.shopCartTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([self.couDanTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.couDanTableView setSeparatorInset:UIEdgeInsetsZero];
        [self.couDanTableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.couDanTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.couDanTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)createTableViewTopViewForShopCart{
    UIView *topView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
    topView.backgroundColor = HEX(@"eef2f5", 1.0);
    
    YFTypeBtn *btn = [YFTypeBtn new];
    [topView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=40;
    }];
    btn.btnType = LeftImage;
    btn.titleMargin = 5;
    btn.titleLabel.font = FONT(14);
    [btn setTitle:NSLocalizedString(@"购物车",nil) forState:UIControlStateNormal];
    [btn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [btn setImage:IMAGE(@"index_icon_vl02") forState:UIControlStateNormal];
    
    YFTypeBtn *deleteBtn = [YFTypeBtn new];
    [topView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset= -10;
        make.centerY.offset=0;
        make.height.offset=40;
        make.width.greaterThanOrEqualTo(@40);
    }];
    deleteBtn.btnType = LeftImage;
    deleteBtn.titleMargin = 5;
    deleteBtn.imageMargin = -5;
    deleteBtn.titleLabel.font = FONT(12);
    [deleteBtn setTitle:NSLocalizedString(@"清空", @"JHWMShopCartVC") forState:UIControlStateNormal];
    [deleteBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [deleteBtn setImage:IMAGE(@"btn_delete") forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(clickClearShopCart) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shopCartBackView addSubview:topView];

}

-(void)createTableViewTopViewForCouDan{
    UIView *topView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
    topView.backgroundColor = HEX(@"eef2f5", 1.0);
    
    UILabel *lab = [UILabel new];
    [topView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=40;
    }];
    lab.font = FONT(14);
    lab.textColor = TEXT_COLOR;
    lab.text = NSLocalizedString(@"凑一凑", @"JHWMShopCartVC");
    
    [self.couDanBackView addSubview:topView];
    
}

-(void)createBottomView{
    
    UIView *couDanView = [UIView new];
    [self.view addSubview:couDanView];
    [couDanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(30);
        make.bottom.offset=-WMShopCartBottomViewH;
    }];
    couDanView.backgroundColor = HEX(@"FFFAD8 ", 1.0);
    couDanView.hidden = YES;
    [couDanView yf_addTarget:self action:@selector(clickCouDan)];
    self.couDanView = couDanView;
    
    UILabel *couDanDesLab = [UILabel new];
    [couDanView addSubview:couDanDesLab];
    [couDanDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    couDanDesLab.font = FONT(12);
    couDanDesLab.textColor = HEX(@"333333", 1.0);
    couDanDesLab.textAlignment = NSTextAlignmentCenter;
    couDanDesLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.couDanDesLab = couDanDesLab;

    UIView *bottomView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 49 + SYSTEM_GESTURE_HEIGHT)];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView=[UIView new];
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    UIButton *cartBtn = [UIButton new];
    [bottomView addSubview:cartBtn];
    [cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.bottom.offset=-(5 + SYSTEM_GESTURE_HEIGHT);
        make.width.offset=52;
        make.height.offset=52;
    }];
    [cartBtn setImage:IMAGE(@"index_btn_cart") forState:UIControlStateNormal];
    [cartBtn addTarget:self action:@selector(clickShopCartBtn) forControlEvents:UIControlEventTouchUpInside];
    cartBtn.responderTimeInterval = 0.5;
    self.cartBtn = cartBtn;
    
    UILabel *countLab = [UILabel new];
    [cartBtn addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=40;
        make.top.offset=2;
        make.height.offset = 15;
        make.width.greaterThanOrEqualTo(@20);
    }];
    countLab.backgroundColor = HEX(@"ff6600", 1.0);
    countLab.textColor = [UIColor whiteColor];
    countLab.layer.cornerRadius=7.5;
    countLab.font = FONT(10);
    countLab.textAlignment = NSTextAlignmentCenter;
    countLab.hidden = YES;
    countLab.clipsToBounds=YES;
    self.countLab = countLab;
    
    UILabel *priceLab = [UILabel new];
    [bottomView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cartBtn.mas_right).offset=10;
        make.top.offset=8;
//        make.right.offset= -115;
        make.height.offset=20;
    }];
    priceLab.textColor = HEX(@"ff6600", 1.0);
    priceLab.font = FONT(12);
    priceLab.attributedText = [NSString priceLabText:@"0" attributeFont:16];
    self.priceLab = priceLab;
    
    UILabel *oldPriceLab = [UILabel new];
    [bottomView addSubview:oldPriceLab];
    [oldPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLab.mas_right).offset=5;
        make.centerY.equalTo(priceLab.mas_centerY);
//        make.right.offset= -115;
        make.height.offset=20;
    }];
    oldPriceLab.textColor = HEX(@"999999", 1.0);
    oldPriceLab.font = FONT(12);
    oldPriceLab.text =  NSLocalizedString(@"¥0", NSStringFromClass([self class]));
    self.oldPriceLab = oldPriceLab;
    
    UIView *lineV=[UIView new];
    [oldPriceLab addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.centerY.offset=0;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineV.backgroundColor=HEX(@"999999", 1.0);
    
    UILabel *desLab = [UILabel new];
    [bottomView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cartBtn.mas_right).offset=10;
        make.top.equalTo(priceLab.mas_bottom).offset=0;
        make.right.offset= -115;
        make.height.offset=15;
    }];
    desLab.textColor = HEX(@"999999", 1.0);
    desLab.font = FONT(12);
    desLab.text = NSLocalizedString(@"配送费以订单为准", @"JHWMShopCartVC");
    
    UIButton *orderBtn = [UIButton new];
    [bottomView addSubview:orderBtn];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=0;
        make.top.offset=0;
        make.width.offset=115;
        make.bottom.offset= -SYSTEM_GESTURE_HEIGHT;
    }];
    orderBtn.titleLabel.font = FONT(16);
    orderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
    [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(clickCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    self.orderBtn = orderBtn;
    
    UIButton *ziTiBtn = [UIButton new];
    [self.view addSubview:ziTiBtn];
    [ziTiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.bottom.equalTo(self.couDanView.mas_top).offset=0;
        make.width.offset=70;
        make.height.offset=40;
    }];
    [ziTiBtn setImage:IMAGE(@"index_btn_ziti") forState:UIControlStateNormal];
    [ziTiBtn addTarget:self action:@selector(clickZiti) forControlEvents:UIControlEventTouchUpInside];
    ziTiBtn.hidden = YES;
    self.ziTiBtn = ziTiBtn;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.shopCartTableView) {
        return self.dataSource.count;
    }else{
        return self.couDanArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"WMShopDetailShopCartCell";
    WMShopDetailShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[WMShopDetailShopCartCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    WMShopGoodModel *model;
    if (tableView == self.shopCartTableView) {
        model = self.dataSource[indexPath.row];
        [cell reloadCellWithModel:model isCou:NO];
    }else{
        model = self.couDanArr[indexPath.row];
        [cell reloadCellWithModel:model isCou:YES];
    }
   
    
    // 数量变化
     __weak typeof(self) weakSelf=self;
    cell.block = ^(BOOL is_add){
        [weakSelf changeGoodCount:model is_add:is_add];
    };
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark ====== Functions =======
// 点击去自提
-(void)clickZiti{
    if ([JHUserModel shareJHUserModel].token.length > 0) {
       [self.superVC pushToNextVcWithVcName:@"JHWMCreateOrderVC" params:@{@"shop_id":[WMShopDBModel shareWMShopDBModel].shop_id,@"isZiti":@"1"}];
    }else{
        [self showToastAlertMessageWithTitle: NSLocalizedString(@"您还未登录,请先登录!", NSStringFromClass([self class]))];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NoticeCenter postNotificationName:LOGIN_NoticeName object:nil];
        });
    }
    
}

#pragma mark ------- 滑动返回的时候购物车不消失的问题
-(void)removeShopCart{
    
    [self.view addSubview:self.bottomView];
    self.bottomView.frame = FRAME(0,0, WIDTH, WMShopCartBottomViewH);
}

#pragma mark ------- 点击创建订单/下单
-(void)clickCreateOrder{
    
    if (self.isClosed) { return; }
    
    if (([WMShopDBModel shareWMShopDBModel].all_amount >= [self.startPrice floatValue] || [WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC) && [self.amount floatValue] > 0) {
        
        if (self.is_showCouDanTable) {
            self.is_showCouDanTable = NO;
            [self hiddenCouDanTableView];
        }
        if (self.is_showShopCartDetail) {
            self.is_showShopCartDetail = NO;
            [self hiddenShopCartDetail];
        }
        
        BOOL to_choose_must_good = NO;
        if ( self.have_must && !self.is_choosed_must_good && ![WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC) {// 商家有必选商品 且 没选择必选商品
            to_choose_must_good = YES;
        }
        if (self.createOrder) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.createOrder(to_choose_must_good);
            });
        }
        
    }
}

#pragma mark ------- 凑单处理
-(void)clickCouDan{
    
    if (!self.is_showCouDanTable) {
        self.couDanArr = [[WMShopDBModel shareWMShopDBModel].shopModel getCoudanArrWith:self.coudan_amount];
        if (self.couDanArr.count == 0) {
            [self showToastAlertMessageWithTitle: NSLocalizedString(@"暂无满足要求的凑单商品", NSStringFromClass([self class]))];
            return;
        }
        self.is_showCouDanTable = YES;
        if (self.is_showShopCartDetail) {// 收起展开的购物车
            self.is_showShopCartDetail = NO;
            [UIView animateWithDuration:0.25 animations:^{
                [self.shopCartBackView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset = 49;
                }];
                [self.superVC.navigationController.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
                [self.view addSubview:self.ziTiBtn];
                [self.ziTiBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset=-10;
                    make.bottom.equalTo(self.couDanView.mas_top).offset=0;
                    make.width.offset=70;
                    make.height.offset=40;
                }];
                
                [self showCouDanTableView];
                
            }];
        }else{
            [self showCouDanTableView];
        }
        
    }else{
        self.is_showCouDanTable = NO;
        [self hiddenCouDanTableView];
    }
    
}

#pragma mark ------- 展开凑单购物车
-(void)showCouDanTableView{
    [_backControl removeTarget:self action:@selector(clickShopCartBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backControl addTarget:self action:@selector(clickCouDan) forControlEvents:UIControlEventTouchUpInside];
    
    ((JHBaseNavVC *)self.superVC.navigationController).gesture_enable = NO;
    [self.superVC.navigationController.view addSubview:self.bottomView];
    self.bottomView.frame = FRAME(0, HEIGHT - 49, WIDTH, WMShopCartBottomViewH);
    
    CGFloat height = 45 + 50 * (self.couDanArr.count+1);
    if (height > 45 + 50 * 6 ) {
        height = 45 + 50 * 6 ;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.backControl.hidden = NO;
        self.backControl.alpha = 1.0;
        
        [self.couDanBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = height;
        }];
        [self.superVC.navigationController.view layoutIfNeeded];
    }];
    [self.couDanTableView reloadData];

}

#pragma mark ------- 收起凑单购物车
-(void)hiddenCouDanTableView{

    ((JHBaseNavVC *)self.superVC.navigationController).gesture_enable = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.backControl.alpha = 0.0;
        [self.couDanBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
        }];
        [self.superVC.navigationController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self.backControl.hidden = YES;
        [self.view addSubview:self.bottomView];
        self.bottomView.frame = FRAME(0,0, WIDTH, WMShopCartBottomViewH);

    }];
    
}

#pragma mark ------- 购物车中的商品发生变化的处理
-(void)changeGoodCount:(WMShopGoodModel *)good is_add:(BOOL)is_add{
    self.shopCartGoodChange(good,is_add);
    [self.couDanTableView reloadData];
    if (self.is_showShopCartDetail && self.shopCartCount > 0) {
        [self showShopCartDetail];
    }
}

#pragma mark ------- 点击购物车
-(void)clickShopCartBtn{

    if (self.shopCartCount != 0) {
        if (!self.is_showShopCartDetail) {
            // 凑单展开时收起凑单
            if (self.is_showCouDanTable) {
                self.is_showCouDanTable = NO;
                ((JHBaseNavVC *)self.superVC.navigationController).gesture_enable = NO;
                [UIView animateWithDuration:0.25 animations:^{
                    [self.couDanBackView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.offset = 0;
                    }];
                    [self.superVC.navigationController.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [self showShopCartDetail];
                }];
                
            }else{
                [self showShopCartDetail];
            }
            
        }else{
            self.is_showShopCartDetail = NO;
            [self hiddenShopCartDetail];
        }
    }
}

#pragma mark ------- 展开购物车详情
-(void)showShopCartDetail{

    [_backControl removeTarget:self action:@selector(clickCouDan) forControlEvents:UIControlEventTouchUpInside];
    [_backControl addTarget:self action:@selector(clickShopCartBtn) forControlEvents:UIControlEventTouchUpInside];
    
    ((JHBaseNavVC *)self.superVC.navigationController).gesture_enable = NO;
    [self.superVC.navigationController.view addSubview:self.bottomView];
    self.bottomView.frame = FRAME(0, HEIGHT - 49, WIDTH, WMShopCartBottomViewH);

    CGFloat height = 45 + 50 * (self.dataSource.count+1) + self.shopCartBottomViewH ;
    if (height > 45 + 50 * 6 + self.shopCartBottomViewH ) {
        height = 45 + 50 * 6 + self.shopCartBottomViewH ;
    }
    
//    if (!self.is_showShopCartDetail) {
//        [self addCouDanBtnAnimation];
//    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backControl.hidden = NO;
        self.backControl.alpha = 1.0;
        [self.shopCartBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = height;
        }];
//        if (!self.is_showShopCartDetail) {
            [self.superVC.navigationController.view layoutIfNeeded];
//        }

    }];
    
   [self.shopCartTableView reloadData];
    self.is_showShopCartDetail = YES;
    
}

//-(void)addCouDanBtnAnimation{
//    [self.superVC.navigationController.view addSubview:self.ziTiBtn];
//    self.ziTiBtn.frame = FRAME(WIDTH - 80, HEIGHT- 49 - 40, 70, 40);
//
//    [self.ziTiBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset=-10;
//        make.bottom.equalTo(self.shopCartBackView.mas_top).offset=0;
//        make.width.offset=70;
//        make.height.offset=40;
//    }];
//}

#pragma mark ------- 收起购物车详情
-(void)hiddenShopCartDetail{
    self.is_showShopCartDetail = NO;
    ((JHBaseNavVC *)self.superVC.navigationController).gesture_enable = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.backControl.alpha = 0.0;
        [self.shopCartBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = WMShopCartBottomViewH;
        }];
        [self.superVC.navigationController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
       
        self.backControl.hidden = YES;
        [self.view addSubview:self.bottomView];
        self.bottomView.frame = FRAME(0,0, WIDTH, WMShopCartBottomViewH);
        [self.view addSubview:self.ziTiBtn];
        [self.ziTiBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-10;
            make.bottom.equalTo(self.couDanView.mas_top).offset=0;
            make.width.offset=70;
            make.height.offset=40;
        }];
    }];
}

#pragma mark ------- 清空购物车
-(void)clickClearShopCart{
    [JHShowAlert showAlertWithTitle:NSLocalizedString(@"是否要清空已选择商品", @"JHWMShopCartVC") withMessage:@"" withBtn_cancel:NSLocalizedString(@"取消",nil) withBtn_sure:NSLocalizedString(@"清空", @"JHWMShopCartVC") withController:self withCancelBlock:^{
        
    } withSureBlock:^{
        [self clearShopCart];
    }];
}

-(void)clearShopCart{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.shopCartCount = 0;
    });
    
    if (self.shopCartGoodChange) {
        self.shopCartGoodChange(nil,NO);
    }

}

#pragma mark ------- 设置起送价
-(void)setStartPrice:(NSString *)startPrice{
    _startPrice = startPrice;
    self.orderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
    
    if (self.isClosed) {
//        self.orderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
        [self.orderBtn setTitle:NSLocalizedString(@"已打烊", nil) forState:UIControlStateNormal];
    }else{
        if ([WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC) {
            [self.orderBtn setTitle:NSLocalizedString(@"选好了", @"JHWMShopCartVC") forState:UIControlStateNormal];
            
        }else{
           [self.orderBtn setTitle:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"¥", nil),startPrice,NSLocalizedString(@"起送", nil)] forState:UIControlStateNormal];
        }
    }
    
}

// 满减和首单后的金额
-(float)dealYouHuiMoney:(float)amount{
    
    __block float manjian_youhui_amount = 0;// 满足条件的最大的优惠

    WMShopModel * shopModel = [WMShopDBModel shareWMShopDBModel].shopModel;
    NSArray *arr = shopModel.manjian[@"config"];
    
    if (!self.have_choose_discount) {// 无折扣商品,考虑满减
        
        [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            float order_amount = [obj[@"order_amount"] floatValue];
            float coupon_amount = [obj[@"coupon_amount"] floatValue];
            
            if (amount >= order_amount) {
                if (manjian_youhui_amount <= coupon_amount) {
                    manjian_youhui_amount = coupon_amount;
                }
            }
        }];

    }
    
    amount = amount - manjian_youhui_amount;
   
    return amount > 0 ? amount : (self.dataSource.count > 0 ? 0.01 : 0);

}

// 处理凑单描述的显示
-(void)dealCouDanView:(float)amount youhui_amount:(float)youhui_amount qisong:(float)startPriceSub{
    
    WMShopModel *shop = [WMShopDBModel shareWMShopDBModel].shopModel;
    NSArray *arr = shop.manjian[@"config"];
    [arr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
        return [obj1[@"order_amount"] floatValue] > [obj2[@"order_amount"] floatValue];
    }];
    
    NSString *desStr = @"";
    NSString *man_jian_str = @"";       // 满减的条件
    NSString *first_man_jian_need = @"";       // 第一个满减还差多少钱
    NSString *next_man_jian_amount_str = @"";  // 下一个满减的需要的金额描述
    NSString *next_man_jian_amount = @"";  // 下一个满减的需要的金额
    NSString *start_price_sub = @"";    // 起送价差值
    NSString *youhui_str = @"";         // 优惠的金额
    
    // 优惠不为0
    if (![[NSString stringWithFormat:@"%g",youhui_amount] isEqualToString:@"0"]) {
        youhui_str = [NSString stringWithFormat: NSLocalizedString(@"已减¥%@", NSStringFromClass([self class])),[NSString getStrFromFloatValue:youhui_amount bitCount:2]];
        
    }

    if (self.dataSource.count == 0) {// 没选择商品的时候
        if (arr.count > 0) {
            for (NSInteger i=0; i<arr.count; i++) {
                // 最多显示三个
                if (i >= 3) break;
                NSDictionary *dic = arr[i];
                if (man_jian_str.length == 0) {
                   man_jian_str = [NSString stringWithFormat:@"满%@减%@",dic[@"order_amount"],dic[@"coupon_amount"]];
                }else{
                   man_jian_str = [NSString stringWithFormat:@"%@,满%@减%@",man_jian_str,dic[@"order_amount"],dic[@"coupon_amount"]];
                }
                
            }
        }
        
    }else{ // 有商品的时候

        // 没有达到起送价
        if (startPriceSub > 0) {
            start_price_sub = [NSString stringWithFormat: NSLocalizedString(@"还差¥%@起送,去凑单>", NSStringFromClass([self class])),[NSString getStrFromFloatValue:startPriceSub bitCount:2]];
            self.coudan_amount = startPriceSub;
        }else{ // 达到起送价
            
            
            if (!self.have_choose_discount) {// 无折扣商品,考虑满减
                
                NSDictionary *first_manjian_dic = arr.firstObject;
                
                // 没有满足第一个满减条件
                if (amount < [first_manjian_dic[@"order_amount"] floatValue]) {
                    float sub_amount  = [first_manjian_dic[@"order_amount"] floatValue] - amount;
                    self.coudan_amount = sub_amount;
                    
                    first_man_jian_need = [NSString stringWithFormat: NSLocalizedString(@"还差¥%@", NSStringFromClass([self class])),[NSString getStrFromFloatValue:sub_amount bitCount:2]];
                    
                    man_jian_str = [NSString stringWithFormat:@"满%@减%@,%@,去凑单>",first_manjian_dic[@"order_amount"],first_manjian_dic[@"coupon_amount"],first_man_jian_need];
                }else{
                    // 不用考虑共享问题
                    NSDictionary *nextYouHuiDic= nil;
                    for (NSInteger i=0; i<arr.count; i++) {
                        NSDictionary *subDic = arr[i];
                        if (amount < [subDic[@"order_amount"] floatValue]) {
                            nextYouHuiDic = subDic;
                            break;
                        }
                    }
                    if (nextYouHuiDic) {
                        float sub_amount = [nextYouHuiDic[@"order_amount"] floatValue] - amount;
                        self.coudan_amount = sub_amount;
                        next_man_jian_amount = [NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),[NSString getStrFromFloatValue:sub_amount bitCount:2]];
                        next_man_jian_amount_str = [NSString stringWithFormat: NSLocalizedString(@"再买¥%@减¥%@,去凑单>", NSStringFromClass([self class])),[NSString getStrFromFloatValue:sub_amount bitCount:2],nextYouHuiDic[@"coupon_amount"]];
                    }
                }

            }
            // 有折扣商品
            else man_jian_str = @"";

        }

    }

    
    if (man_jian_str.length != 0) desStr = man_jian_str;
    else desStr = youhui_str;
    
    NSMutableAttributedString *attStr = [NSString getAttributeString:desStr strAttributeDic:@{}].mutableCopy;

    
    if (next_man_jian_amount_str.length != 0){
        
        NSAttributedString * subAttStr = [NSString getAttributeString:next_man_jian_amount_str dealStr: next_man_jian_amount strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"FF725C", 1.0)}];
        if (attStr.length != 0) {
            [attStr insertAttributedString:[NSString getAttributeString:@"," strAttributeDic:@{}]    atIndex:attStr.length];
            [attStr insertAttributedString:subAttStr atIndex:attStr.length];
        }else [attStr insertAttributedString:subAttStr atIndex:attStr.length];
    }
    
    if (start_price_sub.length != 0){
        
        NSAttributedString * subAttStr = [NSString getAttributeString:start_price_sub strAttributeDic:@{}];
        subAttStr = [NSString addAttributeString:subAttStr dealStr:[NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),[NSString getStrFromFloatValue:startPriceSub bitCount:2]] strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"FF725C", 1.0)}];
        if (attStr.length != 0) {
            [attStr insertAttributedString:[NSString getAttributeString:@"," strAttributeDic:@{}]    atIndex:attStr.length];
            [attStr insertAttributedString:subAttStr atIndex:attStr.length];
//            desStr = [NSString stringWithFormat:@"%@,%@",desStr,start_price_sub];
        }else [attStr insertAttributedString:subAttStr atIndex:attStr.length];//desStr = start_price_sub;
    }
    NSLog(@"attStr   %@",attStr);
    
    if ([attStr.description containsString:NSLocalizedString(@"去凑单>", NSStringFromClass([self class]))]) {
        attStr = [NSString addAttributeString:attStr dealStr:NSLocalizedString(@"去凑单>", NSStringFromClass([self class])) strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"FF725C", 1.0)}].mutableCopy;
    }
    
    if (first_man_jian_need.length > 0) {
        attStr = [NSString addAttributeString:attStr dealStr:first_man_jian_need strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"FF725C", 1.0)}].mutableCopy;
        attStr = [NSString addAttributeString:attStr dealStr: NSLocalizedString(@"还差", NSStringFromClass([self class])) strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"333333", 1.0)}].mutableCopy;
    }
    
    self.couDanView.hidden = attStr.length == 0;
    self.couDanDesLab.attributedText = attStr;
    [self.couDanView mas_updateConstraints:^(MASConstraintMaker *make) {
        attStr.length == 0 ? make.height.offset(0) : make.height.offset(30);
    }];
}

#pragma mark ------- 设置商品总价
-(void)setAmount:(NSString *)amount{
    
    self.oldPriceLab.text = [NSString stringWithFormat: NSLocalizedString(@"¥%g", NSStringFromClass([self class])),[WMShopDBModel shareWMShopDBModel].all_amount];
    
    float money = [amount floatValue];
    money = [self dealYouHuiMoney:money];
    
    _amount = [NSString stringWithFormat:@"%g",money];
    
    NSLog(@"amount===  %g  all_amount=== %g",money,[WMShopDBModel shareWMShopDBModel].all_amount);
    
    // 浮点比较小数位数多的时候会存在不准确的问题
    BOOL equal = [_amount isEqualToString:[NSString stringWithFormat:@"%g",[WMShopDBModel shareWMShopDBModel].all_amount]];
    NSLog(@"%ld",equal);
    
    self.oldPriceLab.hidden = equal;//(money == [WMShopDBModel shareWMShopDBModel].all_amount);

    self.orderBtn.titleLabel.font = FONT(16);
    self.priceLab.attributedText = [NSString priceLabText:_amount attributeFont:16];
    
    if ([WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC) {
        self.ziTiBtn.hidden = YES;
        [self.orderBtn setTitle:NSLocalizedString(@"选好了", @"JHWMShopCartVC") forState:UIControlStateNormal];
        if ([amount floatValue] == 0) {
            self.orderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
        }else{
            self.orderBtn.backgroundColor = HEX(@"FF725C", 1.0);
        }
        
        if (self.isClosed) {
            self.orderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
            [self.orderBtn setTitle:NSLocalizedString(@"已打烊", nil) forState:UIControlStateNormal];
        }
        return;
    }
    
    if ([amount floatValue] == 0) {
        self.orderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
        [self.orderBtn setTitle:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"¥", nil),_startPrice,NSLocalizedString(@"起送", nil)] forState:UIControlStateNormal];
    }else if ([amount floatValue] < [self.startPrice floatValue]) {

        self.orderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
        NSString *str = [NSString getStrFromFloatValue:([self.startPrice floatValue] - [amount floatValue]) bitCount:2];
        [self.orderBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@",NSLocalizedString(@"差", @"JHWMShopCartVC"),NSLocalizedString(@"¥", nil),str,NSLocalizedString(@"起送", nil)] forState:UIControlStateNormal];
    }else{
        if (self.have_must && !self.is_choosed_must_good) {// 商家有必选商品 且 没选择必选商品
            self.orderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
            [self.orderBtn setTitle:NSLocalizedString(@"请选择必点商品", @"JHWMShopCartVC") forState:UIControlStateNormal];
            self.orderBtn.titleLabel.font = FONT(10);
        }else{
            self.orderBtn.backgroundColor = HEX(@"FF725C", 1.0);
            [self.orderBtn setTitle:NSLocalizedString(@"去结算", @"JHWMShopCartVC") forState:UIControlStateNormal];
        }
       
    }
    
    float qisong = ([self.startPrice floatValue] - [amount floatValue]);
    [self dealCouDanView:[amount floatValue] youhui_amount:([WMShopDBModel shareWMShopDBModel].all_amount  - money) qisong:qisong];
    
    if (self.isClosed) {
        self.orderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
        [self.orderBtn setTitle:NSLocalizedString(@"已打烊", nil) forState:UIControlStateNormal];
    }
}

#pragma mark ------- 设置购物车的数量
-(void)setShopCartCount:(int )shopCartCount{
    _shopCartCount = shopCartCount;
    shopCartCount = shopCartCount <= 0 ? 0 : shopCartCount;
    self.countLab.text = [NSString stringWithFormat:@"%d",shopCartCount];
    self.countLab.hidden = shopCartCount == 0 ? YES : NO;
    if (shopCartCount == 0) {
        [self hiddenShopCartDetail];
    }
    if (self.shopCartCountChange) {
        self.shopCartCountChange();
    }
}

#pragma mark ------- 计算商品的打包费
-(void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    float package_price = 0.0;
    self.is_choosed_must_good = NO;
    self.have_choose_discount = NO;
    
    for (WMShopGoodModel *good in dataSource) {
        if (good.is_must) {
            self.is_choosed_must_good = YES;
        }
        if (good.is_discount) {
            self.have_choose_discount = YES;
        }
        if (good.is_spec) {
            package_price += [good.spec_package_price floatValue] * good.good_choosedCount;
        }else{
            package_price += [good.package_price floatValue] * good.good_choosedCount;
        }
    }
    
    NSLog(@"%f",package_price);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString  alloc] initWithString:NSLocalizedString(@"餐盒费:  ", @"JHWMShopCartVC")];
    NSString *price = [NSString getStrFromFloatValue:package_price bitCount:2];
    [attStr appendAttributedString:[NSString priceLabText:price attributeFont:16]];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEX(@"ff6600", 1.0) range:NSMakeRange(4, attStr.length - 4)];
    self.package_price_lab.attributedText = attStr.copy;
    
    WMShopModel *shop = [WMShopDBModel shareWMShopDBModel].shopModel;
    
     #pragma mark ----- 自提的按钮的显示处理
    if (shop.can_zero_ziT) {
        if (shop.have_must) {
            if (self.shopCartCount > 0 && self.is_choosed_must_good) {
                //展示直接自提的view
                self.ziTiBtn.hidden = NO;
            }else{
                //展示直接自提的view
                self.ziTiBtn.hidden = YES;
            }
        }else{
            self.ziTiBtn.hidden = self.shopCartCount <= 0;
        }
    }
    
}

#pragma mark ------- 商品添加入购物车时的动画
-(void)cartBtnAnimation:(BOOL)is_add{

    if (is_add) {
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1)];
        transformAnimation.duration = .15f;
        [self.cartBtn.layer addAnimation:transformAnimation forKey:nil];
    }else{
    }
 
}

#pragma mark ------- 创建多人购物车
-(void)clickMoreShopCart{
    [self hiddenShopCartDetail];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.superVC presentToNextNaviVcWithVcName:@"JHMoreShopCartVCViewController" params:@{@"startPrice":self.startPrice,@"isClosed":@(self.isClosed),@"have_must":@(self.have_must),@"shopCartVC":self}];
    });
}

#pragma mark ====== 懒加载 =======
-(UIControl *)backControl{
    
    if (_backControl==nil) {
        _backControl=[[UIControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH,0)];
        _backControl.hidden = YES;
        _backControl.backgroundColor = HEX(@"000000", 0.4);
        _backControl.alpha = 0.0;
    }
    return _backControl;
}

-(void)dealloc{
    [self.backControl removeFromSuperview];
    _backControl = nil;
}

@end
