//
//  JHMyMessageVC.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/25.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHMyMessageVC.h"
#import "JHMyMessageCell.h"
#import "JHMessageListVC.h"
#import "JHMyMessageModel.h"
@interface JHMyMessageVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_mainTableView;
    NSMutableArray * _dataArr;
}

@end

@implementation JHMyMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的消息";
    _dataArr = @[].mutableCopy;
    [self creatTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}
-(void)getData{
    [HttpTool postWithAPI:@"client/member/msg/index" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if (ISPostSuccess) {
            [_dataArr removeAllObjects];
            NSArray * orderArr = json[@"data"][@"order_msg"][@"msg"];
            JHMyMessageModel *model1 = [JHMyMessageModel new];
            if (orderArr.count>0) {
                NSDictionary *dic = orderArr[0];
                model1.content = dic[@"content"];
                model1.is_read = json[@"data"][@"order_msg"][@"read_count"];
                model1.dateline = dic[@"dateline"];
            }else{
                model1.content = @"暂无消息";
                model1.is_read = json[@"data"][@"order_msg"][@"read_count"];
                model1.dateline = @"";
                
            }
            [_dataArr addObject:model1];
            
            NSArray * otherArr = json[@"data"][@"other_msg"][@"msg"];
            JHMyMessageModel *model2 = [JHMyMessageModel new];
            if (otherArr.count>0) {
                NSDictionary *dic = otherArr[0];
                model2.content = dic[@"content"];
                model2.is_read = json[@"data"][@"other_msg"][@"read_count"];
                model2.dateline = dic[@"dateline"];
            }else{
                model2.content = @"暂无消息";
                model2.is_read = json[@"data"][@"other_msg"][@"read_count"];
                model2.dateline = @"";
                
            }
            [_dataArr addObject:model2];
           
            
        }else{
            [self showToastAlertMessageWithTitle:Error_Msg];
        }
        [_mainTableView reloadData];
    } failure:^(NSError *error) {
        [self showToastAlertMessageWithTitle:NOTCONNECT_STR];
    }];
}
-(void)creatTableView{
    _mainTableView = [[UITableView alloc]initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.estimatedRowHeight = 100;
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.backgroundColor = BACK_COLOR;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHMyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMyMessageCell"];
    if (!cell) {
        cell = [[JHMyMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHMyMessageCell"];
    }
    cell.dic = self.array[indexPath.row];
    cell.model = _dataArr[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHMessageListVC *vc = [[JHMessageListVC alloc]init];
    if (indexPath.row == 0) {
         vc.type = FromType1;
    }else{
         vc.type = FromType2;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(NSArray *)array{
    return @[@{@"image":@"icon_messD",@"title":@"订单消息"},@{@"image":@"icon_messW",@"title":@"温馨提示"}];
}

@end
