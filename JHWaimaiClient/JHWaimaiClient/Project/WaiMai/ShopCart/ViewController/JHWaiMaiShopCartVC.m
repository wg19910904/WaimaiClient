//
//  JHWaiMaiShopCartVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/3.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiShopCartVC.h"
#import "WMShopCartOfShopCell.h"
#import "JHShowAlert.h"

@interface JHWaiMaiShopCartVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *shopCartArr;
@end

@implementation JHWaiMaiShopCartVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getData];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
   
}

-(void)setUpView{
    
    [self addRightTitleBtn: NSLocalizedString(@"清空", NSStringFromClass([self class])) titleColor:HEX(@"333333", 1.0) sel:@selector(clickClearShopCart)];
    self.navigationItem.title = NSLocalizedString(@"购物车", nil);
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT-VC_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 164;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.shopCartArr.count == 0) {
        [self showEmptyViewWithImgName:@"icon_cart_empty" desStr:NSLocalizedString(@"购物车快饿瘪了T.T", @"JHWaiMaiShopCartVC") btnTitle:NSLocalizedString(@"去逛逛", @"JHWaiMaiShopCartVC") inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    return self.shopCartArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"WMShopCartOfShopCell";
    WMShopCartOfShopCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[WMShopCartOfShopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    __weak typeof(self) weakSelf=self;
    WMShopDBModel *model = self.shopCartArr[indexPath.section];
    
    cell.clickDeleteShopDB = ^(){
        [weakSelf deleteShopDB:indexPath];
    };
    cell.showMoreGoodBlock = ^(BOOL success, NSString *msg) {
        if (success) {// 展示更多商品
            model.showShopCartMoreGood = YES;
            [weakSelf.tableView reloadData];
        }else{// 进入商家详情
            [weakSelf pushToShopDetial:indexPath];
        }
    };
    [cell reloadCellWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 10 : CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self pushToShopDetial:indexPath];
}

-(void)pushToShopDetial:(NSIndexPath *)indexPath{
    WMShopDBModel *model = self.shopCartArr[indexPath.section];
    JHBaseVC *vc = [NSClassFromString(@"JHWaiMaiShopDetailVC") new];
    [vc setValue:model.shop_id forKey:@"shop_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ====== Functions =======
-(void)getData{
    SHOW_HUD;
    [[WMShopDBModel shareWMShopDBModel] getShopCartDataFormDB:^(NSArray * arr) {
        HIDE_HUD;
        [self.shopCartArr removeAllObjects];
        [self.shopCartArr addObjectsFromArray:arr];
        [self.tableView reloadData];
//        self.navigationItem.title = [NSString stringWithFormat: NSLocalizedString(@"购物车(%ld)", NSStringFromClass([self class])),self.shopCartArr.count];
    }];
}

// 从数据库中删除商家
-(void)deleteShopDB:(NSIndexPath *)indexPath{
    
    [JHShowAlert showAlertWithTitle:@"" withMessage:NSLocalizedString(@"确认删除该商家的所有商品?", @"JHWaiMaiShopCartVC") withBtn_cancel:NSLocalizedString(@"取消", nil)  withBtn_sure:NSLocalizedString(@"删除", @"JHWaiMaiShopCartVC") withController:self withCancelBlock:^{
        
    } withSureBlock:^{
        __weak typeof(self) weakSelf=self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf deleteShopData:indexPath];
        });
    }];
    
}

-(void)deleteShopData:(NSIndexPath *)indexPath{
    WMShopDBModel *model = self.shopCartArr[indexPath.section];
    [[WMShopDBModel shareWMShopDBModel] deleteAllGoodsWith:model.shop_id];
    [self.shopCartArr removeObjectAtIndex:indexPath.section];
    
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

// 点击去狂狂
-(void)clickStatusBtnAction{
    [self pushToNextVcWithVcName:@"JHWaiMaiShopListVC"];
}

// 清空购物车
-(void)clickClearShopCart{
    if (self.shopCartArr.count > 0) {
        [JHShowAlert showAlertWithTitle: NSLocalizedString(@"是否要清空购物车", NSStringFromClass([self class])) withMessage:@"" withBtn_cancel: NSLocalizedString(@"取消", NSStringFromClass([self class])) withBtn_sure: NSLocalizedString(@"确定", NSStringFromClass([self class])) withController:self withCancelBlock:^{
            
        } withSureBlock:^{
            [[WMShopDBModel shareWMShopDBModel] deleteDB];
            [self getData];
        }];
    }else{
        [self showToastAlertMessageWithTitle: NSLocalizedString(@"您的购物车空空如也!", NSStringFromClass([self class]))];
    }
}

-(NSMutableArray *)shopCartArr{
    if (_shopCartArr==nil) {
        _shopCartArr=[[NSMutableArray alloc] init];
    }
    return _shopCartArr;
}
@end
