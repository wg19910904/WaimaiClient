//
//  JHMoreShopCartVCViewController.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/18.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHMoreShopCartVCViewController.h"
#import "YFTypeBtn.h"
#import "NSString+Tool.h"
#import "WMMoreShopCartCell.h"
#import "JHShowAlert.h"
#import "ShowEmptyDataView.h"

@interface JHMoreShopCartVCViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,assign)NSInteger current_changedShopCartNum; // -1 代表没有修改任何一个购物车
@property(nonatomic,strong)NSArray *originalArr;// 第一次进来时的数组,用于处理一个购物车都没有的情况
@property(nonatomic,weak)UIButton *calculateOrderBtn;
@property(nonatomic,strong)UIView *zitiView;
@end

@implementation JHMoreShopCartVCViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [WMShopDBModel shareWMShopDBModel].current_shopcartNum = 0;
    [self dealMoney];
    [self dealShopDB];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    
    self.current_changedShopCartNum = 0;
    self.shop_id = [WMShopDBModel shareWMShopDBModel].shop_id;
    JHWMShopCartModel *model = [[JHWMShopCartModel alloc] init];
    model.choosedGoodsArr = [[WMShopDBModel shareWMShopDBModel].choosedGoodsArr copy];
    model.shopcartNum = 1;
    model.shopcartName =  [NSString stringWithFormat:@"%d%@",model.shopcartNum,NSLocalizedString(@"号篮子", NSStringFromClass([self class]))];
    [self.dataSource addObject:model];
    [self.tableView reloadData];
    
    _originalArr = model.choosedGoodsArr;
    
    [NoticeCenter addObserver:self selector:@selector(needToDismiss) name:WMCreateOrderSuccess object:nil];
}

-(void)needToDismiss{
    [self.shopCartVC needPopToRootVC];
}
-(void)setUpView{
    
    [self createBackBtn];
    self.backBtnImgName = @"nav_btn_close";
    self.navigationItem.title = NSLocalizedString(@"多人订餐", NSStringFromClass([self class]));
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT + 80, WIDTH, HEIGHT - NAVI_HEIGHT - 80 - 49) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;

    [self createTopView];
    [self createBottomView];
    
    if ([WMShopDBModel shareWMShopDBModel].is_can_zero_ziti) {
        [self makeZitiView];
    }
    
}

-(void)createTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, 80)];
    [self.view addSubview:topView];
    topView.backgroundColor = HEX(@"f7f7f7", 1.0);
    
    UILabel *lab = [UILabel new];
    [topView addSubview: lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(0);
        make.height.offset(20);
    }];
    lab.text = NSLocalizedString(@"商家可按篮子分开打包商品", NSStringFromClass([self class]));
    lab.font = FONT(12);
    lab.textColor = HEX(@"999999", 1.0);
    
    YFTypeBtn *addBtn = [YFTypeBtn new];
    [topView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.bottom.offset(-10);
        make.right.offset(-12);
        make.height.offset(44);
    }];
    addBtn.layer.cornerRadius=2;
    addBtn.clipsToBounds=YES;
    addBtn.backgroundColor = HEX(@"ffffff", 1.0);
    addBtn.btnType = NormalType;
    addBtn.titleMargin = 5;
    [addBtn setImage:IMAGE(@"shopcart_add") forState:UIControlStateNormal];
    [addBtn setTitle: NSLocalizedString(@"  添加篮子", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [addBtn setTitleColor:HEX(@"20ad20", 1.0) forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(clickAddShopCart) forControlEvents:UIControlEventTouchUpInside];
    addBtn.titleLabel.font = FONT(16);

}

-(void)createBottomView{
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor =HEX(@"ffffff", 1.0);
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.bottom.offset(0);
        make.height.offset(49);
    }];
    
    UILabel *priceLab = [UILabel new];
    [bottomView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.top.offset(8);
        make.height.offset(20);
    }];
    priceLab.textColor = HEX(@"ff3300", 1.0);
    priceLab.font = FONT(12);
    self.priceLab = priceLab;
    
    UILabel *desLab = [UILabel new];
    [bottomView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.bottom.offset(-8);
        make.height.offset(13);
    }];
    desLab.font = FONT(12);
    desLab.textColor = HEX(@"999999", 1.0);
    desLab.text =  NSLocalizedString(@"配送费以订单为准", NSStringFromClass([self class]));
    
    UIButton *calculateOrderBtn = [UIButton new];
    [bottomView addSubview:calculateOrderBtn];
    [calculateOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(0);
        make.width.offset(115);
        make.height.offset(49);
    }];
    calculateOrderBtn.backgroundColor = HEX(@"FF725C", 1.0);
    calculateOrderBtn.titleLabel.font = FONT(16);
    [calculateOrderBtn setTitle: NSLocalizedString(@"去结算", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [calculateOrderBtn setTitleColor:HEX(@"ffffff", 1.0) forState:UIControlStateNormal];
    [calculateOrderBtn addTarget:self action:@selector(createOrder) forControlEvents:UIControlEventTouchUpInside];
    self.calculateOrderBtn = calculateOrderBtn;
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
    if (self.dataSource.count == 0) {
        
        NSAttributedString *attr = [NSString getAttributeString:NSLocalizedString(@"还没有添加篮子\n\n赶紧去添加吧", NSStringFromClass([self class])) dealStr:NSLocalizedString(@"还没有人订餐", NSStringFromClass([self class])) strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"4d4d4d", 1.0)}];
        attr = [NSString addAttributeString:attr dealStr:NSLocalizedString(@"赶紧去添加吧", NSStringFromClass([self class])) strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"999999", 1.0),NSFontAttributeName : FONT(12)}];
