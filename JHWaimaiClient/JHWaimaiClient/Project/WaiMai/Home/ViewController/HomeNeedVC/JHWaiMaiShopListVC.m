//
//  JHWaiMaiShopListVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/4.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiShopListVC.h"
#import "JHHomeShopCell.h"

#import "YFWMFilterView.h"
#import "JHWaimaiHomeShopModel.h"
#import "JHWaimaiHomeModel.h"
@interface JHWaiMaiShopListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)JHWaimaiHomeShopListAndHongbao *waimaiShopListAndHongbao;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@property(nonatomic,weak)YFWMFilterView *filterView;
@property(nonatomic,strong)NSMutableDictionary *filterDic;
@end

@implementation JHWaiMaiShopListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataSource.count > 0) {
        NSArray *arr = [self.tableView indexPathsForVisibleRows];
        [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.page = 1;
    self.dataSource = @[].mutableCopy;
    [self setUpView];
    [self getData];
    
}

-(void)setUpView{
    
    self.navigationItem.title = NSLocalizedString(@"商家列表", @"JHWaiMaiShopListVC");

    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, (NAVI_HEIGHT +44), WIDTH, HEIGHT-(NAVI_HEIGHT +44)) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 170;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=(NAVI_HEIGHT +44);
        make.width.offset=WIDTH;
        make.bottom.offset= -SYSTEM_GESTURE_HEIGHT;
    }];
    
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
    

    YFWMFilterView *filterView = [[YFWMFilterView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 44) titleArr:@[NSLocalizedString(@"全部分类   ",nil),NSLocalizedString(@"排序   ",nil),NSLocalizedString(@"筛选   ",nil)]];
    filterView.firstSelectedType = _cate_id;
    [self.view addSubview:filterView];
    [filterView getData];
    filterView.chooseFilter = ^(NSString *cate_id,NSString *order,NSString *pei_filter,NSString *youhui_filter,
                                NSString *feature_filter,int filterIndex,NSString *title1,NSString *title2,NSString *title3){
        if (filterIndex == 1) {
            weakSelf.filterDic[@"cate_id"] = cate_id;
        }else if (filterIndex == 2){
            weakSelf.filterDic[@"order"] = order;
        }else{
            weakSelf.filterDic[@"pei_filter"] = pei_filter;
            weakSelf.filterDic[@"youhui_filter"] = youhui_filter;
            weakSelf.filterDic[@"feature_filter"] = feature_filter;
        }
        weakSelf.page = 1;
        [weakSelf getData];
    };
    self.filterView = filterView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count == 0) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr:nil btnTitle:nil inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"JHHomeShopCellID";
    JHHomeShopCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[JHHomeShopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    JHWaimaiHomeShopModel *shopModel = self.dataSource[indexPath.row];
    
    cell.dataModel = shopModel;
    [cell.huodongCountBtn addTarget:self action:@selector(clickCellHuodongBtn:event:)
                   forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHWaimaiHomeShopModel *shopModel = self.dataSource[indexPath.row];
    [self goShopDetail:shopModel.shop_id good_id:nil];
}

// 前往商家详情界面
-(void)goShopDetail:(NSString *)shop_id good_id:(NSString *)good_id{
    JHBaseVC *vc = [NSClassFromString(@"JHWaiMaiShopDetailVC") new];
    [vc setValue:shop_id forKey:@"shop_id"];
    [vc setValue:good_id forKey:@"good_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ====== Functions =======
-(void)getData{
    SHOW_HUD
    self.filterDic[@"page"] = @(_page);
    [HttpTool postWithAPI:@"client/waimai/shop/shoplist"
               withParams:self.filterDic
                  success:^(id json) {
                      HIDE_HUD
                      if (ERROR_O) {
                          if (self.page == 1) {
                              [_dataSource removeAllObjects];
                          }
                        _waimaiShopListAndHongbao = [JHWaimaiHomeShopListAndHongbao mj_objectWithKeyValues:json[@"data"]];
                        [_dataSource addObjectsFromArray:_waimaiShopListAndHongbao.items];
                        
                        [_tableView reloadData];
                        if (_waimaiShopListAndHongbao.items.count == 0) {
                            [self showHaveNoMoreData];
                        }
                          
                      }else{
                          [self showToastAlertMessageWithTitle:json[@"message"]];
                      }
                      [self.tableView endRefresh];
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [self.tableView endRefresh];
                  }];

}

#pragma mark ====== 懒加载 =======
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSMutableDictionary *)filterDic{
    if (_filterDic==nil) {
        _filterDic=[[NSMutableDictionary alloc] init];
        _filterDic[@"cate_id"] = _cate_id.length == 0 ? @"0" : _cate_id ;
        _filterDic[@"order"] = @"";
        _filterDic[@"pei_filter"] = @"";
        _filterDic[@"youhui_filter"] = @"";
        _filterDic[@"feature_filter"] = @"";
        _filterDic[@"page"] = @(1);
    }
    return _filterDic;
}
#pragma mark - 点击了cell内的展示活动按钮
- (void)clickCellHuodongBtn:(UIButton *)sender event:(UIEvent *)event{
    UITouch *onetouch = [event.allTouches anyObject];
    CGPoint touch_p = [onetouch locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:touch_p];
    //获取row
    JHWaimaiHomeShopModel *shopModel = _dataSource[indexPath.row];
    shopModel.showMoreHuodong = !shopModel.showMoreHuodong;
    //刷新cell
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}


@end
