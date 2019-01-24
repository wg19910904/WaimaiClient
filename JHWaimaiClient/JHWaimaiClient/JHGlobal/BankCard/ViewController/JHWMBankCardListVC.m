//
//  JHWMBankCardListVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMBankCardListVC.h"
#import "MineBankCardListCell.h"

@interface JHWMBankCardListVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,weak)MineBankModel *choosed_model;
@end

@implementation JHWMBankCardListVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    [self getData];
    
}

-(void)setUpView{
    
    self.navigationItem.title = NSLocalizedString(@"我的信用卡", NSStringFromClass([self class]));
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT - 40) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    UIButton *addCardBtn = [UIButton new];
    [self.view addSubview:addCardBtn];
    [addCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.right.offset=0;
        make.height.offset=40;
    }];
    addCardBtn.titleLabel.font = FONT(16);
    addCardBtn.backgroundColor = [UIColor whiteColor];
    [addCardBtn setTitle: NSLocalizedString(@"+ 添加信用卡", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [addCardBtn setTitleColor:THEME_COLOR_Alpha(1.0) forState:UIControlStateNormal];
    [addCardBtn addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataSource.count == 0) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr: NSLocalizedString(@"您还未添加信用卡", NSStringFromClass([self class])) btnTitle:nil inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"MineBankCardListCell";
    MineBankCardListCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[MineBankCardListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    MineBankModel *model = self.dataSource[indexPath.section];
    if ([model.card_id isEqualToString:self.card_id]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        self.choosed_model = model;
    }
    [cell reloadCellWithModel:model is_choose:self.is_choose];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.is_choose) {
        [self.navigationController popViewControllerAnimated:YES];
        YF_SAFE_BLOCK(self.chooseBank,self.dataSource[indexPath.section],nil);
    }else{
        __weak typeof(self) weakSelf=self;
       void(^block)(BOOL ,NSString *) = ^(BOOL success,NSString *msg){
           if (success) {
               [weakSelf getData];
           }
        };
        [self pushToNextVcWithVcName:@"JHWMAddBankCardVC" params:@{@"model":self.dataSource[indexPath.section],@"successBlock":block}];
    }
}

#pragma mark ====== Functions =======
-(void)clickBackBtn{
    [super clickBackBtn];
    if (self.is_choose) {
        YF_SAFE_BLOCK(self.chooseBank,self.choosed_model,nil);
    }
}

-(void)getData{

    SHOW_HUD
    [MineBankModel getCardListWith:^(NSArray *arr, NSString *msg) {
        
        HIDE_HUD
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:arr];
        [self.tableView reloadData];
        
    }];
    
}

// 添加信用卡
-(void)addCard{
    __weak typeof(self) weakSelf=self;
     void(^block)(BOOL ,NSString *) = ^(BOOL success,NSString *msg){
         if (success) {
             [weakSelf getData];
         }
     };
     [self pushToNextVcWithVcName:@"JHWMAddBankCardVC" params:@{@"successBlock":block}];
}

#pragma mark ====== 懒加载 =======
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end
