//
//  JHMoreAddrVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/1/8.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHMoreAddrVC.h"
#import "YFSegmentedControl.h"
#import "JHAddrSearchBaseVC.h"
#import "YFTypeBtn.h"
#import "JHChooseCityVC.h"
#import "XHMapKitHeader.h"
#import "GaoDe_Convert_BaiDu.h"


@interface JHMoreAddrVC ()<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)YFSegmentedControl *segmentControl;
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *subVCArr;
@property(nonatomic,assign)BOOL is_first_loadData;
@property(nonatomic,weak)YFTypeBtn *cityBtn;
@property(nonatomic,weak)UITextField *searchField;

@property(nonatomic,strong)UITableView *searchTableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)BOOL is_search;
@property(nonatomic,copy)NSString *temp_city_id;
@end

@implementation JHMoreAddrVC
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    if (!self.is_first_loadData) {
//        JHAddrSearchBaseVC * vc = self.subVCArr[self.segmentControl.selectedSegmentIndex];
//        vc.city = self.currentCity;
//        [vc reloadData];
//    }
//}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpNavi];
    [self setUpView];
    [self createSearchField];
    self.page = 1;
    self.is_first_loadData = NO;
    
}

-(void)setUpNavi{
  
    YFTypeBtn *cityBtn = [[YFTypeBtn alloc]init];
    cityBtn.btnType = RightImage;
    cityBtn.imageMargin = 5;
    [cityBtn setFrame:CGRectMake(12 ,8, 55, 30)];
    [cityBtn addTarget:self action:@selector(clickHandSearch:) forControlEvents:UIControlEventTouchUpInside];
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cityBtn.titleLabel.font = FONT(12);
    [cityBtn setImage:IMAGE(@"arrow_city_white") forState:UIControlStateNormal];
    NSString *cityString = [JHConfigurationTool shareJHConfigurationTool].cityName;
    cityString = cityString ? cityString : NSLocalizedString(@"城市", @"JHAddressMainVC");
    [cityBtn setTitle:cityString forState:(UIControlStateNormal)];
    self.cityBtn = cityBtn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];
    
    [self addRightTitleBtn:NSLocalizedString(@"取消", nil) titleColor:[UIColor whiteColor] sel:@selector(clickBackBtn)];
}

- (void)createSearchField
{
    UITextField *searchField = [[UITextField alloc] initWithFrame:FRAME(70, 7.5, WIDTH-80,30)];
    searchField.layer.cornerRadius = 15;
    searchField.layer.masksToBounds = YES;
    searchField.backgroundColor = HEX(@"f7f7f7", 1.0f);
    searchField.layer.borderColor = LINE_COLOR.CGColor;
    searchField.layer.borderWidth = 0.7;
    searchField.placeholder = NSLocalizedString(@"小区/写字楼/学校等", nil);
    searchField.textColor = HEX(@"333333", 1.0);
    searchField.font = FONT(14);
    searchField.delegate = self;
    searchField.returnKeyType = UIReturnKeySearch;
    self.searchField = searchField;
    self.navigationItem.titleView = searchField;

    UIButton *searchBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 30, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"btn_search_gray"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAddr) forControlEvents:UIControlEventTouchUpInside];
    searchField.rightView = searchBtn;
    searchField.rightViewMode = UITextFieldViewModeAlways;
    
    searchField.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 20, 10)];
    searchField.leftViewMode = UITextFieldViewModeAlways;
}
-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    NSArray *titleArr = @[
                          @{@"title": NSLocalizedString(@"全部", NSStringFromClass([self class]))},
                          @{@"title": NSLocalizedString(@"写字楼", NSStringFromClass([self class]))},
                          @{@"title": NSLocalizedString(@"小区", NSStringFromClass([self class]))},
                          @{@"title": NSLocalizedString(@"学校", NSStringFromClass([self class]))}
                          ];
    self.subVCArr = [NSMutableArray array];
    for (NSInteger i=0; i<titleArr.count; i++) {
        JHAddrSearchBaseVC *vc = [JHAddrSearchBaseVC new];
        vc.index = i;
        vc.superVC = self;
        [self.subVCArr addObject:vc];
       
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT+44, WIDTH, HEIGHT - NAVI_HEIGHT -44)];
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(WIDTH * titleArr.count, HEIGHT - NAVI_HEIGHT -44);
   
    JHAddrSearchBaseVC *vc = self.subVCArr[0];
    vc.view.frame = FRAME(0, 0, WIDTH, HEIGHT - NAVI_HEIGHT -44);
    [scrollView addSubview:vc.view];
    vc.city = self.currentCity;
    [vc reloadData];
    
    self.scrollView = scrollView;
    
    YFSegmentedControl *segment = [[YFSegmentedControl alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, 44) titleArr:titleArr];
    [self.view addSubview:segment];
    self.segmentControl = segment;
    segment.selectedColor = THEME_COLOR_Alpha(1.0);
    segment.normalColor = HEX(@"333333", 1.0);
    segment.showIndicator = YES;
    segment.textFont = FONT(12);
    [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    
    UIView *lineView=[UIView new];
    [segment addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
}

#pragma mark ====== Functions =======
// 切换城市
- (void)clickHandSearch:(UIButton *)sender
{
    JHChooseCityVC *vc = [[JHChooseCityVC alloc] init];
    vc.cityDic = _cityDic;
    vc.currentCity = _currentCity;
     __weak typeof(self) weakSelf=self;
    vc.refreshCityBlock = ^(NSString *cityName,NSString *city_id){
        [weakSelf dealChangeCity:cityName];
        weakSelf.temp_city_id = city_id;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)dealChangeCity:(NSString *)cityName{
    [self.cityBtn setTitle:cityName forState:UIControlStateNormal];
    self.currentCity = cityName;
    
    if (self.is_search) {
        self.page = 1;
        [self searchAddr];
    }else{
        JHAddrSearchBaseVC * vc = self.subVCArr[self.segmentControl.selectedSegmentIndex];
        vc.city = self.currentCity;
        [vc reloadData];
    }
}

// 搜索地址
-(void)searchAddr{
    [self.view endEditing:YES];
    [self.searchField resignFirstResponder];
    SHOW_HUD
    NSString *type = @"";
    [[XHPlaceTool sharePlaceTool] keywordsSearchWithKeyString:self.searchField.text page:self.page type:type city:self.currentCity success:^(NSArray<XHLocationInfo *> *pois) {
        HIDE_HUD
        [self.searchTableView endRefresh];
        if (self.page == 1) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:pois];
        }else{
            [self.dataSource addObjectsFromArray:pois];
        }
        [self.searchTableView reloadData];
        
    } failure:^(NSString *error) {
        HIDE_HUD
        [self.searchTableView endRefresh];
        [self showToastAlertMessageWithTitle:error.description];
        }];
}

