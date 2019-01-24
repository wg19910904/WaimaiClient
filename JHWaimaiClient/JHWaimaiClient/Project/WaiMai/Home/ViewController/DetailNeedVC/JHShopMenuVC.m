//
//  JHShopMenuVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHShopMenuVC.h"
#import "WMShopMenuCateCell.h"
#import "WMShopGoodCell.h"
#import "NSString+Tool.h"
#import "JHWMShopCartVC.h"
#import "WMShopModel.h"
#import "JHWMChooseSizeGoodPropertyVC.h"
#import "JHWMShopGoodDetailVC.h"
#import "JHView.h"
#import "JHWMCreateOrderVC.h"
#import "JHWMShowChangeGoodsVC.h"
#import "YFTypeBtn.h"
#import "AppDelegate.h"
#import "JHShopMenuTableHeaderView.h"

@interface JHShopMenuVC ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>
@property(nonatomic,assign)BOOL is_selected_left;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)WMShopDBModel *shopDBModel;
@property(nonatomic,weak)JHWMShopGoodDetailVC *goodDetailVC;

@end

@implementation JHShopMenuVC

-(void)loadView{
    
    self.view = [[JHView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    [self setUpView];
    [NoticeCenter addObserver:self selector:@selector(tableViewScrollsToTop) name:ScrollToTop object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.shopCartVC.superVC = self;
    [self addChildViewController:self.shopCartVC];
    [self dealShopCartData];

}

-(void)dealloc{
    UIViewController *vc = [(AppDelegate *)[UIApplication sharedApplication].delegate topViewController];
    if (![vc isKindOfClass:NSClassFromString(@"JHWaiMaiShopDetailVC")] && ![WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC) {
        [self.shopDBModel clearData];
    }
    
    [WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC = NO;
    
    Remove_Notice
}

-(void)setUpView{
     __weak typeof(self) weakSelf=self;
    JHWMShopTuiJianView *view = [[JHWMShopTuiJianView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    [self.view addSubview:view];
    self.tuiJianView = view;
    view.goodCountChangeBlock = ^(WMShopGoodModel* model, BOOL is_add) {
        [weakSelf dealTuiJianGoodCountChange:model is_add:is_add];
    };
    
    view.goShopDetailBlock = ^(id model, NSString *msg) {
        JHWMShopGoodDetailVC *detail = [JHWMShopGoodDetailVC new];
        detail.shopModel = weakSelf.shopModel;
        detail.good = model;
        detail.shopCartVC = weakSelf.shopCartVC;
        detail.shopMenuVC = weakSelf;
        weakSelf.goodDetailVC = detail;
        [weakSelf.superVC.navigationController pushViewController:detail animated:YES];
    };
    
    [NoticeCenter addObserver:self selector:@selector(quitMoreShopCart:) name:@"QuitMoreShopCart" object:nil];
    
    UITableView *leftTableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH * 0.25, HEIGHT) style:UITableViewStylePlain];
    leftTableView.delegate=self;
    leftTableView.dataSource=self;
    leftTableView.separatorInset = UIEdgeInsetsZero;
    leftTableView.separatorColor = LINE_COLOR;
    leftTableView.layoutMargins = UIEdgeInsetsZero;
    leftTableView.backgroundColor=BACK_COLOR;
    leftTableView.showsVerticalScrollIndicator=NO;
    leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH *0.75, 40)];
    leftTableView.scrollsToTop = NO;
//    leftTableView.estimatedRowHeight = 100;
//    leftTableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:leftTableView];
    self.leftTableView=leftTableView;
    [leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(view.mas_bottom).offset=0;
        make.width.offset=WIDTH *0.25;
        make.bottom.offset= -49;
    }];
    [leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    UITableView *rightTableView=[[UITableView alloc] initWithFrame:FRAME(WIDTH * 0.75, 0, WIDTH * 0.6, HEIGHT) style:UITableViewStylePlain];
    rightTableView.delegate=self;
    rightTableView.dataSource=self;
    rightTableView.backgroundColor=BACK_COLOR;
    rightTableView.showsVerticalScrollIndicator=NO;
    rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH *0.75, 40)];
    rightTableView.scrollsToTop = YES;
    rightTableView.scrollEnabled = NO;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    rightTableView.estimatedRowHeight = 100;
//    rightTableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:rightTableView];
    self.tableView=rightTableView;
    [rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=WIDTH *0.25;
        make.top.equalTo(view.mas_bottom).offset=0;
        make.width.offset=WIDTH *0.75;
        make.bottom.offset= -49;
    }];
    
    JHWMShopCartVC *shopCartVC = [[JHWMShopCartVC alloc] init];
    shopCartVC.superVC = self.superVC;
    [self addChildViewController:shopCartVC];
    [self.view addSubview:shopCartVC.view];
    [shopCartVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.right.offset= 0;
        make.height.offset=49;
    }];
    self.shopCartVC = shopCartVC;
    
#pragma mark ======购物车凑一凑的处理=======
    ((JHView *)self.view).willToHitView = shopCartVC.ziTiBtn;
