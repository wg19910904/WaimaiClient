//
//  JHWaiMaiAddressVC.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiAddressVC.h"

#import "JHWaiMaiAddressListCell.h"
#import "NSObject+XHTool.h"
#import "JHWaiMaiAddOrModifyAddressVC.h"
#import "JHShowAlert.h"
#import "JHWaimaiMineViewModel.h"

@interface JHWaiMaiAddressVC ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *emptyView;
}
@property(nonatomic,strong)UITableView *addressTable;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UIButton *addBtn; //底部添加按钮
@property(nonatomic,strong)NSMutableArray *infoArr;//数据模型
@end

@implementation JHWaiMaiAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoArr = @[].mutableCopy;
    self.navigationItem.title = NSLocalizedString(@"我的收货地址", nil);
    //添加表
    [self.view addSubview:self.addressTable];
    //添加底部按钮
//    [self.view addSubview:self.addBtn];
    [self addRightBtn];
}
-(void)addRightBtn{
    
    [self addRightTitleBtn:NSLocalizedString(@"新增", nil) titleColor:HEX(@"FA4C34",1) sel:@selector(clickAddBtn:)];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取数据
    [self postToGetData];
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_infoArr.count == 0) {
        [self showEmpytView];
//        [self showEmptyViewWithImgName:@"mall_my_icon_location_no" desStr:NSLocalizedString(@"您还未添加收货地址", nil) btnTitle:nil inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    return _infoArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JHWaiMaiAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[JHWaiMaiAddressListCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                              reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JHWaimaiMineAddressListDetailModel * model = _infoArr[indexPath.section];
    BOOL is_paotui_chooseAddr = self.is_paotui && self.selectorBlock ;
    [cell reloadCellWithModel:model is_choose_paotui:is_paotui_chooseAddr];
    
    if (self.addr_id) {
        cell.addr_id = self.addr_id;
    }
    [cell.editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.shop_id&&self.selectorBlock ) || (self.is_paotui &&self.selectorBlock)) {
        
        JHWaimaiMineAddressListDetailModel *model = _infoArr[indexPath.section];
        if (self.order_price < [model.min_price floatValue] && !self.is_paotui) {
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"您的订单价格小于起送价!", nil)];
            return;
        }
        
        if (self.is_paotui && model.is_available == 0) {
           [self showToastAlertMessageWithTitle:NSLocalizedString(@"当前地址不在配送范围内", nil)];
            return;
        }
        
        YF_SAFE_BLOCK(self.selectorBlock,model);
        self.addr_id = model.addr_id;
        [tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark - 点击添加地址按钮
- (void)clickAddBtn:(UIButton *)sender{
    JHWaiMaiAddOrModifyAddressVC *addVC = [JHWaiMaiAddOrModifyAddressVC new];
    addVC.vctype = E_addAddress_vc;
    addVC.is_paotui = self.is_paotui;
    [self.navigationController pushViewController:addVC animated:YES];
}
- (UITableView *)addressTable{

    if (_addressTable == nil) {
        _addressTable = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT)
                                style:(UITableViewStyleGrouped)];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.estimatedRowHeight = 120;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            __weak typeof(self) weakSelf=self;
            //--下拉加载
            [tableView bindHeadRefreshHandler:^{
                [weakSelf refreshData];
            }];
            
            tableView.backgroundColor = BACK_COLOR;
            tableView;
        });
    }
    return _addressTable;
}

