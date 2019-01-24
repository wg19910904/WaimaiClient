//
//  JHWMHomeSearchVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMHomeSearchVC.h"
#import "YFTextField.h"
#import "HistorySearchView.h"

#import "HomeSearchResultShopGoodCell.h"
#import "JHHomeSearchResultShopHeaderView.h"
#import "YFTypeBtn.h"
#import "WMShopModel.h"
#import "WMHomeShopModel.h"
#import "WMShopGoodModel.h"

@interface JHWMHomeSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *colorStr;
}
@property(nonatomic,strong)YFTextField *searchField;
// 搜索历史的View
@property(nonatomic,strong)HistorySearchView *historySearchView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,weak)UIButton *cancleBtn;
@property(nonatomic,weak)UIButton *naviBackBtn;
@property(nonatomic,assign)int page;

@property(nonatomic,assign)BOOL show_more;// 是不是在处理展示更多商品的动画
@end

@implementation JHWMHomeSearchVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar yf_setTranslationY:-NAVI_HEIGHT];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar yf_setTranslationY:0];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    [self getData];
  
    [self setUpNaviView];
}

-(void)setUpView{
    
    self.backBtnImgName = @"";
    self.naviColor = NaVi_COLOR_Alpha(0);
    self.page = 1;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.backgroundColor = BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    
    __weak typeof(self) weakSelf=self;
    //--上拉加载
    [tableView bindFootRefreshHandler:^{
        weakSelf.page++;
        [weakSelf getData];
    }];

}

-(void)setUpNaviView{
    
    UIView *naviView = [UIView new];
    [self.view addSubview:naviView];
    [naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(NAVI_HEIGHT);
    }];
    naviView.backgroundColor = HEX(@"fafafa", 1.0);

    UIButton *naviBackBtn = [UIButton new];
    [naviView addSubview:naviBackBtn];
    [naviBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.offset(STATUS_HEIGHT);
        make.width.height.offset(44);
    }];
    [naviBackBtn setImage:IMAGE(@"nav_btn_back") forState:UIControlStateNormal];
    [naviBackBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    naviBackBtn.alpha = 0.0;
    self.naviBackBtn = naviBackBtn;
    
    [naviView addSubview:self.searchField];
    
    UIView *lineView=[UIView new];
    [naviView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    UIButton *cancleBtn = [UIButton new];
    [naviView addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.top.offset(STATUS_HEIGHT);
        make.width.height.offset(44);
    }];
    [cancleBtn setTitle: NSLocalizedString(@"取消", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [cancleBtn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = FONT(16);
    [cancleBtn addTarget:self action:@selector(clickCancle) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn = cancleBtn;
    [self.view addSubview:self.historySearchView];
    
    if (self.searchStr.length) {
        [self dealAnimationShowBack:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    WMShopModel *shop  =self.dataSource[section];
    if (shop.products.count>2) {
        return shop.is_show_more ? shop.products.count : 2;
    }else
    return shop.is_show_more ? shop.products.count: shop.products.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeSearchResultShopGoodCell *cell = [HomeSearchResultShopGoodCell initWithTableView:tableView reuseIdentifier:@"HomeSearchResultShopGoodCell"];
    WMShopModel *shop  =self.dataSource[indexPath.section];
    
    NSMutableArray *goodArr = @[].mutableCopy;
    for (NSDictionary *dic in shop.products) {
        WMShopGoodModel *model =[WMShopGoodModel mj_objectWithKeyValues:dic];
        [goodArr addObject:model];
    }
    [cell reloadCellWithModel:goodArr[indexPath.row] withStr:self.searchField.text withColor:colorStr];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WMShopModel *shop  =self.dataSource[indexPath.section];
    [self goToShopDetail:shop.shop_id];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
     __weak typeof(self) weakSelf=self;
    JHHomeSearchResultShopHeaderView *headerView = [[JHHomeSearchResultShopHeaderView alloc] initWithReuseIdentifier:@"JHHomeSearchResultShopHeaderView"];
    WMShopModel *shop =self.dataSource[section];
    [headerView reloadViewWith:shop withStr:self.searchField.text withColor:colorStr];
    headerView.clickHeaderBlock = ^(BOOL success, NSString *msg) {
        [weakSelf goToShopDetail:shop.shop_id];
    };
//    headerView.contentView.backgroundColor = RandomColor;
    return headerView;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    WMShopModel *shop  =self.dataSource[section];
    
    if (shop.products.count>2) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 48)];
        
        UIView *backView = [UIView new];
        [view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(0);
            make.right.offset(0);
            make.bottom.offset(-8);
        }];
        backView.backgroundColor = HEX(@"ffffff", 1.0);
        
        YFTypeBtn *btn = [YFTypeBtn new];
        [backView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(64);
            make.top.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
        btn.btnType = RightImage;
        btn.imageMargin = 10;
        if (!shop.is_show_more) {
            [btn setTitle:[NSString stringWithFormat:NSLocalizedString(@"展开更多商品%ld个", NSStringFromClass([self class])),(shop.products.count - 2)]  forState:UIControlStateNormal];
        }else
            [btn setTitle:NSLocalizedString(@"收起", nil) forState:UIControlStateNormal];
        
        [btn setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
        [btn setImage:IMAGE(@"btn_arrow_down_small") forState:UIControlStateNormal];
        [btn setImage:IMAGE(@"btn_arrow_top_small") forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickShowMore:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = FONT(12);
        btn.tag = 100 + section;
        
//        WMShopModel *shop =self.dataSource[section];
        btn.selected = shop.is_show_more;
        return view;
    }else{
         UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 8)];
        return view;
    }
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    WMShopModel *shop  =self.dataSource[section];

    if (shop.products.count>2) {
        return 48;
    }else
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    WMShopModel *shop  =self.dataSource[section];
    BOOL two = shop.tips_label.length > 0 && shop.huodong.count > 0;
    return two ? 70 + 30 : 70;
}

#pragma mark ====== 点击清除搜索信息的按钮 =======
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self dealAnimationShowBack:NO];
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickSearch];
    return YES;
}