#pragma mark ======购物车方法的回调=======
    shopCartVC.shopCartGoodChange =^(WMShopGoodModel *good, BOOL is_add){
        [weakSelf.shopCartVC cartBtnAnimation:is_add];
        [weakSelf dealWithProductCountChange:good is_add:is_add];
        if (weakSelf.goodDetailVC) {
            [weakSelf.goodDetailVC.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    
#pragma mark ====== 下单处理 =======
    shopCartVC.createOrder = ^(BOOL choose_must_good) {
        if (choose_must_good) {
            [weakSelf scrollToMustGood];
        }else{
            if([WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC){
                if ([WMShopDBModel shareWMShopDBModel].sureChooseBlock) {
                    [WMShopDBModel shareWMShopDBModel].sureChooseBlock(YES,@"");
                }
                [weakSelf.superVC dismissViewControllerAnimated:YES completion:nil];
            }else{
               [weakSelf createOrder];
            }
           
        }
    };
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.tableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
//    if (tableView == self.tableView) {
//        NSNumber *height = @(cell.frame.size.height);
//        [self.heightAtIndexPath setObject:height forKey:indexPath];
//    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_shopModel.cateArr.count == 0) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr:nil btnTitle:nil inView:self.view];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hiddenEmptyView];
        });
    }
    if (tableView == self.tableView) {
        return _shopModel.cateArr.count;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return [[_shopModel.cateArr[section] products] count];
    }else{
        return _shopModel.cateArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        
        static NSString *ID=@"WMShopGoodCell";
        WMShopGoodCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WMShopGoodCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        NSArray *goodArr = [self.shopModel.cateArr[indexPath.section] products] ;
        WMShopGoodModel *good = goodArr[indexPath.row];
        [cell reloadCellWithModel:good];
        
        if (self.good_id.length > 0) {// 选中商品进来的处理
            if ([[self.shopModel.cateArr[indexPath.section] cate_id] isEqualToString:@"hot"] && [good.product_id isEqualToString:self.good_id]) {
                cell.titleLab.textColor = THEME_COLOR_Alpha(1.0);
            }else{
                cell.titleLab.textColor = HEX(@"333333", 1.0);
            }
        }
        
        __weak typeof(self) weakSelf=self;
        cell.productNumChange = ^(UIView *fromView){ // fromView不为nil 添加商品
            [weakSelf dealWithChooseProduct:fromView indexPath:indexPath];
        };
        cell.chooseGoodSize = ^{
            [weakSelf chooseSizeGood:indexPath];
        };
        return cell;
        
    }else{
        static NSString *ID=@"WMShopMenuCateCell";
        WMShopMenuCateCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WMShopMenuCateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        WMShopCateModel *cate = self.shopModel.cateArr[indexPath.row];
        [cell reloadCellWithModel:cate];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        NSArray *goodArr = [self.shopModel.cateArr[indexPath.section] products] ;
        WMShopGoodModel *good = goodArr[indexPath.row];
        
        CGFloat titleH = getStrHeight(good.title, WIDTH * 0.75 - 115 -10, 16);
        if (good.intro.length != 0) titleH += 25;
        if (good.is_discount) titleH += (5 + 16);
        titleH = titleH + 10 + 25 + 40;
        return MAX(titleH, 120);
    }else{
        return 50;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 40;
    }else{
        return CGFLOAT_MIN;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        view.backgroundColor = HEX(@"ffffff", 1.0);
        UILabel *titleLab = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH, 40)];
        [view addSubview:titleLab];
        titleLab.font = FONT(12);
        titleLab.textColor = HEX(@"333333", 1.0);
        WMShopCateModel *cate = self.shopModel.cateArr[section];
        titleLab.text = cate.title;
//        UILabel *lab = [[UILabel alloc]init];
//        lab.backgroundColor = THEME_COLOR_Alpha(1);
//        lab.frame = FRAME(3, 11, 3, 18);
//        [view addSubview:lab];
        return view;
        
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        self.is_selected_left = YES;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        NSArray *goodArr = [self.shopModel.cateArr[indexPath.section] products] ;
        WMShopGoodModel *good = goodArr[indexPath.row];
        JHWMShopGoodDetailVC *detail = [JHWMShopGoodDetailVC new];
        detail.shopModel = self.shopModel;
        detail.good = good;
        detail.shopCartVC = self.shopCartVC;
        detail.shopMenuVC = self;
        self.goodDetailVC = detail;
        [self.superVC.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark ====== ScrollViewDidScroll =======
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView && !self.is_selected_left) {
        
        NSArray * arr = [self.tableView indexPathsForRowsInRect:scrollView.bounds];
        if (arr.count == 0) {
            return;
        }
        if (self.leftTableView.indexPathForSelectedRow.row != [arr.firstObject section] ) {
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[arr.firstObject section] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        
        self.tableView.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.userInteractionEnabled = YES;
        });
    }
 
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        self.is_selected_left = NO;
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        self.is_selected_left = NO;
    }
}