//        attr = [NSString addParagraphStyleAttributeStrWithAttributeStr:attr lineSpacing:5];
        [self showEmptyViewWithImgName:@"no_person" desAttrStr:attr btnTitle:nil inView:tableView];
        return 0;
    }
    [self hiddenEmptyView];
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf=self;
    
    WMMoreShopCartCell *cell = [WMMoreShopCartCell initWithTableView:tableView reuseIdentifier:@"WMMoreShopCartCell"];
    JHWMShopCartModel * model = self.dataSource[indexPath.row];
    [cell reloadCellWithModel:model];
    cell.clickActionBlock = ^(BOOL success, NSString *msg) {
        if ([msg isEqualToString:@"edit"]) {
            [weakSelf editCartNameWithIndexPath:indexPath.row];
        }
        if ([msg isEqualToString:@"change"]) {
            [weakSelf changeCartGoodWithIndexPath:indexPath.row];
        }
        if ([msg isEqualToString:@"delete"]) {
            [weakSelf deleteCartWithIndexPath:indexPath.row];
        }
        
    };
    return cell;
}

#pragma mark ====== Functions =======
// 点击返回
-(void)clickBackBtn{
    [JHShowAlert showAlertWithTitle: NSLocalizedString(@"确认退出", NSStringFromClass([self class])) withMessage: NSLocalizedString(@"退出订餐后,选购商品会被清空,将无法继续使用多人订餐", NSStringFromClass([self class])) withBtn_cancel: NSLocalizedString(@"取消", NSStringFromClass([self class])) withBtn_sure: NSLocalizedString(@"退出", NSStringFromClass([self class])) withController:self withCancelBlock:^{
        
    } withSureBlock:^{
        
        JHWMShopCartModel *model;
        for (NSInteger i=0; i<self.dataSource.count; i++) {
            JHWMShopCartModel *subModel = self.dataSource[i];
            if(subModel.choosedGoodsArr.count > 0){
                // 最后一次修改的购物车(且没有被删除)的数据
                if (subModel.shopcartNum == self.current_changedShopCartNum) {
                    model = subModel;
                    break;
                }else{ // 没有找到最后一次修改的购物车的数据
                    model = model ? model : subModel;
                }
            }
        }
        
        if (!model) {
          [NoticeCenter postNotificationName:QuitMoreShopCart object:@{@"goodArr":_originalArr}];
        }else{
            [NoticeCenter postNotificationName:QuitMoreShopCart object:@{@"goodArr":model.choosedGoodsArr}];
        }
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

// 增加订餐人
-(void)clickAddShopCart{
    JHWMShopCartModel *model = [[JHWMShopCartModel alloc] init];
    model.choosedGoodsArr = @[];
    if (self.dataSource.count == 0) model.shopcartNum = 1;
    else{
        JHWMShopCartModel *firstShopcart = self.dataSource.firstObject;
        model.shopcartNum = firstShopcart.shopcartNum + 1;
    }

    model.shopcartName =  [NSString stringWithFormat:@"%d%@",model.shopcartNum,NSLocalizedString(@"号篮子", NSStringFromClass([self class]))];
    [self.dataSource insertObject:model atIndex:0];
    [self.tableView reloadData];
}

// 修改购物车的商品
-(void)changeCartGoodWithIndexPath:(NSInteger)row{
    
     __weak typeof(self) weakSelf=self;
    
    JHWMShopCartModel *model = self.dataSource[row];
    [WMShopDBModel shareWMShopDBModel].current_shopcartNum = model.shopcartNum;
    [WMShopDBModel shareWMShopDBModel].all_amount = 0;
    
    // 多人团购确认选好了
    [WMShopDBModel shareWMShopDBModel].sureChooseBlock = ^(BOOL sure, NSString *msg) {
        if (sure) {
            model.choosedGoodsArr = [[WMShopDBModel shareWMShopDBModel].current_shopcart_choosedGoodsArr copy];
            weakSelf.current_changedShopCartNum = model.shopcartNum;
        }
        [[WMShopDBModel shareWMShopDBModel] deleteAllGoodsWith:weakSelf.shop_id];
       
        [weakSelf.tableView reloadData];
    };
    
    NSMutableArray *arr = [NSMutableArray array];
    for (WMShopGoodModel *good in model.choosedGoodsArr) {
        [arr addObject:@{
                         @"cate_id" : good.cate_id,
                         @"specification":good.choosed_proprety,
                         @"package_price" : (good.is_spec ? good.spec_package_price : good.package_price),
                         @"product_id" : good.product_id,
                         @"product_name" : good.title,
                         @"cate_str" : good.cate_str,
                         @"product_number" : @(good.good_choosedCount),
                         @"product_price" : (good.is_spec ? good.choosedSize_price : good.price),
                         @"spec_id" : (good.choosedSize_id.length > 0 ? good.choosedSize_id : @""),
                         @"spec_name" : (good.choosedSize_Name.length > 0 ? good.choosedSize_Name : @""),
                         @"is_discount" : @(good.is_discount),
                         @"oldprice" : good.oldprice,
                         @"diffprice" : @(good.diffprice),
                         @"disclabel" : (good.disclabel.length > 0 ? good.disclabel : @""),
                         @"quotalabel" : (good.quotalabel.length > 0 ? good.quotalabel : @""),
                         @"current_shopcart_choosedCount" : @(good.current_shopcart_choosedCount > 0 ? good.current_shopcart_choosedCount  : good.good_choosedCount)
                         }];
        
    }
    [self presentToNextNaviVcWithVcName:@"JHWaiMaiShopDetailVC"  params:@{@"shop_id":self.shop_id,@"onceAgainProductsArr":arr}];
    
}

// 删除购物车
-(void)deleteCartWithIndexPath:(NSInteger)row{
    
    [JHShowAlert showAlertWithTitle: NSLocalizedString(@"篮子被删除后不可恢复哟", NSStringFromClass([self class])) withMessage: nil withBtn_cancel: NSLocalizedString(@"取消", NSStringFromClass([self class])) withBtn_sure: NSLocalizedString(@"确认删除", NSStringFromClass([self class])) withController:self withCancelBlock:^{
        
    } withSureBlock:^{
        [self.dataSource removeObjectAtIndex:row];
        [self.tableView reloadData];
        [self dealMoney];
    }];
    
}

// 修改购物车的名字
-(void)editCartNameWithIndexPath:(NSInteger)row{
    
    JHWMShopCartModel *model = self.dataSource[row];
    
    [JHShowAlert showTextFieldAlertWithTitle: NSLocalizedString(@"修改名称", NSStringFromClass([self class])) withPlaceholder: NSLocalizedString(@"请输入名称", NSStringFromClass([self class])) withBtn_cancel: NSLocalizedString(@"取消", NSStringFromClass([self class])) withBtn_sure: NSLocalizedString(@"确定", NSStringFromClass([self class])) withController:self withCancelBlock:^{
        
    } withSureBlock:^(NSString *name) {
        model.shopcartName = name;
        [self.tableView reloadData];
    }];
}

// 创建订单
-(void)createOrder{
    if (![JHUserModel shareJHUserModel].isLogin) {
        [NoticeCenter postNotificationName:LOGIN_NoticeName object:nil];
        return;
    }
    
    NSString *str;
    for (NSInteger i=0; i<self.dataSource.count; i++) {
        JHWMShopCartModel *shopCart = self.dataSource[self.dataSource.count - 1 - i];
        if (shopCart.choosedGoodsArr.count > 0) {
            if (str.length == 0) {
                str = shopCart.products_str;
            }else{
                str = [str stringByAppendingString:[NSString stringWithFormat:@",%@",shopCart.products_str]];
            }
        }
    }

    [WMShopDBModel shareWMShopDBModel].moreShopCartProductStr = str;
    [self pushToNextVcWithVcName:@"JHWMCreateOrderVC" params:@{@"shop_id":self.shop_id}];
}

// 处理价格和商品相关的问题
-(void)dealMoney{
    NSMutableArray *allGoodArr = [NSMutableArray array];
    for (JHWMShopCartModel *model in self.dataSource) {
        [allGoodArr addObjectsFromArray:model.choosedGoodsArr];
    }
    
    float amount = 0;
    NSArray *sortArr = [allGoodArr sortedArrayUsingComparator:^NSComparisonResult(WMShopGoodModel * good1, WMShopGoodModel * good2) {
        return good1.diffprice < good2.diffprice;
    }];

    BOOL is_choosed_must = NO; // 是否选择了必点商品

    for (WMShopGoodModel *good in sortArr) {
        if (good.is_must) is_choosed_must = YES;
        float current_price = 0;
        int choosed_count = good.current_shopcart_choosedCount == 0 ? good.good_choosedCount : good.current_shopcart_choosedCount;
        for (NSInteger i=0; i<choosed_count; i++) {// 一个一个算价格
            if (good.is_spec) {
                amount += [good.oldprice floatValue] + [good.spec_package_price floatValue];
                current_price += [good.oldprice floatValue];
            }else{
                amount += [good.oldprice floatValue] + [good.package_price floatValue];
                current_price += [good.oldprice floatValue];
            }
        }
    }

    NSString *money = [NSString stringWithFormat:@"%g",amount];
    self.priceLab.attributedText = [NSString priceLabText:money attributeFont:16];
    
    self.calculateOrderBtn.userInteractionEnabled = NO;
    self.calculateOrderBtn.titleLabel.font = FONT(16);
    if (amount == 0) {
        self.calculateOrderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
        [self.calculateOrderBtn setTitle:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"¥", nil),_startPrice,NSLocalizedString(@"起送", nil)] forState:UIControlStateNormal];
    }else if (amount  < [self.startPrice floatValue]) {

        self.calculateOrderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
        NSString *str = [NSString getStrFromFloatValue:([self.startPrice floatValue] - amount) bitCount:2];
        [self.calculateOrderBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@",NSLocalizedString(@"差", @"JHWMShopCartVC"),NSLocalizedString(@"¥", nil),str,NSLocalizedString(@"起送", nil)] forState:UIControlStateNormal];
    }else{
        if (self.have_must && !is_choosed_must) {// 商家有必选商品 且 没选择必选商品
            self.calculateOrderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
            [self.calculateOrderBtn setTitle:NSLocalizedString(@"请选择必点商品", @"JHWMShopCartVC") forState:UIControlStateNormal];
            self.calculateOrderBtn.titleLabel.font = FONT(10);
        }else{
            self.calculateOrderBtn.backgroundColor = HEX(@"FF725C", 1.0);
            [self.calculateOrderBtn setTitle:NSLocalizedString(@"去结算", @"JHWMShopCartVC") forState:UIControlStateNormal];
            self.calculateOrderBtn.userInteractionEnabled = YES;
        }

    }

    if (self.isClosed) {
        self.calculateOrderBtn.backgroundColor = HEX(@"aaaaaa", 1.0);
        [self.calculateOrderBtn setTitle:NSLocalizedString(@"已打烊", nil) forState:UIControlStateNormal];
    }

    
    [self handleZitiView:(allGoodArr.count > 0)];
}

// 数据库的处理方便创建订单
-(void)dealShopDB{
    NSMutableArray *arr = [NSMutableArray array];
    for (JHWMShopCartModel *model in self.dataSource) {
        [arr addObjectsFromArray:model.choosedGoodsArr];
    }
    NSMutableArray *goodArr = [NSMutableArray array];
    for (WMShopGoodModel *good in arr) {
        [goodArr addObject:@{
                         @"cate_id" : good.cate_id,
                         @"specification":good.choosed_proprety,
                         @"package_price" : (good.is_spec ? good.spec_package_price : good.package_price),
                         @"product_id" : good.product_id,
                         @"product_name" : good.title,
                         @"cate_str" : good.cate_str,
                         @"product_number" : @(good.good_choosedCount),
                         @"product_price" : (good.is_spec ? good.choosedSize_price : good.price),
                         @"spec_id" : (good.choosedSize_id.length > 0 ? good.choosedSize_id : @""),
                         @"spec_name" : (good.choosedSize_Name.length > 0 ? good.choosedSize_Name : @""),
                         @"is_discount" : @(good.is_discount),
                         @"oldprice" : good.oldprice,
                         @"diffprice" : @(good.diffprice),
                         @"disclabel" : (good.disclabel.length > 0 ? good.disclabel : @""),
                         @"quotalabel" : (good.quotalabel.length > 0 ? good.quotalabel : @""),
                         @"current_shopcart_choosedCount" : @(good.current_shopcart_choosedCount > 0 ? good.current_shopcart_choosedCount  : good.good_choosedCount)
                         }];
        
    }
    
}

#pragma mark 展示直接自提的view
-(void)makeZitiView{
    _zitiView = [UIView new];
    _zitiView.hidden = YES;
    _zitiView.backgroundColor = HEX(@"fff0d1", 0.93);
    [self.view addSubview:_zitiView];
    [_zitiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 32;
        make.bottom.offset = -49;
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToZiti)];
    _zitiView.userInteractionEnabled = YES;
    [_zitiView addGestureRecognizer:tap];
    //展示自提无须达到起送价
    UILabel *lab = [UILabel new];
    lab.text = NSLocalizedString(@"自提无须达到起送价",nil);
    lab.textColor = HEX(@"404040", 1);
    lab.font = FONT(12);
    [_zitiView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_zitiView.mas_centerY);
        make.centerX.mas_equalTo(_zitiView.mas_centerX).offset = -50*SCALE;
        make.height.offset = 15;
    }];
    //展示去自提的
    YFTypeBtn *btn = [YFTypeBtn new];
    btn.btnType = RightImage;
    btn.enabled = NO;
    btn.imageMargin = 7;
    [btn setTitle:NSLocalizedString(@"去自提",nil) forState:UIControlStateNormal];
    [btn setTitleColor:HEX(@"ff6600", 1) forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(14);
    [btn setImage:IMAGE(@"btn_arrowR_orange") forState:UIControlStateNormal];
    [_zitiView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lab.mas_right).offset = 15;
        make.height.offset = 15;
        make.centerY.mas_equalTo(_zitiView.mas_centerY);
        make.width.offset = 70;
    }];
}

