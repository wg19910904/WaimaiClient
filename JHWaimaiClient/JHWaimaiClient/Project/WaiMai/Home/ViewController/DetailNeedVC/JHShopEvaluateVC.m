//
//  JHShopEvaluateVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHShopEvaluateVC.h"
#import "WMShopEvaluateHeadView.h"

#import "WMEvaluateCell.h"

@interface JHShopEvaluateVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)WMShopEvaluateHeadView *evaluateHeadView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int type;// 要查看的评价内容
@property(nonatomic,assign)int is_null;// 是否显示有内容的评价

@property(nonatomic,assign)BOOL is_firstLoad;
@property(nonatomic,strong)NSDictionary *evaluateDic;
@property(nonatomic,weak)WMShopEvaluateHeadView *headView;

@end

@implementation JHShopEvaluateVC

-(void)dealloc{
    Remove_Notice
}

-(void)loadView{
    
    [super loadView];
    [self setUpView];
    [NoticeCenter addObserver:self selector:@selector(tableViewScrollsToTop) name:ScrollToTop object:nil];
    self.page = 1;
    self.type = 0;
    self.is_null = 0;
    self.is_firstLoad = YES;
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    self.tableView=tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];

    __weak typeof(self) weakSelf=self;
    //--上拉加载
    [tableView bindFootRefreshHandler:^{
        weakSelf.page++;
        [weakSelf getData];
    }];
    //---
    

    WMShopEvaluateHeadView *headView = [[WMShopEvaluateHeadView alloc] initWithFrame:FRAME(0, 0, WIDTH, 215)];
    headView.chooseShowEvaluateType = ^(NSInteger index,BOOL showContent){
        weakSelf.type = (int)index;
        weakSelf.is_null = showContent ? 1 : 0;
        weakSelf.page = 1;
        weakSelf.is_firstLoad = YES;
        [weakSelf getData];
    };
    tableView.tableHeaderView = headView;
    self.headView = headView;
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!self.evaluateDic) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr:nil btnTitle:nil inView:self.view];
    }else{
        [self hiddenEmptyView];
    }
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"WMEvaluateCell";
    WMEvaluateCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[WMEvaluateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.superVC = self.superVC;
    }
    WMEvaluateModel *model = self.dataSource[indexPath.row];
    [cell reloadCellWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark ====== Functions =======
// 通知的方法
-(void)tableViewScrollsToTop{
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

// 获取数据
-(void)getData{
    
    if (self.evaluateDic && !self.is_firstLoad && self.page == 1) return;
//    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) return;
    
    SHOW_HUD_INVIEW(self.superVC.view);
    [WMEvaluateModel getEvaluateListWith:self.shop_id page:self.page type:self.type is_null:self.is_null block:^(NSArray *dataArr, NSDictionary *scoreDic, NSArray *typeArr, NSString *msg) {
        
        HIDE_HUD_FOR_VIEW(self.superVC.view);
        [self.tableView endRefresh];
        if (dataArr) {
            self.is_firstLoad = NO;
            if (self.page == 1) {
                self.evaluateDic = scoreDic;
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:dataArr];
                [self.headView reloadViewWithEvaluate:scoreDic type:typeArr];
            }else{
                if (dataArr.count == 0) {
                    self.page -= 1;
                    [self showHaveNoMoreData];
                }else {
                    [self.dataSource addObjectsFromArray:dataArr];
                }
            }
            if (dataArr.count<10) {
            }
            
            [self.tableView reloadData];
            
        }else [self showToastAlertMessageWithTitle:msg];
        
    }];
    
}

#pragma mark ====== 懒加载 =======
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end