// 通知的方法
-(void)tableViewScrollsToTop{
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

// 计算tableView需要补齐的高度
- (CGFloat)automaticHeightForTableView:(UITableView *)tableView{
    
    CGFloat height = tableView.contentSize.height;
    if (height >= tableView.frame.size.height) {
        return 0.0001;
    }
    return tableView.frame.size.height - height;
}

#pragma mark ====== Functions =======
#pragma mark ====== 处理推荐商品的数量变化 =======
-(void)dealTuiJianGoodCountChange:(WMShopGoodModel *)good is_add:(BOOL)is_add{

    if (good.is_spec || good.is_specification) {
        __weak typeof(self) weakSelf=self;
        JHWMChooseSizeGoodPropertyVC *chooseSizeVC = [JHWMChooseSizeGoodPropertyVC new];
        chooseSizeVC.good = good;
        [self.superVC presentViewController:chooseSizeVC animated:YES
                                 completion:nil];
        chooseSizeVC.goodCountChange = ^(BOOL is_add){
            [weakSelf dealWithProductCountChange:good is_add:is_add];
        };
    }else{
        [self dealWithProductCountChange:good is_add:is_add];
    }
    
}

#pragma mark --------- 处理多人购物车取消时的购物车变化
-(void)quitMoreShopCart:(NSNotification *)noti{
    
    [self.shopDBModel deleteAllGoodsWith:self.shopModel.shop_id];
    for (WMShopCateModel *cate in self.shopModel.cateArr) {
        cate.cate_choosedCount = 0;
    }
    
    NSArray *goodArr = noti.object[@"goodArr"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (WMShopGoodModel *good in goodArr) {
        [arr addObject:@{
                         @"cate_id" : good.cate_id,
                         @"specification":good.choosed_proprety,
                         @"package_price" : (good.is_spec ? good.spec_package_price : good.package_price),
                         @"product_id" : good.product_id,
                         @"product_name" : good.title,
                         @"cate_str" : good.cate_str,
                         @"product_number" : @(good.current_shopcart_choosedCount > 0 ? good.current_shopcart_choosedCount : good.good_choosedCount),
                         @"product_price" : (good.is_spec ? good.choosedSize_price : good.price),
                         @"spec_id" : (good.choosedSize_id.length > 0 ? good.choosedSize_id : @""),
                         @"spec_name" : (good.choosedSize_Name.length > 0 ? good.choosedSize_Name : @""),
                         @"is_discount" : @(good.is_discount),
                         @"oldprice" : good.oldprice,
                         @"diffprice" : @(good.diffprice),
                         @"disclabel" : (good.disclabel.length > 0 ? good.disclabel : @""),
                         @"quotalabel" : (good.quotalabel.length > 0 ? good.quotalabel : @""),
                         @"current_shopcart_choosedCount" : @(0)
                         }];
        
    }
    self.onceAgainProductsArr = arr.copy;
    [self dealShopDataWithDBAndQuitMoreShopCart:YES];
    
}

#pragma mark  ------- 选择必选商品
-(void)scrollToMustGood{
    if (![self.navigationController.topViewController isKindOfClass:NSClassFromString(@"JHWaiMaiShopDetailVC")]) {
        [self.navigationController popToViewController:self.superVC animated:YES];
    }
    NSInteger section = 0;
    for (WMShopCateModel *cate in self.shopModel.cateArr) {
        if ([cate.cate_id isEqualToString:@"must"]) {
            section = [self.shopModel.cateArr indexOfObject:cate];
            break;
        }
    }
    [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 创建订单
-(void)createOrder{
    
    if (![JHUserModel shareJHUserModel].isLogin) {
        [NoticeCenter postNotificationName:LOGIN_NoticeName object:nil];
        return;
    }
    
    JHWMCreateOrderVC *order = [JHWMCreateOrderVC new];
    order.shop_id = self.shopModel.shop_id;
    [self.superVC.navigationController pushViewController:order animated:YES];
}

#pragma mark  ------- 选择商品处理
// 获取数据
-(void)setShopModel:(WMShopModel *)shopModel{
   
    
    self.shopCartVC.isClosed = shopModel.status == 0 ? YES : NO;
    self.shopCartVC.have_must = shopModel.have_must;
    [WMShopDBModel shareWMShopDBModel].shopModel = shopModel;
    [WMShopDBModel shareWMShopDBModel].is_can_zero_ziti = shopModel.can_zero_ziT;
    for (WMShopCateModel *cate in shopModel.cateArr) {
        NSLog(@"%@",cate.title);
    }
    if (shopModel.tj_items.products.count > 0) {
        // 刷新头部视图
        self.tuiJianView.height = 230;
        [self.tuiJianView reloadViewWithGoodArr:shopModel.tj_items.products];
    }else{
        self.tuiJianView.height = 0;
    }

    CGFloat headerH = 0;
    if ([shopModel.shop_coupon[@"title"] length] > 0) {
        headerH = 70;
    }
    if (shopModel.advs.count > 0) {
        headerH += headerH == 0 ? 10 : 0;// 补充高度
        headerH += shopModel.advs.count * (10 + WIDTH * 0.75 * 0.33);
    }
    
    JHShopMenuTableHeaderView *tableHeaderView = [[JHShopMenuTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 0.75, headerH)];
    self.tableView.tableHeaderView = tableHeaderView;
    [tableHeaderView reloadViewWith:shopModel];
     __weak typeof(self) weakSelf=self;
    tableHeaderView.clickItemBlock = ^(NSInteger index, BOOL is_adv) {
        if (is_adv) {
            NSString *url = weakSelf.shopModel.advs[index][@"link"];

            // 外卖商品详情
            if ([url containsString:@"waimai/product/detail"]) {
                NSString *product_id =  [weakSelf getParameterWithLink:url];
                WMShopGoodModel *good = [weakSelf getADGoodModelWith:product_id];
                if (good) {
                    JHWMShopGoodDetailVC *detail = [JHWMShopGoodDetailVC new];
                    detail.shopModel = weakSelf.shopModel;
                    detail.good = good;
                    detail.shopCartVC = weakSelf.shopCartVC;
                    detail.shopMenuVC = weakSelf;
                    weakSelf.goodDetailVC = detail;
                    [weakSelf.superVC.navigationController pushViewController:detail animated:YES];
                }
            }else{
                [weakSelf pushToNextByRoute:url vc:weakSelf];
            }
            
        }else{
            [weakSelf getQuan];
        }
    };
    if (!_shopModel) {
        _shopModel = shopModel;
       [self dealShopDataWithDBAndQuitMoreShopCart:NO];
    }
    
    [self dealShopCartData];
}

//原生界面,如果有参数,取出参数
-(NSString *)getParameterWithLink:(NSString *)link{
    
    link = [[link componentsSeparatedByString:@".html"]firstObject];
    NSString *str = @"";
    
    if ([link containsString:@"shoplist/index-"]) {
        // 商家列表
        str = [[link componentsSeparatedByString:@"-"]lastObject];
        
    }else if ([link containsString:@"shop/detail-"]){
        // 商家详情
        str = [[link componentsSeparatedByString:@"-"]lastObject];
        
    }else if ([link containsString:@"ucenter/order/detail-"] && [link containsString:@"-"]){
        // 订单详情
        str = [[link componentsSeparatedByString:@"-"]lastObject];
        
    }else if ([link containsString:@"product/detail-"]){
        // 商品详情
        str = [[link componentsSeparatedByString:@"-"]lastObject];
    }
    
    return str;
    
}

-(WMShopGoodModel *)getADGoodModelWith:(NSString *)product_id{
    for (WMShopCateModel *cate in _shopModel.cateArr) {
        for (WMShopGoodModel *good in cate.products) {
            if ([good.product_id isEqualToString:product_id]) {
                return good;
            }
        }
    }
    return nil;
}

// 根据数据库中存储的该商家的信息处理数据 是否是退出多人购物车的数据处理
-(void)dealShopDataWithDBAndQuitMoreShopCart:(BOOL)is_more{
    if ([WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC) {
        is_more = YES;
    }
    self.shopDBModel = [WMShopDBModel shareWMShopDBModel];
    self.shopDBModel.amount = 0;
    self.shopDBModel.current_amount = 0;
    self.shopDBModel.quota = self.shopModel.quota;
    self.shopDBModel.shop_id = self.shopModel.shop_id;
    self.shopDBModel.shop_logo = self.shopModel.logo;
    self.shopDBModel.shop_title = self.shopModel.title;
    self.shopDBModel.shop_choosedCount = 0;

    __weak typeof(self) weakSelf=self;
    
    if (self.onceAgainProductsArr.count > 0) {// 再来一单的数据处理
        
        [self reloadTableVie];
        self.shopCartVC.startPrice = self.shopModel.min_amount;
        
        [self dealOnceAgainProducsWithShow:!is_more block:^{
            
            [weakSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [weakSelf dealShopCartData];
            HIDE_HUD_FOR_VIEW(weakSelf.superVC.view);
        }];
        
    }else{
        if ([WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC) {
            weakSelf.shopCartVC.startPrice = self.shopModel.min_amount;
            [weakSelf selectedChooseGood];
            [self dealShopCartData];
            [weakSelf reloadTableVie];
            HIDE_HUD_FOR_VIEW(weakSelf.superVC.view);
            return;
        }
        [self.shopDBModel getShopDataFormDB:^(NSArray *arr, NSString *msg) {
            
            weakSelf.onceAgainProductsArr = arr;
            weakSelf.shopCartVC.startPrice = weakSelf.shopModel.min_amount;
            [weakSelf reloadTableVie];
            [weakSelf selectedChooseGood];
            if (!arr) {// 数据库中没有这个商家的数据信息
                HIDE_HUD_FOR_VIEW(weakSelf.superVC.view);
                return ;
            }
            
            [weakSelf dealOnceAgainProducsWithShow:NO block:^{
                
                [weakSelf dealShopModelWithDBData];
                [weakSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];

                [weakSelf selectedChooseGood];
                [weakSelf dealShopCartData];
                HIDE_HUD_FOR_VIEW(weakSelf.superVC.view);
                
            }];
            
        }];
    }
    
}

-(void)selectedChooseGood{
    if (self.good_id.length > 0) {
        for (WMShopCateModel *cate in self.shopModel.cateArr) {
            BOOL is_found = NO;
            for (WMShopGoodModel *good in cate.products) {
                if ([good.product_id isEqualToString:self.good_id]) {
                    NSInteger section = [self.shopModel.cateArr indexOfObject:cate];
                    NSInteger row = [cate.products indexOfObject:good];
                    [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    is_found = YES;
                    break;
                }
            }
            if (is_found) {
                break;
            }
        }
    }
}

#pragma mark ====== 处理再来一单的数据 =======
-(void)dealOnceAgainProducsWithShow:(BOOL)show block:(void(^)())complete{
    
    NSMutableArray *changedArr = [NSMutableArray array];//发生变化的商品，库存不足，删除了，规格发生变化
    NSMutableArray *goodArr = [NSMutableArray array];
    NSMutableArray *cateArr = [NSMutableArray array];
    
    for (NSDictionary *dic in self.onceAgainProductsArr) {
        NSArray *cate_arr = [dic[@"cate_str"] componentsSeparatedByString:@","];
        BOOL is_changed = NO;// 商品是否发生了变化
        BOOL is_found_good = YES;// 商品是否下架
        for (WMShopCateModel *cate in self.shopModel.cateArr) {
            if ([cate_arr containsObject:dic[@"cate_id"]]) {// || [cate.cate_id isEqualToString:@"must"]
                for (WMShopGoodModel *good in cate.products) {
                    
                    if ([good.product_id isEqualToString:dic[@"product_id"]]) {
                        is_found_good = NO;
                        // 防止对willAddGood修改导致good的信息发生变化
                        NSDictionary *goodDic = [good mj_keyValues];
                        WMShopGoodModel *willAddGood = [WMShopGoodModel mj_objectWithKeyValues:goodDic];
                      
                        willAddGood.choosed_proprety = dic[@"specification"];
                        willAddGood.is_specification = [dic[@"specification"] length] > 0;
                        // 有属性的商品改成不是属性的商品
                        if (willAddGood.specification.count == 0 &&  [dic[@"specification"] length] > 0) {
                            is_changed = YES;
                            break;
                        }
                        
                        // 不是属性的商品改成属性商品
                        if (willAddGood.specification.count > 0 &&  [dic[@"specification"] length] == 0) {
                            is_changed = YES;
                            break;
                        }
                        
                        // 判断属性是否存在改变
                        if (willAddGood.specification.count > 0 &&  [dic[@"specification"] length] > 0) {
                            is_changed = [self propretyChangedWith:willAddGood choosedProprety:dic[@"specification"]];
                            if (is_changed) {
                                 break;
                            }
                        }
                        
                        // 不是规格商品现在改成了规格商品
                        if (willAddGood.is_spec && [dic[@"spec_id"] isEqualToString:@"0"]) {
                            is_changed = YES;
                            break;
                        }
                        // 是规格商品现在改成不是规格商品
                        if (!willAddGood.is_spec && ([dic[@"spec_id"] intValue] != 0)) {
                            is_changed = YES;
                            break;
                        }
                        
                        // 订单或购物车中的商品的总数（与库存比较）
                        int count_in_order = [self getGoodCountInOnceOrderWithSpec_id:dic[@"spec_id"] product_id:dic[@"product_id"]];
                        // 是规格商品但是规格删除了
                        if ([dic[@"spec_id"] intValue] != 0) {// 是规格商品

                            BOOL is_fond_spec = NO;
                            for (WMShopGoodSpecModel *spec in willAddGood.specs) {
                                if ([spec.spec_id isEqualToString:dic[@"spec_id"]]) {
                                    
                                    // 是规格商品且库存足够
                                    if(spec.sale_sku >= count_in_order){
                                        is_fond_spec = YES;
                                        willAddGood.choosedSize_photo = spec.spec_photo;
                                        willAddGood.choosedSize_price = spec.price;
                                        willAddGood.choosedSize_Name = spec.spec_name;
                                        willAddGood.spec_package_price = spec.package_price;
                                        willAddGood.choosedSize_sale_ku = spec.sale_sku;
                                        
                                        willAddGood.quotalabel = spec.quotalabel;
                                        willAddGood.is_discount = spec.is_discount;
                                        willAddGood.disctype = spec.disctype;
                                        willAddGood.discval = spec.discval;
                                        willAddGood.oldprice = spec.oldprice;
//                                        willAddGood.price = spec.price;
                                        willAddGood.diffprice = spec.diffprice;
                                        willAddGood.disclabel = spec.disclabel;
                                    }else{
                                        is_changed = YES;
                                    }
                                    break;
                                    
                                }
                            }
                            if (!is_fond_spec)  break;
                            
                            
                        }else if(willAddGood.sale_sku < count_in_order){
                            // 不是规格商品但是库存不够
                            is_changed = YES;
                            break;
                        }
                        
                        willAddGood.good_choosedCount = [dic[@"product_number"] intValue];
                        willAddGood.current_shopcart_choosedCount = [dic[@"current_shopcart_choosedCount"] intValue];
                        willAddGood.choosedSize_id = ([dic[@"spec_id"] intValue] == 0 ? @"" :dic[@"spec_id"]);
                        cate.cate_choosedCount += [dic[@"product_number"] intValue];
                        cate.current_shopcart_choosedCount += [dic[@"current_shopcart_choosedCount"] intValue];
                        [cateArr addObject:cate];
                        is_changed = NO;
                        
//                        BOOL is_contains = NO;
//                        for (WMShopGoodModel *s_good in goodArr) {
//                            if ([s_good.product_id isEqualToString:willAddGood.product_id]) {
//                                is_contains = YES;
//                                break;
//                            }
//                        }
//                        if (!is_contains) {
                            [goodArr addObject:willAddGood];
//                        }
                        
                    }
                }
            }
            
            if (is_changed) break;
            
        }
        
        if (is_found_good) {// 商品下架
            is_changed = YES;
        }
        
        if (is_changed) {
            [changedArr addObject:dic];
        }
    }
    
    [self.shopDBModel deleteAllGoodsWith:self.shopModel.shop_id];
    if (goodArr.count > 0) {
        __weak typeof(self) weakSelf=self;
        [self.shopDBModel addOnceAgainOrderToDB:self.shopModel.shop_id products:goodArr cates:cateArr block:^(BOOL success, NSString *msg) {
            complete();
            if (show) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.shopCartVC showShopCartDetail];
                });
            }
        }];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            complete();
        });
    }
    
    if (changedArr.count > 0) {// 变化商品的提示
        JHWMShowChangeGoodsVC *change = [JHWMShowChangeGoodsVC new];
        change.changedGoodsArr = changedArr;
        
        [self.superVC presentViewController:change animated:YES completion:nil];
    }
    
    [self reloadTableVie];
}

// 判断该商品的属性是不是发生了变化
-(BOOL)propretyChangedWith:(WMShopGoodModel *)good choosedProprety:(NSString *)propretyStr{
   
    BOOL is_change = YES;
    NSArray *arr = [propretyStr componentsSeparatedByString:@","];
    NSMutableArray *proprety_arr = [NSMutableArray array];
    for (NSString *str in arr) {
        if ([str containsString:@":"]) {
            NSArray *arr = [str componentsSeparatedByString:@":"];
            [proprety_arr addObject:@{@"key_name":arr.firstObject,@"key_val":arr.lastObject}];
        }
    }

    if (good.specification.count != proprety_arr.count) {
        is_change = YES;
    }else{
        for (NSDictionary *dic in good.specification) {// 该商品现在的属性
            is_change = YES;// 每次匹配属性的时候都置为YES
            for (NSDictionary *propretyDic in proprety_arr) {// 现在的属性和选择的属性比较
                if ([dic[@"key"] isEqualToString:propretyDic[@"key_name"]] && [dic[@"val"] containsObject:propretyDic[@"key_val"]]) {
                    is_change = NO;// 属性匹配成功的时候置为NO
                }
            }
            if (is_change) {// 存在一个没有匹配成功就结束
                break;
            }
        }
    }
    
    return is_change;
}

// 获取再来一单中该商品或规格商品的总数量
-(int)getGoodCountInOnceOrderWithSpec_id:(NSString *)spec_id product_id:(NSString *)product_id{
    int count = 0;
    for (NSDictionary *dic in self.onceAgainProductsArr) {
        if ([spec_id intValue] != 0) {// 是规格商品
//            NSLog(@"%@   %@",dic[@"spec_id"],dic[@"product_id"]);
            if ([dic[@"spec_id"] isEqualToString:spec_id] && [dic[@"product_id"] isEqualToString:product_id]) {
                count += [dic[@"product_number"] intValue];
            }
        }else{// 不是规格商品
            if ([dic[@"product_id"] isEqualToString:product_id]) {
                count += [dic[@"product_number"] intValue];
            }
        }
    }
    return count;
}
#pragma mark  ------- 根据从数据库中获取到的数据处理shopmodel中good的choosedCount
-(void)dealShopModelWithDBData{
    for (WMShopCateModel *cate in self.shopModel.cateArr) {
        cate.cate_choosedCount =  [self.shopDBModel getShopCateChoosedCountFromDB:cate.cate_id];
    }
    [self reloadTableVie];
}

-(void)reloadTableVie{
    [self.tableView reloadData];
    [self.leftTableView reloadData];
    [self.tuiJianView.collectionView reloadData];
    NSArray * arr = [self.tableView indexPathsForRowsInRect:self.tableView.bounds];
    if (arr.count == 0) {
        return;
    }
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[arr.firstObject section] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];

}

#pragma mark  ------- 清空购物车
-(void)deleteAllGoods{
    
    [self.shopDBModel deleteAllGoodsWith:self.shopModel.shop_id];
    [self dealShopModelWithDBData];
    self.shopDBModel.all_amount = 0;
    self.shopDBModel.amount = 0;
    self.shopCartVC.amount = @"0";
    self.shopCartVC.dataSource = @[].mutableCopy;
    
}

#pragma mark  ------- 购物车中的商品数量发生变化的处理
-(void)dealWithProductCountChange:(WMShopGoodModel *)good is_add:(BOOL)is_add{
    if (!good) { // 点击了清空
        [self deleteAllGoods];
        return;
    }
    
    NSInteger row = 0;
    
    NSArray *good_cate_arr = [good.cate_str componentsSeparatedByString:@","];
    for (WMShopCateModel *cate in self.shopModel.cateArr) {
        
        if (good.is_must && [cate.cate_id isEqualToString:@"must"]) {// 选择的是必点商品的处理
            if (Current_Is_Other_ShopCart) {
                cate.current_shopcart_choosedCount += (is_add ? 1: (-1));
                cate.current_shopcart_choosedCount = MAX(cate.current_shopcart_choosedCount, 0);
            }
            cate.cate_choosedCount += (is_add ? 1: (-1));
            cate.cate_choosedCount = MAX(cate.cate_choosedCount, 0);
            
            row = [self.shopModel.cateArr indexOfObject:cate];
            WMShopMenuCateCell * cell = [self.leftTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            [cell countChange:is_add];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.shopDBModel dealCate:cate is_add:is_add];
            });
            continue;
        }
        if ([good_cate_arr containsObject:cate.cate_id]) {
            if (Current_Is_Other_ShopCart) {
                cate.current_shopcart_choosedCount += (is_add ? 1: (-1));
                cate.current_shopcart_choosedCount = MAX(cate.current_shopcart_choosedCount, 0);
            }
            cate.cate_choosedCount += (is_add ? 1: (-1));
            cate.cate_choosedCount = MAX(cate.cate_choosedCount, 0);
            
            row = [self.shopModel.cateArr indexOfObject:cate];
            WMShopMenuCateCell * cell = [self.leftTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            [cell countChange:is_add];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.shopDBModel dealCate:cate is_add:is_add];
            });
        }
    }
    for (WMShopCateModel *cate in self.shopModel.cateArr) {

        if ([good_cate_arr containsObject:cate.cate_id]) {
            
            for (WMShopGoodModel *subgood in cate.products) {
                
                if ([subgood.product_id isEqualToString:good.product_id]) {
//                    数据库操作的时候会自己算good_choosedCount，此处只是为了界面处理需要
//                    good.good_choosedCount = [self.shopDBModel getShopGoodChoosedCountFromDB:good.product_id choosedSize_id:good.choosedSize_id propretyStr:good.choosed_proprety good:good];
                    
//                    如果出错将上面注释掉,这里放开
//                    if (good) {
                        subgood.good_choosedCount = [self.shopDBModel getShopGoodChoosedCountFromDB:good.product_id choosedSize_id:good.choosedSize_id propretyStr:good.choosed_proprety good:good];
                        subgood.current_shopcart_choosedCount = [self.shopDBModel getShopGoodChoosedCountFromDB:good.product_id choosedSize_id:good.choosedSize_id propretyStr:good.choosed_proprety good:good];
                        
                        subgood.quotalabel = good.quotalabel;
                        subgood.is_discount = good.is_discount;
                        subgood.disctype = good.disctype;
                        subgood.discval = good.discval;
//                        subgood.oldprice = good.oldprice;
//                        subgood.price = good.price;
                        subgood.diffprice = good.diffprice;
                        subgood.disclabel = good.disclabel;
                        
                        subgood.remain_count = good.remain_count;
                        subgood.choosed_proprety = good.choosed_proprety;
                        subgood.is_specification = good.is_specification;
                        if (Current_Is_Other_ShopCart) {
                            subgood.current_shopcart_choosedCount += (is_add ? 1: (-1));
                            subgood.current_shopcart_choosedCount = MAX(subgood.current_shopcart_choosedCount, 0);
                        }
                        subgood.good_choosedCount += (is_add ? 1: (-1));
                        subgood.good_choosedCount = MAX(subgood.good_choosedCount, 0);
//                        goodRow = [cate.products indexOfObject:subgood];
                        if (subgood.is_spec) {
                            subgood.choosedSize_id = good.choosedSize_id;
                            subgood.choosedSize_sale_ku = good.choosedSize_sale_ku;
                            subgood.choosedSize_Name = good.choosedSize_Name;
                            subgood.choosedSize_price = good.choosedSize_price;
                            subgood.spec_package_price = good.spec_package_price;
                        }
                        good = subgood;
//                    }
                    break;
                }
            }
            
            [self.shopDBModel goodCountChange:good cate:nil is_add:is_add];
            break;
        }
        
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
    if (self.shopCartVC.is_showShopCartDetail) {
        [self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tuiJianView reloadViewWithGoodArr:self.shopModel.tj_items.products];
        });
    }
   
    if (good.is_specification || good.is_spec) {// 规格和属性商品,数量的刷新
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tuiJianView reloadViewWithGoodArr:self.shopModel.tj_items.products];
        });
    }

    