#pragma makr - 点击去自提的方法
-(void)clickToZiti{
    NSLog(@"点击了去自提");
    
    if (![JHUserModel shareJHUserModel].isLogin) {
        [NoticeCenter postNotificationName:LOGIN_NoticeName object:nil];
        return;
    }
    
    NSString *str;
    for (NSInteger i=0; i<self.dataSource.count; i++) {
        JHWMShopCartModel *shopCart = self.dataSource[self.dataSource.count - 1 - i];
        if (shopCart.choosedGoodsArr.count > 0) {
            if (str.length == 0) {
                str = shopCart.products_str;
            }else{
                str = [str stringByAppendingString:[NSString stringWithFormat:@",%@",shopCart.products_str]];
            }
        }
    }
    
    [WMShopDBModel shareWMShopDBModel].moreShopCartProductStr = str;
    [self pushToNextVcWithVcName:@"JHWMCreateOrderVC" params:@{@"shop_id":self.shop_id,@"isZiti":@"1"}];
//
//    [self pushToNextVcWithVcName:@"JHWMCreateOrderVC" params:@{@"shop_id":self.shop_id,@"moreShopCartProductStr":@"adsfasd",@"isZiti":@"1"}];
    
}


-(void)handleZitiView:(BOOL)have_good{

    if (have_good) {
        //展示直接自提的view
        _zitiView.hidden = NO;
    }else{
        //展示直接自提的view
        _zitiView.hidden = YES;
    }
    
}

#pragma mark ====== 懒加载 =======
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
