//
//  JHWaiMaiOrderVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/3.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiOrderVC.h"
#import "JHWaiMaiOrderListCell.h"

#import "JHWaiMaiOrderListModel.h"
#import "JHWaimaiOrderDetailVC.h"
#import "JHWaiMaiShopDetailVC.h"
#import "JHWaiMaiOrderViewModel.h"
#import "JHWaimaiOrderDetailEvaluateVC.h"
#import "JHPayVC.h"
#import "JHShowAlert.h"
#import "JHWaimaiOrderDetailSeeEvaluationVC.h"
#import "JHWaimaiOrderBackMoneyVC.h"
#import "JHAllOrderTableFooterView.h"

@interface JHWaiMaiOrderVC ()<UITableViewDelegate,UITableViewDataSource,JHWaiMaiOrderListCellDelegate,JHOrderStatusActionProtocol>{
    NSInteger page;
}
@property(nonatomic,strong)UITableView *myTableView;//表视图
@property(nonatomic,strong)NSMutableArray *infoArr;//存储数据模型的数组
@end

@implementation JHWaiMaiOrderVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    [self myTableView];
    [NoticeCenter addObserver:self selector:@selector(clearData) name:QuitLogin object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([JHUserModel shareJHUserModel].token) {
        //表视图
         page = 1;
         [self getData];
    }else{
        [_infoArr removeAllObjects];
        [_myTableView reloadData];
    }
}

#pragma mark - 初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"订单", nil);
    _infoArr = @[].mutableCopy;
    [self addRightTitleBtn: NSLocalizedString(@"跑腿", NSStringFromClass([self class])) titleColor:HEX(@"333333", 1.0) sel:@selector(clickToPaoTui)];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            CGFloat h = _isHomeIn? HEIGHT - NAVI_HEIGHT:HEIGHT - NAVI_HEIGHT -TABBAR_HEIGHT;
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, h) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.estimatedRowHeight = 100;
            table.rowHeight = UITableViewAutomaticDimension;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = BACK_COLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [table registerClass:[JHAllOrderTableFooterView class] forHeaderFooterViewReuseIdentifier:@"JHAllOrderTableFooterView"];
            [self.view addSubview:table];
            
            __weak typeof(self) weakSelf=self;
            //--下拉加载
            [table bindHeadRefreshHandler:^{
                [weakSelf downRefresh];
            }];
            //--上拉加载
            [table bindFootRefreshHandler:^{
                [weakSelf upLoadData];
            }];
            //---
            
            table;
            
        });
    }
    return _myTableView;
}
#pragma mark - 这是下拉刷新
-(void)downRefresh{
    page = 1;
    [self getData];
}
#pragma mark - 上拉加载
-(void)upLoadData{
     page ++;
     [self getData];
}
#pragma mark - 这是获取数据的方法
-(void)getData{
    SHOW_HUD
    [JHWaiMaiOrderViewModel postToGetOrderListInfoWithDic:@{@"page":@(page)} block:^(JHWaimaiOrderListMainModel *model, NSString *err) {
        HIDE_HUD
        if (err) {
            [self showToastAlertMessageWithTitle:err];
        }else{
            if (page == 1) {
                [_infoArr removeAllObjects];
            }
            if (model.items.count > 0) {
                [_infoArr addObjectsFromArray:model.items];
                [self.myTableView reloadData];
            }
            [self.myTableView reloadData];
        }
        [_myTableView endRefresh];
    }];
}