//    [self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];

    [self dealShopCartData];
//    self.shopDBModel.quota > 0 &&
    if ( good.is_discount) {// 限购商品是否超出了限制
        int count = 0;
        for (WMShopGoodModel *good in self.shopDBModel.choosedGoodsArr) {
            if (good.is_discount) {
                count += good.good_choosedCount;
            }
        }
        if (count > self.shopDBModel.quota && self.shopModel.quota != 0) {
            [self.superVC showToastAlertMessageWithTitle: NSLocalizedString(@"超出限购的部分按照原价计算!", NSStringFromClass([self class]))];
        }
    }
}
#pragma mark  ------- 商品数量变化时的界面变化
-(void)dealWithChooseProduct:(WMShopGoodModel *)good is_add:(BOOL)is_add{
    [self.shopCartVC cartBtnAnimation:is_add];
    [self dealWithProductCountChange:good is_add:is_add];
}

#pragma mark  ------- 点击cell中的steper商品数量变化时的界面变化
-(void)dealWithChooseProduct:(UIView *)fromView indexPath:(NSIndexPath *)indexpath{
    
    WMShopCateModel *cate = self.shopModel.cateArr[indexpath.section];
    WMShopGoodModel *good = cate.products[indexpath.row];
    BOOL is_add = YES;
    if (fromView) {// 增加
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addProductAnimation:fromView dropToPoint:CGPointMake(30, self.view.height - 20)];
        });
    }else{// 减少
        is_add = NO;
        [self.shopCartVC cartBtnAnimation:is_add];
    }
    [self dealWithProductCountChange:good is_add:is_add];
}

