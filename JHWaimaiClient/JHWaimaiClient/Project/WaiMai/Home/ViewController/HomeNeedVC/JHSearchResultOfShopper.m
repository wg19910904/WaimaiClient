//
//  JHSearchResultOfShopper.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHSearchResultOfShopper.h"
#import "WaiMaiShoperCell.h"


@interface JHSearchResultOfShopper ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)int page;
@property(nonatomic,copy)NSString *keyword;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation JHSearchResultOfShopper

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    self.page = 1;
}

-(void)setUpView{
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - NAVI_HEIGHT - 40 ) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 170;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    self.tableView=tableView;

    __weak typeof(self) weakSelf=self;
    //--下拉加载
    [tableView bindHeadRefreshHandler:^{
        weakSelf.page=1;
        [weakSelf getData];
    }];
    //--上拉加载
    [tableView bindFootRefreshHandler:^{
        weakSelf.page++;
        [weakSelf getData];
    }];
    //---
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count == 0) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr:@"" btnTitle:nil inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"WaiMaiShoperCell";
    WaiMaiShoperCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[WaiMaiShoperCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    WMHomeShopModel *shop = self.dataSource[indexPath.row];
    
    [cell reloadCellWithModel:shop];
    cell.clickShowMore = ^(){
        shop.shop.showMore = !shop.shop.showMore;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    __weak typeof(self) weakSelf=self;
    cell.goShopDetail = ^(NSString *good_id){
        [weakSelf goShopDetail:shop.shop.shop_id good_id:good_id];
    };
    
    return cell;
}
#pragma mark ======Functions=======
// 点击不同商家
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMHomeShopModel *shop = self.dataSource[indexPath.row];
    [self goShopDetail:shop.shop.shop_id good_id:nil];
    
}

// 前往商家详情界面
-(void)goShopDetail:(NSString *)shop_id good_id:(NSString *)good_id{
    JHBaseVC *vc = [NSClassFromString(@"JHWaiMaiShopDetailVC") new];
    [vc setValue:shop_id forKey:@"shop_id"];
    [vc setValue:good_id forKey:@"good_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

// 根据搜索关键词搜索内容
-(void)getDataWithKeyword:(NSString *)keyword{
    self.page = 1;
    self.keyword = keyword;
    [self getData];
}

// 获取数据
-(void)getData{
    SHOW_HUD
    [WMHomeShopModel searchWMShopListWithKW:self.keyword page:self.page block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        
        [self.tableView endRefresh];
        if (arr.count != 0) {
            [self.historySearchView searchHistoryAddStr:self.keyword];
        }
        if (arr) {
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:arr];
            }else{
                if (arr.count == 0) {
                    [self showHaveNoMoreData];
                }else {
                    [self.dataSource addObjectsFromArray:arr];
                }
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
