//
//  JHWaimaiOrderDetailSeeEvaluationVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailSeeEvaluationVC.h"
#import "JHWaimaiOrderSeeEvaluationHeaderCell.h"
#import "JHWaimaiOrderSeeEvaluationGoodsScoreCell.h"
#import "JHWaimaiOrderSeeEvaluationPeiScell.h"
#import "JHWaiMaiOrderViewModel.h"
@interface JHWaimaiOrderDetailSeeEvaluationVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *myTableView;//展示数据的表
@property(nonatomic,strong)JHWaimaiOrderSeeEvaliationModel *detailModel;
@end

@implementation JHWaimaiOrderDetailSeeEvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    [self getData];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"我的评价", nil);
}
-(void)getData{
    SHOW_HUD
    [JHWaiMaiOrderViewModel postToSeeEvaluationWithDic:@{@"comment_id":self.comment_id} block:^(JHWaimaiOrderSeeEvaliationModel *model, NSString *err) {
        HIDE_HUD
        if (err) {
            [self showToastAlertMessageWithTitle:err];
        }else{
            _detailModel = model;
            [self.myTableView reloadData];
        }
    }];
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
            table;
        });
    }
    return _myTableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isziti) {
        return 2;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = BACK_COLOR;
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * str = @"JHWaimaiOrderSeeEvaluationHeaderCell";
        JHWaimaiOrderSeeEvaluationHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderSeeEvaluationHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.superVC = self;
        cell.model = _detailModel;
        return cell;
    }else if (indexPath.section == 1){
        static NSString * str = @"JHWaimaiOrderSeeEvaluationGoodsScoreCell";
        JHWaimaiOrderSeeEvaluationGoodsScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderSeeEvaluationGoodsScoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.arr = _detailModel.product_list;
        return cell;

    }else{
        static NSString *str = @"JHWaimaiOrderSeeEvaluationPeiScell";
        JHWaimaiOrderSeeEvaluationPeiScell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderSeeEvaluationPeiScell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.score = _detailModel.score_peisong;
        cell.pei_time= _detailModel.songda;
        return cell;
    }
}

@end