#pragma mark  ------- 选择的商品变化时购物车数据的处理
-(void)dealShopCartData{

    self.shopCartVC.shopCartCount = self.shopDBModel.shop_choosedCount;
//    self.shopCartVC.couDanArr = self.shopModel.couDanArr;
    if (Current_Is_Other_ShopCart) {
        self.shopCartVC.dataSource = self.shopDBModel.current_shopcart_choosedGoodsArr;
        self.shopCartVC.amount = [NSString stringWithFormat:@"%.2f", self.shopDBModel.current_amount];
    }else{
        self.shopCartVC.dataSource = self.shopDBModel.choosedGoodsArr;
        self.shopCartVC.amount = [NSString stringWithFormat:@"%.2f", self.shopDBModel.amount];
    }
}
#pragma mark  ------- 领取优惠券
-(void)getQuan{
    
    [self.superVC gotoWebVC:NSLocalizedString(@"领取优惠劵", @"JHShopMenuVC") link:self.shopModel.shop_coupon[@"link"]];
}

#pragma mark  ------- 调整shopCartVC的View
-(void)adjustShopCartView{
    [self.view addSubview:self.shopCartVC.view];
    [self.shopCartVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.right.offset= 0;
        make.height.offset=49;
    }];
}

#pragma mark  ------- 选个规格商品
-(void)chooseSizeGood:(NSIndexPath *)indexpath{
    
    __weak typeof(self) weakSelf=self;
    WMShopCateModel *cate = self.shopModel.cateArr[indexpath.section];
    WMShopGoodModel *good = cate.products[indexpath.row];
    JHWMChooseSizeGoodPropertyVC *chooseSizeVC = [JHWMChooseSizeGoodPropertyVC new];
    chooseSizeVC.good = good;
    [self.superVC presentViewController:chooseSizeVC animated:YES
                             completion:nil];
    chooseSizeVC.goodCountChange = ^(BOOL is_add){
        [weakSelf dealWithProductCountChange:good is_add:is_add];
    };
    
}