-(void)segmentChange:(YFSegmentedControl *)segment{
    
    NSInteger index = segment.selectedSegmentIndex;
    JHAddrSearchBaseVC *vc = self.subVCArr[index];
    if ([vc isViewLoaded]) {
    }else{
        vc.view.frame = FRAME(WIDTH * index, 0, WIDTH , HEIGHT - NAVI_HEIGHT -44);
        [self.scrollView addSubview:vc.view];
    }
    vc.city = self.currentCity;
    [vc reloadData];
    [self.scrollView setContentOffset:CGPointMake(WIDTH *index, 0) animated:YES];
    
}

#pragma mark ====== UIScrollViewDelegate =======
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/WIDTH;
    self.segmentControl.selectedSegmentIndex = index;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [self.searchField resignFirstResponder];
}

#pragma mark ====== UITextFieldDelegate =======
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.view addSubview:self.searchTableView];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchAddr];
    return YES;
}

// 搜索tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.textLabel.text = [self.dataSource[indexPath.row] name];
    cell.textLabel.font = FONT(14);
    cell.textLabel.textColor = HEX(@"333333", 1);
    cell.detailTextLabel.text = [self.dataSource[indexPath.row] street];
    cell.detailTextLabel.font = FONT(12);
    cell.detailTextLabel.textColor = HEX(@"999999", 1);
    cell.imageView.image = [UIImage imageNamed:@"mall_my_icon_location"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取当前的row
    XHLocationInfo *lastPOI = self.dataSource[indexPath.row];
    [JHConfigurationTool shareJHConfigurationTool].cityName = lastPOI.city;
    [JHConfigurationTool shareJHConfigurationTool].cityCode = lastPOI.cityCode;
    double lat = 0;
    double lng = 0;
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:lastPOI.coordinate.latitude
                                                 WithGD_lon:lastPOI.coordinate.longitude
                                                 WithBD_lat:&lat
                                                 WithBD_lon:&lng];
    
    [JHConfigurationTool shareJHConfigurationTool].lat = lat;
    [JHConfigurationTool shareJHConfigurationTool].lng = lng;
    [JHConfigurationTool shareJHConfigurationTool].lastCommunity = [lastPOI name];
    // 保存地址选择
    [[JHConfigurationTool shareJHConfigurationTool] saveConfiguration];
    [NoticeCenter postNotificationName:ChooseNewAddress_Notification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark ====== 懒加载 =======
-(UITableView *)searchTableView{
    if (_searchTableView==nil) {
        UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
         _searchTableView=tableView;
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.estimatedRowHeight = 40;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.backgroundColor=BACK_COLOR;
        tableView.showsVerticalScrollIndicator=NO;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        __weak typeof(self) weakSelf=self;
        //--下拉加载
        [tableView bindHeadRefreshHandler:^{
            weakSelf.page=1;
            [weakSelf searchAddr];
        }];
        //--上拉加载
        [tableView bindFootRefreshHandler:^{
            weakSelf.page++;
            [weakSelf searchAddr];
        }];
    }
    return _searchTableView;
}

-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end