- (UIButton *)addBtn{
    if (_addBtn == nil) {
        _addBtn = [[UIButton alloc] initWithFrame:FRAME(12, HEIGHT - 50 - SYSTEM_GESTURE_HEIGHT, WIDTH-24, 40)];
        [_addBtn setBackgroundColor:THEME_COLOR_Alpha(1.0) forState:(UIControlStateNormal)];
        [_addBtn setBackgroundColor:THEME_COLOR_Alpha(0.9) forState:(UIControlStateHighlighted)];
        [_addBtn setTitle:NSLocalizedString(@"添加收货地址 +", nil) forState:(UIControlStateNormal)];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _addBtn.titleLabel.font = FONT(16);
        _addBtn.layer.cornerRadius = 4;
        _addBtn.clipsToBounds = YES;
        [_addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addBtn;
}

#pragma mark - 点击cell内的编辑按钮
- (void)clickEditBtn:(UIButton *)sender{
    //获取cell
    JHWaiMaiAddressListCell *cell = (JHWaiMaiAddressListCell *)[[sender superview] superview];
    NSIndexPath *indexpath = [self.addressTable indexPathForCell:cell];
     JHWaimaiMineAddressListDetailModel *detailModel = _infoArr[indexpath.section];
    JHWaiMaiAddOrModifyAddressVC *addVC = [[JHWaiMaiAddOrModifyAddressVC alloc]init];
    addVC.is_paotui = self.is_paotui;
    addVC.vctype = E_ModifyAddress_vc;
    addVC.detailModel = detailModel;
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark - 点击cell内的删除按钮
- (void)clickDeleteBtn:(UIButton *)sender{
    //获取cell
    JHWaiMaiAddressListCell *cell = (JHWaiMaiAddressListCell *)[[sender superview] superview];
    NSIndexPath *indexpath = [self.addressTable indexPathForCell:cell];
    //获取模型
    [JHShowAlert showAlertWithTitle:NSLocalizedString(@"确定删除该地址", nil)
                        withMessage:@""
                     withBtn_cancel:NSLocalizedString(@"否", nil) withBtn_sure:NSLocalizedString(@"是", nil)
                     withController:self
                    withCancelBlock:nil withSureBlock:^{
                        [self removeAddress:indexpath];
                    }];
}
#pragma mark - 这是删除地址的方法
-(void)removeAddress:(NSIndexPath *)indexP{
    JHWaimaiMineAddressListDetailModel *model = _infoArr[indexP.section];
    SHOW_HUD
    [JHWaimaiMineViewModel postToRemoveAddressWithDic:@{@"addr_id":model.addr_id} block:^(NSString *error) {
        HIDE_HUD
        if (error) {
            [self showToastAlertMessageWithTitle:error];
        }else{
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"你已成功删除该地址!", nil)];
            [_infoArr removeObjectAtIndex:indexP.section];
            [_addressTable deleteSections:[NSIndexSet  indexSetWithIndex:indexP.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}
#pragma mark - 下拉刷新的方法调用
-(void)refreshData{
    [self postToGetData];
}
#pragma mark - 这是请求数据的
-(void)postToGetData{
    if (_shop_id) {
        SHOW_HUD
        [JHWaimaiMineViewModel postToGetShopAddressWithDic:@{@"shop_id":self.shop_id} block:^(JHWaimaiMineAddressListModel * model, NSString *error) {
            HIDE_HUD
            if (error) {
                [self showToastAlertMessageWithTitle:error];
            }else{
                NSMutableArray *selectorArr = @[].mutableCopy;
                NSMutableArray *notSelectorArr = @[].mutableCopy;
                NSMutableArray *tempArr = @[].mutableCopy;
                for (JHWaimaiMineAddressListDetailModel *mod in model.items) {
                    if ([mod.is_in integerValue] == 1 && self.order_price >= [mod.min_price floatValue]) {
                        [selectorArr addObject:mod];
                    }else if ([mod.is_in integerValue] == 1 && self.order_price < [mod.min_price floatValue]){
                        [tempArr addObject:mod];
                    }
                    else{
                        [notSelectorArr addObject:mod];
                    }
                }
                [_infoArr removeAllObjects];
                [_infoArr addObjectsFromArray:selectorArr];
                [_infoArr addObjectsFromArray:tempArr];
                [_infoArr addObjectsFromArray:notSelectorArr];
                [_addressTable reloadData];
            }
            [_addressTable endRefresh];
        }];
    }else{
        SHOW_HUD
        BOOL is_paotui_chooseAddr = self.is_paotui && self.selectorBlock ;
        [JHWaimaiMineViewModel postToGetMyAddressWithDic:@{} is_paotui:is_paotui_chooseAddr block:^(JHWaimaiMineAddressListModel * model, NSString *error) {
            HIDE_HUD
            if (error) {
                [self showToastAlertMessageWithTitle:error];
            }else{
                [_infoArr removeAllObjects];
                [_infoArr addObjectsFromArray:model.items];
                [_addressTable reloadData];
            }
            [_addressTable endRefresh];
            
        }];
 
   }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)showEmpytView{
    
    if (!emptyView) {
        emptyView = [[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-NAVI_HEIGHT)];
        emptyView.backgroundColor = [UIColor whiteColor];
        [_addressTable addSubview:emptyView];
        UIImageView *imageV = [[UIImageView alloc]init];
        [emptyView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 80;
            make.centerX.offset = 0;
            make.width.height.offset = 110;
        }];
        imageV.image = IMAGE(@"empty_place");
        
        UILabel *label1 = [[UILabel alloc]init];
        [emptyView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageV.mas_bottom).offset = 32;
            make.centerX.offset = 0;
            make.width.offset = WIDTH;
            make.height.offset = 22;
        }];
        label1.text = NSLocalizedString(@"您还没有收货地址哦", nil);
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = FONT(16);
        label1.textColor = HEX(@"333333", 1);
        
        UILabel *label2 = [[UILabel alloc]init];
        [emptyView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).offset = 9;
            make.centerX.offset = 0;
            make.width.offset = WIDTH;
            make.height.offset = 20;
        }];
        label2.text = NSLocalizedString(@"赶紧添加吧～", nil);
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = FONT(14);
        label2.textColor = HEX(@"999999", 1);
        
        
        UIButton *addB = [[UIButton alloc]init];
        [emptyView addSubview:addB];
        [addB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label2.mas_bottom).offset = 50;
            make.centerX.offset = 0;
            make.width.offset = 200;
            make.height.offset = 48;
        }];
        addB.layer.borderWidth = 1.f;
        addB.layer.borderColor = HEX(@"4DC831", 1).CGColor;
        [addB setTitle:@"+新增收获地址" forState:0];
        [addB setTitleColor:HEX(@"4DC831", 1) forState:0];
        addB.titleLabel.font= FONT(16);
        addB.titleLabel.textAlignment = NSTextAlignmentCenter;
        [addB addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)hiddenEmptyView{
    [emptyView removeFromSuperview];
    emptyView = nil;
}
@end
