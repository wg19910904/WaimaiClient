//
//  JHWaimaiMyBalanceVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiMyBalanceVC.h"
#import "JHWaimaiBalanceHeaderCell.h"
#import "JHWaimaiBalanceRecorderCell.h"
#import "JHWaimaiRechargeVC.h"

#import "JHWaimaiMineViewModel.h"
#import "JHWaimaiMyBalanceListModel.h"
#import "JHTiXianView.h"
@interface JHWaimaiMyBalanceVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
}
@property(nonatomic,strong)UITableView *myTableView;//表视图
@property(nonatomic,strong)NSMutableArray *infoArr;//保存数据的
@property(nonatomic,strong)JHWaimaiMyBalanceListModel *detailModel;
@property(nonatomic,strong)JHTiXianView *tixianView;//提现的view
@end

@implementation JHWaimaiMyBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //添加表视图
    [self myTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"我的余额", nil);
    [self.navigationController.navigationBar setTintColor:HEX(@"333333", 1.0)];
    if ([JHUserModel shareJHUserModel].allow_tixian.integerValue == 1) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"申请提现",nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickTiXian)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    page = 1;
}
-(void)clickTiXian{
    [self tixianView];
}
-(JHTiXianView *)tixianView{
    if (!_tixianView) {
        _tixianView = [[JHTiXianView alloc]init];
        _tixianView.superVC = self;
    }
    [_tixianView showAniamtion];
    return _tixianView;
}
-(NSMutableArray *)infoArr{
    if (!_infoArr) {
        _infoArr = @[].mutableCopy;
    }
    return _infoArr;
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.rowHeight = UITableViewAutomaticDimension;
            table.estimatedRowHeight = 100;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = [UIColor whiteColor];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            table;
        });
    }
    return _myTableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?1:self.infoArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = BACK_COLOR;
        label.textColor = HEX(@"666666", 1);
        label.font = FONT(15);
        label.text = [NSString stringWithFormat:@"   %@%@%@",NSLocalizedString(@"最近", nil),_detailModel.total_count,NSLocalizedString(@"条余额明细", nil)];
        return label;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * str = @"JHWaimaiBalanceHeaderCell";
        JHWaimaiBalanceHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiBalanceHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.money = _detailModel.money;
        __weak typeof (self)weakSelf = self;
        [cell setMyBlock:^{
            [weakSelf clickRecharge];
        }];
        
        return cell;
 
    }else{
        static NSString * str = @"JHWaimaiBalanceRecorderCell";
        JHWaimaiBalanceRecorderCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiBalanceRecorderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        JHWaimaiMyBalaceListDetailModel *model = _infoArr[indexPath.row];
        cell.model = model;
        return cell;
    }
    
}
#pragma mark - 这是下拉刷新
-(void)downRefresh{
    page = 1;
    [self loadData];
}
#pragma mark - 上拉加载
-(void)upLoadData{
    page ++;
    [self loadData];
}
#pragma mark - 这是获取数据的方法
-(void)loadData{
    SHOW_HUD
    [JHWaimaiMineViewModel postToGetBalanceRecorderWithDic:@{@"page":@(page)} block:^(JHWaimaiMyBalanceListModel *model, NSString *error) {
        HIDE_HUD
        if (error) {
            [self showToastAlertMessageWithTitle:error];
        }else{
            if (page == 1) {
                [self.infoArr removeAllObjects];
            }
             [self.infoArr addObjectsFromArray:model.items];
            _detailModel = model;
            [_myTableView reloadData];
        }
        [_myTableView endRefresh];
    }];
   
}
#pragma mark - 这是点击去充值的方法
-(void)clickRecharge{
    NSLog(@"点击去充值");
    JHWaimaiRechargeVC *vc = [[JHWaimaiRechargeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
