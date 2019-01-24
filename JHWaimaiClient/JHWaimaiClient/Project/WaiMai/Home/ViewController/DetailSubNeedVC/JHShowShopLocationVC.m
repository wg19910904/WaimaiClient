//
//  JHShowShopLocationVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHShowShopLocationVC.h"
#import "XHMapKitHeader.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHShowAlert.h"
#import "JZLocationConverter.h"
@interface JHShowShopLocationVC ()
@property(nonatomic,strong)XHMapView *mapView;
@property(nonatomic,strong)UIButton *originalBtn;//原始的按钮
@property(nonatomic,strong)UIView *mapBottomView;
@property(nonatomic,strong)UILabel *houseLab;//当前的建筑
@property(nonatomic,strong)UILabel *roadLad;//当前的路
@end

@implementation JHShowShopLocationVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    [self originalBtn];
}

-(void)setUpView{
   
    if (self.title) {
        self.navigationItem.title = self.title;
    }else{
        self.navigationItem.title = NSLocalizedString(@"自提地点", @"JHShowShopLocationVC");
    }
    [self.view addSubview:self.mapView];
    self.naviColor = NaVi_COLOR_Alpha(0);
    self.backBtnImgName = @"btn_back";
}
-(UIButton *)originalBtn{
    if (!_originalBtn) {
        _originalBtn = [[UIButton alloc]init];
        [_originalBtn setImage:IMAGE(@"btn_position") forState:UIControlStateNormal];
        [self.view addSubview:_originalBtn];
        [_originalBtn addTarget:self action:@selector(clickOriginalBtn) forControlEvents:UIControlEventTouchUpInside];
        [_originalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.height.width.offset = 30;
            make.bottom.offset = -80;
        }];
    }
    return _originalBtn;
}
-(void)clickOriginalBtn{
    [_mapView  setCenterWithCurrentLocation];
}
- (XHMapView *)mapView{
    if (_mapView == nil) {
        _mapView = [[XHMapView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
        _mapView.lat = [self.lat doubleValue];
        _mapView.lng = [self.lng doubleValue];
        CLLocationCoordinate2D coord;
        if ([XHMapKitManager shareManager].is_International) {
            coord = CLLocationCoordinate2DMake([self.lat doubleValue],[self.lng doubleValue]);
        }else{
            double gd_lat;
            double gd_lng;
            [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[self.lat doubleValue]
                                                         WithBD_lon:[self.lng doubleValue]
                                                         WithGD_lat:&gd_lat
                                                         WithGD_lon:&gd_lng];
            coord = CLLocationCoordinate2DMake(gd_lat, gd_lng);
        }
        __weak typeof (self)weakSelf = self;
        [_mapView getCurrentLocationName:coord block:^(NSString *house, NSString *road) {
             [weakSelf mapBottomView];
             weakSelf.houseLab.text = weakSelf.shopName;
             weakSelf.roadLad.text = road;
        }];
        [_mapView addAnnotation:coord
                          title:nil
                         imgStr:@"icon_position"
                       selected:NO];
    }
    return _mapView;
}
-(UIView *)mapBottomView{
    if (!_mapBottomView) {
        _mapBottomView = [UIView new];
        _mapBottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_mapBottomView];
        [_mapBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset = 0;
            make.height.offset = 60;
        }];
        UIButton *imgV = [UIButton new];
        [imgV setBackgroundImage:IMAGE(@"btn_go") forState:UIControlStateNormal];
        [_mapBottomView addSubview:imgV];
        [imgV addTarget:self action:@selector(clickShowChoseMap) forControlEvents:UIControlEventTouchUpInside];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.top.offset = 10;
            make.width.height.offset = 40;
        }];
        _houseLab = [[UILabel alloc]init];
        _houseLab.textColor = HEX(@"333333", 1);
        _houseLab.font = FONT(16);
        [_mapBottomView addSubview:_houseLab];
        [_houseLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.offset = 11;
            make.height.offset = 16;
        }];
        _roadLad = [[UILabel alloc]init];
        _roadLad.textColor = HEX(@"999999", 1);
        _roadLad.font = FONT(12);
        [_mapBottomView addSubview:_roadLad];
        [_roadLad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.mas_equalTo(_houseLab.mas_bottom).offset = 10;
            make.height.offset = 12;
        }];
    }
    return _mapBottomView;
}
-(void)clickShowChoseMap{
    NSLog(@"这是点击展示选择地图的方法");
    NSArray *arr = [self getInstalledMapAppWithEndLocation:CLLocationCoordinate2DMake(self.lat.floatValue, self.lng.floatValue)];
    NSLog(@"%@",arr);
    NSMutableArray *titleArr = @[].mutableCopy;
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dic = arr[i];
        [titleArr addObject:dic[@"title"]];
    }
    [JHShowAlert showSheetAlertWithTextArr:titleArr withController:self withClickBlock:^(NSInteger tag) {
        NSLog(@"%ld",tag);
        if (tag ==  0) {
            //苹果地图
            CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:CLLocationCoordinate2DMake(self.lat.floatValue, self.lng.floatValue)];
            MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
            NSArray *items = @[currentLoc,toLocation];
            NSDictionary *dic = @{
                                  MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                                  MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                                  MKLaunchOptionsShowsTrafficKey : @(YES)
                                  };
            
            [MKMapItem openMapsWithItems:items launchOptions:dic];
        }else{
            NSDictionary *dic = arr[tag];
            NSString *urlString = dic[@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }];
}
- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
{
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = NSLocalizedString(@"本机地图", nil);
    [maps addObject:iosMapDic];
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        double lat = 0.00;
        double lng = 0.00;
        [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:endLocation.latitude WithGD_lon:endLocation.longitude WithBD_lat:&lat WithBD_lon:&lng];
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = NSLocalizedString(@"百度地图", nil);
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = NSLocalizedString(@"高德地图", nil);
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",NSLocalizedString(@"导航功能", nil),@"nav123456",endLocation.latitude,endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = NSLocalizedString(@"腾讯地图", nil);
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    return maps;
}
@end

