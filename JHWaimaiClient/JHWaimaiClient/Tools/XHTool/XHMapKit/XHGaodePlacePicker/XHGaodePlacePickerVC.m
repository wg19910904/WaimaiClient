//
//  HZQMapSearch.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "XHGaodePlacePickerVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "XHLocationInfo.h"
#import "XHMapKitManager.h"

#import "XHGaodePlacePickerCell.h"

@interface XHGaodePlacePickerVC ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITextField * searchTextField;//搜索框
    UIButton * rightItem;//右边的取消按钮
    MAMapView * _mapView;//地图
    AMapSearchAPI * _search;//周边搜索需要的
    BOOL isRoundSearch;//是否是周边搜索
    BOOL isFirst; //是否是第一次加载地图
    NSMutableArray * aroundInfoArray;//周边搜索存放model的数组
    NSMutableArray * keyInfoArray;//关键字搜索存放model的数组
    UITableView * aroundTableView;//周边搜索的结果表
    UITableView * keyTableView;//关键字搜索的结果表
    void(^selecteSuccess)(XHLocationInfo *place);
    NSInteger page;
    //当前搜索的坐标
    double current_lat;
    double current_lng;
}
@end

@implementation XHGaodePlacePickerVC

- (instancetype)initWithSelectePlace:(void (^)(XHLocationInfo *))success{
    self = [super init];
    if (self) {
        selecteSuccess = success;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //创建地图
    [self creatMapView];
    //创建地图下方的表
    [self creatAroundTableView];
    SHOW_HUD
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    page = 1;
    [self creatUISearch];
    aroundInfoArray = @[].mutableCopy;
    keyInfoArray = @[].mutableCopy;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    //在导航上添加子视图(搜索框和取消的按钮)
    rightItem = [[UIButton alloc]init];
    rightItem.frame = FRAME(0, 0, 32, 30);
    rightItem.titleLabel.font = FONT(15);
    [rightItem setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = item;
    //检测文本框发生文本发生改变的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:searchTextField];
    
}
#pragma mark - 创建搜索框
-(void)creatUISearch{
    if (searchTextField == nil) {
        searchTextField = [[UITextField alloc]init];
        searchTextField.frame = FRAME(48, 28, WIDTH - 60, 27);
        searchTextField.layer.cornerRadius = 3;
        searchTextField.clipsToBounds = YES;
        searchTextField.delegate = self;
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = FRAME(0,0,15, 27);
        searchTextField.leftViewMode = UITextFieldViewModeAlways;
        searchTextField.leftView = lab;
        searchTextField.backgroundColor = HEX(@"999999", 0.2);
        searchTextField.placeholder = NSLocalizedString(@"请输入搜索地点", nil);
        [searchTextField setValue:HEX(@"999999", 1) forKeyPath:@"_placeholderLabel.textColor"];
        [searchTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        searchTextField.font = [UIFont systemFontOfSize:15];
        searchTextField.tintColor = HEX(@"298FFF", 1);
        self.navigationItem.titleView = searchTextField;
    }
}
#pragma mark - 这是返回的方法
-(void)clickToBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 这是取消搜索的方法
-(void)clickCancel{
    if ([rightItem.titleLabel.text isEqualToString:NSLocalizedString(@"取消", nil)]) {
        searchTextField.text = nil;
        [self.navigationController.view endEditing:YES];
        [keyInfoArray removeAllObjects];
        [keyTableView removeFromSuperview];
        keyTableView = nil;
        [rightItem setTitle:@"" forState:UIControlStateNormal];
    }
}
#pragma mark - 创建周边搜索的表
-(void)creatAroundTableView{
    aroundTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (HEIGHT - NAVI_HEIGHT)/2+NAVI_HEIGHT-1, WIDTH, (HEIGHT - NAVI_HEIGHT)/2+1) style:UITableViewStylePlain];
    aroundTableView.delegate = self;
    aroundTableView.dataSource = self;
    aroundTableView.estimatedRowHeight = 50;
    aroundTableView.sectionHeaderHeight = 0.01;
    aroundTableView.tag = 10;
    aroundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf=self;
    //--上拉加载
    [aroundTableView bindFootRefreshHandler:^{
        
        [weakSelf upLoadData];
    }];
    
    [self.view addSubview:aroundTableView];
}
- (void)upLoadData{
    page++;
    [self creatSearchWithlatiude:current_lat withLongitude:current_lng];
}
#pragma mark - 创建关键字搜索的表
-(void)creatKeyTableView{
    if (keyTableView == nil) {
        keyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStylePlain];
        keyTableView.delegate = self;
        keyTableView.dataSource = self;
        keyTableView.tag = 20;
        keyTableView.tableFooterView = [UIView new];
        keyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:keyTableView];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - 这是表的数据源方法和代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        return aroundInfoArray.count;
    }else{
        return keyInfoArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XHLocationInfo *model;
    if (tableView.tag == 10) {
        static NSString * identifier = @"XHGaodePlacePickerCell";
        XHGaodePlacePickerCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[XHGaodePlacePickerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        model = aroundInfoArray[indexPath.row];
        if (indexPath.row == 0) {
            [cell reloadModel:model showImg:YES searchWord:@"" isSearch:NO];
        }else{
            [cell reloadModel:model showImg:NO searchWord:@"" isSearch:NO];
        }
        return cell;
    }else{
        static NSString * iden = @"XHGaodePlacePickerCell";
        XHGaodePlacePickerCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[XHGaodePlacePickerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        model = keyInfoArray[indexPath.row];
        [cell reloadModel:model showImg:NO searchWord:searchTextField.text isSearch:YES];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XHLocationInfo * model;
    if (tableView.tag == 10) {
        model = aroundInfoArray[indexPath.row];
    }else{
        model = keyInfoArray[indexPath.row];
    }
    if (selecteSuccess) {
        selecteSuccess(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 创建地图
-(void)creatMapView{
    _mapView = [[MAMapView alloc]initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, (HEIGHT - NAVI_HEIGHT)/2)];
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.delegate = self;
    [_mapView setZoomEnabled:YES];
    [_mapView setZoomLevel:16.1 animated:YES];
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self.view addSubview:_mapView];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.bounds = FRAME(0, 0, 25, 30);
    imageView.center = CGPointMake(_mapView.center.x, _mapView.center.y - 15);
    imageView.image = [UIImage imageNamed:@"XHDatouzhen"];
    [self.view addSubview:imageView];
}
#pragma mark - 这是当前的位置改变的时候会调用的方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (userLocation) {
        if (!isFirst&&_center.latitude == 0) {
            current_lat = userLocation.location.coordinate.latitude;
            current_lng = userLocation.location.coordinate.longitude;
            [self creatSearchWithlatiude:current_lat withLongitude:current_lng];
            isFirst = YES;
        }else if (!isFirst&&_center.latitude != 0){
            [mapView setCenterCoordinate:_center animated:YES];
            current_lat = _center.latitude;
            current_lng = _center.longitude;
            [self creatSearchWithlatiude:current_lat
                           withLongitude:current_lng];
            isFirst = YES;
        }
    }
}
#pragma mark - 拖动时一直打印中间的位置
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (animated == YES) {
        page = 1;
        [self creatSearchWithlatiude:mapView.centerCoordinate.latitude withLongitude:mapView.centerCoordinate.longitude];
    }
}
#pragma mark - 添加周边搜索的服务
-(void)creatSearchWithlatiude:(float)lat withLongitude:(float)log{
    isRoundSearch = YES;
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    AMapPOIAroundSearchRequest * request = [[AMapPOIAroundSearchRequest alloc]init];
    request.location = [AMapGeoPoint locationWithLatitude:lat longitude:log];
    request.types = NSLocalizedString(@"学校|商务住宅|门牌信息", nil);
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius = 50000;
    request.page = page;
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
}
#pragma mark - 添加关键字搜索
-(void)creatKeyWordSearch{
    isRoundSearch = NO;
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    AMapPOIKeywordsSearchRequest * request = [[AMapPOIKeywordsSearchRequest alloc]init];
    request.keywords = searchTextField.text;
//    request.city = [XHMapKitManager shareManager].currentCity;
    request.city = [JHConfigurationTool shareJHConfigurationTool].cityName;
    request.sortrule = 0;
    request.requireExtension = YES;
    //发起关键字搜索
    [_search AMapPOIKeywordsSearch: request];
}
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0){
        NSLog(@"没有搜到结果哦亲");
        page = MAX(page--, 1);
    }
    if (isRoundSearch && page == 1) {
        [aroundInfoArray removeAllObjects];
    }else{
        [keyInfoArray removeAllObjects];
    }
    for (AMapPOI * poi in response.pois) {
        XHLocationInfo *model = [XHLocationInfo new];
        model.address = @"";
        model.name = poi.name;
        model.street = poi.address;
        model.city = poi.city;
        model.district = poi.district;
        model.province = poi.province;
        model.postalCode = poi.pcode;
        model.cityCode = poi.citycode;
        model.country = @"";
        model.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        
        if (isRoundSearch) {
            [aroundInfoArray addObject:model];
        }else{
            [keyInfoArray addObject:model];
        }
    }
    [aroundTableView endRefresh];
    if (isRoundSearch) {
        HIDE_HUD
        [aroundTableView reloadData];
    }else{
        [keyTableView reloadData];
    }
}
#pragma mark - 这是文本框的代理fangfa
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    searchTextField.text = nil;
    [self.navigationController.view endEditing:YES];
    [keyInfoArray removeAllObjects];
    [keyTableView removeFromSuperview];
    keyTableView = nil;
    [rightItem setTitle:@"" forState:UIControlStateNormal];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [rightItem setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [self creatKeyTableView];
}
//滚动视图的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag == 20){
        CGFloat offset_y = scrollView.contentOffset.y;
        if (offset_y > 0) {
            //搜索文本框放弃第一响应
            [searchTextField resignFirstResponder];
        }
    }
}
-(void)textFieldTextDidChangeOneCI:(NSNotification *)not{
    [self creatKeyWordSearch];
}
    
@end