#pragma mark ====== Functions =======
// 显示更多商品
-(void)clickShowMore:(UIButton *)btn{
    self.show_more = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.show_more = NO;
    });
    NSInteger section = btn.tag - 100;
    
    WMShopModel *shop  =self.dataSource[section];
    shop.is_show_more = !shop.is_show_more;
    [self.tableView reloadData];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// 店铺详情
-(void)goToShopDetail:(NSString *)shop_id{
    
    [self pushToNextVcWithVcName:@"JHWaiMaiShopDetailVC" params:@{@"shop_id":shop_id}];
}

// 搜索框的动画处理
-(void)dealAnimationShowBack:(BOOL)show{
    if (show) {
        [UIView animateWithDuration:0.25 animations:^{
            self.searchField.x = 54;
            self.cancleBtn.alpha = 0.0;
            self.naviBackBtn.alpha = 1.0;
            self.historySearchView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.view sendSubviewToBack:self.historySearchView];
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.searchField.x = 12;
            self.cancleBtn.alpha = 1.0;
            self.naviBackBtn.alpha = 0.0;
            self.historySearchView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.view bringSubviewToFront:self.historySearchView];
        }];
    }
}

// 点击搜索
-(void)clickSearch{
    
    if (self.searchField.text.length == 0 ) return;
    
    
    [self.searchField endEditing:YES];
    [self.searchField resignFirstResponder];
    
    self.page = 1;
    [self getData];
    [self dealAnimationShowBack:YES];
}

// 点击取消
-(void)clickCancle{
    
    [self.searchField endEditing:YES];
    [self.searchField resignFirstResponder];
    
    if (self.searchField.text.length > 0) {
        [self dealAnimationShowBack:YES];
    }else{
        [self clickBackBtn];
    }
}

// 获取数据
-(void)getData{
    
    
    if (self.show_more) {
        self.show_more = NO;
        [self.tableView endRefresh];
        return;
    }
    
    SHOW_HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HIDE_HUD
        [self.tableView endRefresh];
    });
    
    if (self.searchField.text.length == 0 ) {
        return;
    }

    [WMShopModel searchWMShopListWithKW:self.searchField.text page:self.page block:^(NSArray *arr, NSString *msg,NSString *colorS) {
        colorStr = colorS;
        [self.tableView endRefresh];
        if (arr.count != 0) {
            [self.historySearchView searchHistoryAddStr:self.searchField.text];
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
            //展示空 ornot
            if (self.dataSource.count == 0) {
                [self showEmptyViewWithImgName:@"icon_wu" desStr: NSLocalizedString(@"未找到相关内容", NSStringFromClass([self class])) btnTitle:nil inView:_tableView];
            }else{
                [self hiddenEmptyView];
            }
            
            [_tableView reloadData];
            
            
        }else
            [self showToastAlertMessageWithTitle:msg];
        
    }];
    
    [self.tableView reloadData];

}

#pragma mark ====== 懒加载 =======
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(YFTextField *)searchField{
    if (_searchField==nil) {
        UIButton *btn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 30, 30)];
        [btn setImage:IMAGE(@"nav_btn_search_gray") forState:UIControlStateNormal];
        
        _searchField=[[YFTextField alloc] initWithFrame:CGRectMake(12, STATUS_HEIGHT + 7, WIDTH - 12 - 54, 30) leftView:btn rightView:nil];
        _searchField.letfMargin = 5;
        _searchField.rightMargin = 0;
        _searchField.font = FONT(14);
        _searchField.placeholdeFont = FONT(14);
        _searchField.textColor = HEX(@"333333", 1.0);
        _searchField.placeholdeColor = HEX(@"666666", 1.0);
        _searchField.delegate = self;
        _searchField.placeholder = NSLocalizedString(@"输入商家或商品名称", @"JHWMHomeSearchVC");
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.backgroundColor = HEX(@"999999", 0.3);
        _searchField.layer.cornerRadius=4;
        _searchField.clipsToBounds=YES;
    }
    return _searchField;
}


-(HistorySearchView *)historySearchView{
    if (_historySearchView==nil) {
        __weak typeof(self) weakSelf=self;
        _historySearchView=[[HistorySearchView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT)];
        _historySearchView.backgroundColor =HEX(@"ffffff", 1.0);
        _historySearchView.historyCashDataFilePath = @"JHHomeSearchHistory";
        _historySearchView.hotSearchUrl = @"client/waimai/shop/hotsearch";
        _historySearchView.clickTitle = ^(NSString *title){
            weakSelf.searchField.text = title;
            [weakSelf clickSearch];
        };
    }
    return _historySearchView;
}

- (void)setSearchStr:(NSString *)searchStr{
    _searchStr = searchStr;
    if (searchStr.length) {
        self.searchField.text = searchStr;
    }
}
@end

