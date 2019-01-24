//
//  JHMessageListVC.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/25.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHMessageListVC.h"
#import "JHMyMessageCellTwo.h"
#import "JHMyMessageListModel.h"
@interface JHMessageListVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_mainTableView;
    NSMutableArray * _dataArr;
    NSInteger page;
    NSString *type;
}

@end

@implementation JHMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX(@"f6f6f6", 1);
    _dataArr = @[].mutableCopy;
    
    page = 1;
    [self creatTableView];
    if (_type == FromType1) {
        [self initData1];
    }else{
        [self initData2];
        
    }
    [self loadData];
}
-(void)initData1{
    self.navigationItem.title = @"订单消息";
    type = @"1";
}
-(void)initData2{
    self.navigationItem.title = @"温馨提示";
    type = @"2";
}
-(void)creatTableView{
    _mainTableView = [[UITableView alloc]initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.estimatedRowHeight = 100;
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.backgroundColor = HEX(@"f6f6f6", 1);
    _mainTableView.tableFooterView = self.footerView;
       __weak typeof(self) weakSelf = self;
    [_mainTableView bindHeadRefreshHandler:^{
        page = 1;
        [weakSelf loadData];
    }];
    
    [_mainTableView bindFootRefreshHandler:^{
        page++;
        [weakSelf loadData];
    }];
    
}
-(UIView *)footerView{
    UIView * footView =[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 150)];
    UIButton *oldBtn = [[UIButton alloc]init];
    [footView addSubview:oldBtn];
    [oldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 90;
        make.centerX.offset = -30;
        make.height.offset = 17;
        make.width.offset = 60;
    }];
    [oldBtn setTitle:NSLocalizedString(@"历史消息", nil) forState:0];
    [oldBtn setTitleColor:HEX(@"999999", 1) forState:0];
    oldBtn.titleLabel.font = FONT(12);
    oldBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [oldBtn addTarget:self action:@selector(clickStatusBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineV = [[UIView alloc]init];
    [footView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 91;
        make.centerX.offset = 0;
        make.height.offset = 15;
        make.width.offset = 1;
    }];
    lineV.backgroundColor = HEX(@"999999", 1);
    
    
    
    UIButton *cleanBtn = [[UIButton alloc]init];
    [footView addSubview:cleanBtn];
    [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 90;
        make.centerX.offset = 30;
        make.height.offset = 17;
        make.width.offset = 60;
    }];
    [cleanBtn setTitle:NSLocalizedString(@"一键读取", nil) forState:0];
    [cleanBtn setTitleColor:HEX(@"999999", 1) forState:0];
    cleanBtn.titleLabel.font = FONT(12);
    cleanBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cleanBtn addTarget:self action:@selector(cleanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return footView;
}
-(void)loadData{
    SHOW_HUD
    [JHMyMessageListModel getMsgListWith:@{@"type":type,@"is_read":@"0",@"page":@(page)} block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        [_mainTableView endRefresh];
        if (arr) {
            if (page == 1) {
                [_dataArr removeAllObjects];
                [_dataArr addObjectsFromArray:arr];
            }else{
                if (arr.count == 0) {
                    [self showHaveNoMoreData];
                }else {
                    [_dataArr addObjectsFromArray:arr];
                }
            }
            [_mainTableView reloadData];
        }else [self showToastAlertMessageWithTitle:msg];
        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArr.count == 0) {
        [self showEmptyViewWithImgName:@"icon_mess_empty" desStr:@"还没有消息哦~" btnTitle:@"历史消息" inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHMyMessageCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMyMessageCellTwo"];
    if (!cell) {
        cell = [[JHMyMessageCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHMyMessageCellTwo"];
    }
    cell.model = _dataArr[indexPath.section];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHMyMessageListModel * model = _dataArr[indexPath.section];
    __weak typeof(self) weakSelf = self;
    SHOW_HUD
    [JHMyMessageListModel readMsgWith:@{@"message_id":model.message_id,@"is_all":@"0"} block:^(BOOL success, NSString *msg) {
        HIDE_HUD
        if (success) {
            page = 1;
            [self loadData];
//            self pushToNextVcWithVcName:model.order_link params:<#(NSDictionary *)#>
            [self pushToNextByRoute:model.order_link vc:weakSelf];
        }else [self showToastAlertMessageWithTitle:msg];
    }];
    
}
#pragma mark ================= 点击历史消息
-(void)clickStatusBtnAction{
    [self pushToNextVcWithVcName:@"JHOldMessageListVC" params:@{@"type":type}];
}
#pragma mark ================= 一键读取
-(void)cleanBtnClick{
    SHOW_HUD
    [JHMyMessageListModel readMsgWith:@{@"message_id":@"",@"is_all":@"1",@"type":type} block:^(BOOL success, NSString *msg) {
        HIDE_HUD
        if (success) {
            page = 1;
            [self loadData];
        }else [self showToastAlertMessageWithTitle:msg];
    }];
    
}
@end
