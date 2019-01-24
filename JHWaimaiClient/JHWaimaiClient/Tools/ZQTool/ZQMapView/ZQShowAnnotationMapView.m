//
//  ZQShowAnnotationMapView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/7/12.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQShowAnnotationMapView.h"
#import <MAMapKit/MAMapKit.h>
#import "GaoDe_Convert_BaiDu.h"
@interface ZQShowAnnotationMapView()<MAMapViewDelegate>
@property(nonatomic,strong)MAMapView *mapView;//地图
@property(nonatomic,strong)MAPointAnnotation *annotation;//大头针
@property(nonatomic,strong)NSString *title;//大头针的标题
@property(nonatomic,strong)NSString *subTitle;//大头针子标题
@property(nonatomic,assign)CLLocationCoordinate2D coordinate_annotation;//大头针的位置
@property(nonatomic,strong)UIButton *returnBtn;//单纯展示位置的时候,在地图划走时可以点击回到大头针的位置
@property(nonatomic,strong)UIControl *bgView;//去掉地图的点击事件(订单详情中)
@end
@implementation ZQShowAnnotationMapView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self mapView];
        [self bgView];
        [self returnBtn];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self mapView];
        [self bgView];
        [self returnBtn];
    }
    return self;
}
//去掉地图的点击事件(订单详情中)
-(UIControl *)bgView{
    if (!_bgView) {
        _bgView = [[UIControl alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
        [_bgView addTarget:self action:@selector(clickMapView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset = 0;
        }];
    }
    return _bgView;
}
#pragma mark -点击地图(假如需求让点击地图跳转到大的地图)
-(void)clickMapView{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

//单纯展示位置的时候,在地图划走时可以点击回到大头针的位置
-(UIButton *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = [[UIButton alloc]init];
        _returnBtn.hidden = YES;
        [_returnBtn setBackgroundImage:IMAGE(@"zhinan") forState:UIControlStateNormal];
        [_returnBtn addTarget:self action:@selector(clickToReturn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_returnBtn];
        [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.bottom.offset = -30;
            make.width.height.offset = 40;
        }];
    }
    return _returnBtn;
}
-(void)clickToReturn{
    [_mapView setCenterCoordinate:_coordinate_annotation animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [self annotation];
    });
}
#pragma mark - (外卖客户端)展示配送员距离商家和距离客户距离的地图
-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc]init];
        _mapView.delegate = self;
        _mapView.showsScale = NO;
        _mapView.showsCompass = NO;
        [self addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset = 0;
        }];
    }
    [_mapView setZoomLevel:16.1 animated:YES];
    [_mapView setCenterCoordinate:_coordinate_annotation animated:YES];
    return _mapView;
}
#pragma mark - 添加大头症
-(MAPointAnnotation *)annotation{
    if (_annotation) {
        [_mapView removeAnnotation:_annotation];
        _annotation = nil;
    }
    if (!_annotation) {
        _annotation = [[MAPointAnnotation alloc]init];
        _annotation.coordinate = _coordinate_annotation;
        _annotation.title = _title;
        _annotation.subtitle = _subTitle;
        [_mapView addAnnotation:_annotation];
        if (!_annotationImage) {
             [_mapView selectAnnotation:_annotation animated:YES];
        }
    }
    
    return _annotation;
}
//标注大头针会回调的方法
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.image = _annotationImage?_annotationImage:[UIImage imageNamed:@"icon_qishou"];
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.centerOffset = CGPointMake(annotationView.center.x, annotationView.center.y+20);
       
        return annotationView;
    }
    return nil;
}
//-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
//    NSLog(@"当前位置的坐标%f===%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//}

#pragma mark - 计算两点之间的距离的方法
-(NSString *)getDistanceWithPoint1:(CLLocationCoordinate2D)point1
                            point2:(CLLocationCoordinate2D)point2{
    NSString *str;
    CLLocation *current1 = [[CLLocation alloc]initWithLatitude:point1.latitude longitude:point1.longitude];
    CLLocation *current2 = [[CLLocation alloc]initWithLatitude:point2.latitude longitude:point2.longitude];
    CLLocationDistance meters = [current1 distanceFromLocation:current2];
    if (meters<1000) {
        str = [NSString stringWithFormat:@"%.1fm",meters];
    }else{
        float a = meters/1000.0;
        str = [NSString stringWithFormat:@"%.2fkm",a];
    }
    return str;
}
#pragma mark - 改变配送员和商家之间的距离的
-(void)changeDistanceWithShopCoordinate:(CLLocationCoordinate2D)shopCoordinate
                          peiCoordinate:(CLLocationCoordinate2D)peiCoordinate{
    CLLocationCoordinate2D shop = [self changeBaiDuToGaodeWithBaidu:shopCoordinate];
    CLLocationCoordinate2D pei = [self changeBaiDuToGaodeWithBaidu:peiCoordinate];
    NSString *dis = [self getDistanceWithPoint1:shop point2:pei];
    NSString *sub = [NSString stringWithFormat:NSLocalizedString(@"配送员距商家还有%@", nil),dis];
    [self changePraviteWithPeiCoordinate:pei subT:sub mainT:NSLocalizedString(@"取货中...", nil)];
}

#pragma mark - 改变配送员和客户之间的距离的
-(void)changeDistanceWithCustomCoordinate:(CLLocationCoordinate2D)customCoordinate
                            peiCoordinate:(CLLocationCoordinate2D)peiCoordinate{
    CLLocationCoordinate2D custom = [self changeBaiDuToGaodeWithBaidu:customCoordinate];
    CLLocationCoordinate2D pei = [self changeBaiDuToGaodeWithBaidu:peiCoordinate];
    NSString *dis = [self getDistanceWithPoint1:custom point2:pei];
    NSString *sub = [NSString stringWithFormat:NSLocalizedString(@"配送员距您还有%@", nil),dis];
    [self changePraviteWithPeiCoordinate:pei subT:sub mainT:NSLocalizedString(@"送货中...", nil)];
    
}

/**
 修改一些属性的方法
 
 @param peiCoordinate 大头针显示的经纬度
 @param subT 大头针子标题
 @param mainT 大头针主标题
 */
-(void)changePraviteWithPeiCoordinate:(CLLocationCoordinate2D)peiCoordinate
                                 subT:(NSString *)subT
                                mainT:(NSString *)mainT{
    _coordinate_annotation = peiCoordinate;
    _title = mainT;
    _subTitle = subT;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self mapView];
        [self annotation];
    });
   
}

#pragma mark - 地图中展示一个大头针(用户纯展示)
-(void)showAnnotationViewLat:(NSString *)lat
                         lng:(NSString *)lng{
    _returnBtn.hidden = NO;
    if (_bgView) {
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    CLLocationCoordinate2D coordinate = [self changeBaiDuToGaodeWithBaidu:CLLocationCoordinate2DMake([lat floatValue], [lng floatValue])];
    _coordinate_annotation = coordinate;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self mapView];
        [self annotation];
    });
   
    
}
#pragma mark - 将百度坐标转换为高德坐标
-(CLLocationCoordinate2D)changeBaiDuToGaodeWithBaidu:(CLLocationCoordinate2D)baidu{
    double gaode_lat;
    double gaode_lng;
    [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:baidu.latitude WithBD_lon:baidu.longitude WithGD_lat:&gaode_lat WithGD_lon:&gaode_lng];
    return CLLocationCoordinate2DMake(gaode_lat, gaode_lng);
}

@end