#pragma mark ======购物车动画=======
- (void)addProductAnimation:(UIView *)out_view dropToPoint:(CGPoint)dropToPoint {
    
    CGRect rect = [out_view convertRect:out_view.bounds toView:self.view];
    CGFloat startX = rect.origin.x + 5;
    CGFloat startY = rect.origin.y ;
    
    UIBezierPath *path= [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startX  , startY )];
    
    CGFloat margin=50;
    
    //三点曲线
    [path addCurveToPoint:CGPointMake(dropToPoint.x, dropToPoint.y)
            controlPoint1:CGPointMake(startX - 5, startY - 5)
            controlPoint2:CGPointMake(startX - 2 * margin, startY- 2 * margin)];
    
    CALayer * dotLayer = [CALayer layer];
    dotLayer.backgroundColor = HEX(@"4DC831", 1.0).CGColor;
    dotLayer.frame = CGRectMake(0, 0, 24, 24);
    dotLayer.cornerRadius = 24/2.0;
    [self.view.layer addSublayer:dotLayer];
    [self groupAnimation:dotLayer path:path];
}

// 组合动画
-(void)groupAnimation:(CALayer *)layer path:(UIBezierPath *)path
{
    [layer removeAnimationForKey:@"cartParabola"];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.5];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.7, 0.7, 1)];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1)];
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation,transformAnimation];
    groups.duration = .5f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [layer addAnimation:groups forKey:@"cartParabola"];
    [self performSelector:@selector(removeFromLayer:) withObject:layer afterDelay:.45f];
}