#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.infoArr.count == 0) {
        NSString *title = @"";
        NSString *desStr = @"";

        if (![JHUserModel shareJHUserModel].isLogin) {
            desStr =  NSLocalizedString(@"您还没有登录无法查看", NSStringFromClass([self class]));
            title =  NSLocalizedString(@"点击登录", NSStringFromClass([self class]));
        }else{
            desStr =  NSLocalizedString(@"暂无订单", NSStringFromClass([self class]));
            title = @"";
        }
        [self showEmptyViewWithImgName:@"icon_wu" desStr:desStr btnTitle:title inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    tableView.scrollEnabled = self.infoArr.count != 0;
    return _infoArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    JHWaiMaiOrderListModel *model = _infoArr[section];
    return model.show_btn.allKeys.count == 0 ? 0 : 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    JHAllOrderTableFooterView *footerView = [[JHAllOrderTableFooterView alloc] initWithReuseIdentifier:@"JHAllOrderTableFooterView" btnMasRect:JHAllOrderFooterBtnMasRectMake(10, 0, 10, 80, 15)];
    JHWaiMaiOrderListModel *model = _infoArr[section];
    [footerView reloadViewWith:model];
    footerView.delegate = self;
    return footerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"JHWaiMaiOrderListCell";
    JHWaiMaiOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[JHWaiMaiOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    JHWaiMaiOrderListModel *model = _infoArr[indexPath.section];
    cell.index = indexPath;
    cell.model = model;
    cell.delegate = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHWaiMaiOrderListModel *model = _infoArr[indexPath.section];
    JHWaimaiOrderDetailVC *vc = [[JHWaimaiOrderDetailVC alloc]init];
    vc.order_id = model.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - cell的代理方法
-(void)clickToShopDetail:(NSIndexPath *)indexPath{
    JHWaiMaiOrderListModel *model = _infoArr[indexPath.section];
    JHWaiMaiShopDetailVC *vc = [[JHWaiMaiShopDetailVC alloc]init];
    vc.shop_id = model.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ====== JHOrderStatusActionProtocol =======
// 去支付
-(void)payOrderWithOrder_id:(NSString *)order_id amount:(NSString *)amount dateline:(NSInteger)dateline{
    JHPayVC *vc = [[JHPayVC alloc]init];
    vc.order_id = order_id;
    vc.dateline = dateline;
    vc.is_show_friendPay = YES;
    vc.amount = [NSString stringWithFormat:@"%@",amount];
//    vc.is_contain_money = YES;
//    vc.jumpVcStr = @"JHWaimaiOrderDetailVC";
    [self.navigationController pushViewController:vc animated:YES];

}
// 取消订单
-(void)cancleOrderWithOrder_id:(NSString *)order_id is_timer:(BOOL)is_timer{
  
    if (is_timer) {
        [JHWaiMaiOrderViewModel postToCancelOrderWithDic:@{@"order_id":order_id} block:^(NSString *err) {
            if (!err) {
                page = 1;
                [self getData];
            }
        }];
        return;
    }
    [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"确认取消订单?", nil) withBtn_cancel:NSLocalizedString(@"取消", nil) withBtn_sure:NSLocalizedString(@"确定", nil) withController:self withCancelBlock:nil withSureBlock:^{
        SHOW_HUD
        [JHWaiMaiOrderViewModel postToCancelOrderWithDic:@{@"order_id":order_id} block:^(NSString *err) {
            HIDE_HUD
            if (!err) {
                [self showToastAlertMessageWithTitle:NSLocalizedString(@"取消成功!", nil)];
                page = 1;
                [self getData];
            }else{
                [self showToastAlertMessageWithTitle:err];
            }
        }];
        
    }];

}
// 再来一单
-(void)againOrderWithOrder:(id)order{
    JHWaiMaiOrderListModel *model = (JHWaiMaiOrderListModel *)order;
    JHWaiMaiShopDetailVC *vc = [JHWaiMaiShopDetailVC new];
    vc.shop_id = model.shop_id;
    NSArray *goodArr = [model.products firstObject][@"product"];
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
    [JHWaiMaiOrderViewModel postToCuidanOrderWithDic:@{@"order_id":order_id} block:^(NSString *err) {
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
    [JHWaiMaiOrderViewModel postToSureOrderWithDic:@{@"order_id":order_id} block:^(NSString *err) {
        HIDE_HUD
        if (err) {
            [self showToastAlertMessageWithTitle:err];
        }else{
            page = 1;
            [self getData];
        }
    }];
}
// 退款
-(void)refundOrderWithOrder_id:(NSString *)order_id phone:(NSString *)phone{
    JHWaimaiOrderBackMoneyVC *vc = [[JHWaimaiOrderBackMoneyVC alloc]init];
    vc.order_id = order_id;
    vc.mobile = phone;
    [self.navigationController pushViewController:vc animated:YES];
}
// 申请客服介入
-(void)applyForCustomerServicesWithOrder_id:(NSString *)order_id{
    [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"确定申请客服介入", nil) withBtn_cancel:NSLocalizedString(@"取消", nil) withBtn_sure:NSLocalizedString(@"确定", nil) withController:self withCancelBlock:nil withSureBlock:^{
        SHOW_HUD
        [JHWaiMaiOrderViewModel postToServiseWithDic:@{@"order_id":order_id} block:^(NSString *err) {
            HIDE_HUD
            if (err) {
                [self showToastAlertMessageWithTitle:err];
            }else{
                [self showToastAlertMessageWithTitle:NSLocalizedString(@"申请成功,等待客服与您联系!", nil)];
                page = 1;
                [self getData];
            }
        }];
    }];
}
// 去评价
-(void)commentOrderWithOrder:(id)order{
    JHWaiMaiOrderListModel *model = (JHWaiMaiOrderListModel *)order;
    JHWaimaiOrderDetailEvaluateVC *vc = [[JHWaimaiOrderDetailEvaluateVC alloc]init];
    vc.order_id =  model.order_id;
    vc.shopImg = model.shop_logo;
    vc.shopName = model.shop_title;
    vc.timeArr = model.time;
    vc.jifenNum = model.jifen_total;
    vc.productsArr = model.products;
    vc.isziti = [model.pei_type integerValue] == 3?YES:NO;
    [self.navigationController pushViewController:vc animated:YES];
}
// 查看评价
-(void)viewCommentWithOrder:(id)order{
    JHWaiMaiOrderListModel *model = (JHWaiMaiOrderListModel *)order;
    JHWaimaiOrderDetailSeeEvaluationVC * vc = [[JHWaimaiOrderDetailSeeEvaluationVC alloc]init];
    vc.comment_id = model.comment_id;
    vc.isziti = [model.pei_type integerValue] == 3?YES:NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击去逛逛
-(void)clickStatusBtnAction{
    if ([JHUserModel shareJHUserModel].token) {
        [self pushToNextVcWithVcName:@"JHWaiMaiShopListVC"];
    }else{
        [NoticeCenter postNotificationName:LOGIN_NoticeName object:nil];
    }
}

#pragma mark ====== 退出登录的时候处理 =======
-(void)clearData{
    page = 1;
    [_infoArr removeAllObjects];
    [self.myTableView reloadData];
}


// 点击前往
-(void)clickToPaoTui{
    if ([JHUserModel shareJHUserModel].isLogin) {
       [self pushToNextByRoute:[JHConfigurationTool shareJHConfigurationTool].paotui_order_link vc:self];
    }else{
        [self showToastAlertMessageWithTitle: NSLocalizedString(@"您还未登录,无法查看!", NSStringFromClass([self class]))];
    }
    
}

@end
