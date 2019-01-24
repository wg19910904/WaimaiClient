//
//  JHOldMessageListVC.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/25.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHOldMessageListVC.h"
#import "JHMyMessageCellTwo.h"
#import "JHMyMessageListModel.h"
@interface JHOldMessageListVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_mainTableView;
    NSMutableArray * _dataArr;
    NSInteger page;
}

@end

@implementation JHOldMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX(@"f6f6f6", 1);
    _dataArr = @[].mutableCopy;
  
    
    page = 1;
    [self creatTableView];
    [self initData1];
    
    [self loadData];
}
-(void)initData1{
    self.navigationItem.title = @"历史消息";
    
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

-(void)loadData{
    SHOW_HUD
    [JHMyMessageListModel getMsgListWith:@{@"type":_type,@"is_read":@"1",@"page":@(page)} block:^(NSArray *arr, NSString *msg) {
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
        [self showEmptyViewWithImgName:@"icon_mess_empty" desStr:@"还没有消息哦~" btnTitle:nil inView:tableView];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     JHMyMessageListModel * model = _dataArr[indexPath.section];
     [self pushToNextByRoute:model.order_link vc:self];
}
@end