- (void)removeFromLayer:(CALayer *)layerAnimation{
    [self.shopCartVC cartBtnAnimation:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layerAnimation removeFromSuperlayer];
        [layerAnimation removeAnimationForKey:@"cartParabola"];
    });
}

-(void)setOnceAgainProductsArr:(NSArray *)onceAgainProductsArr{
    NSMutableArray *newOnceArr = [NSMutableArray arrayWithArray:onceAgainProductsArr];
    for (NSInteger i=0; i<newOnceArr.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:onceAgainProductsArr[i]];
        if ([dic[@"specification"] isKindOfClass:[NSString class]]) {
            break;
        }else{
            if ([dic[@"specification"] count] > 0) {
                NSMutableDictionary *propertyDic = [NSMutableDictionary dictionary];
                for (NSDictionary *subDic in dic[@"specification"]) {
                    NSString *key = subDic[@"key"];
                    propertyDic[key] = subDic[@"val"];
                }
                NSMutableArray *arr = [NSMutableArray array];
                NSArray *key_arr = [propertyDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
                    return  [obj1 compare:obj2];
                }];
                for (NSString * key in key_arr) {
                    NSString *str = [NSString stringWithFormat:@"%@:%@",key,propertyDic[key]];
                    [arr addObject:str];
                }
                NSString *str = [arr componentsJoinedByString:@","];
                dic[@"specification"] = str;
            }else{
                dic[@"specification"] = @"";
            }
            [newOnceArr replaceObjectAtIndex:i withObject:dic];
        }
    }
    _onceAgainProductsArr = newOnceArr.copy;
}
@end
