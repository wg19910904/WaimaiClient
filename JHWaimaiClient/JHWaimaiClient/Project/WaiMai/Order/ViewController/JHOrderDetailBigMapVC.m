//
//  JHOrderDetailBigMapVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/11/23.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHOrderDetailBigMapVC.h"
#import "XHMapView.h"
@interface JHOrderDetailBigMapVC ()
@property(nonatomic,strong)XHMapView *mapView;//地图
@end

@implementation JHOrderDetailBigMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"地图详情",nil);
    [self mapView];
    [self reloadCellWithModel:_model];
}
#pragma mark - 展示的地图
-(XHMapView *)mapView{
    if (!_mapView) {
        _mapView = [[XHMapView alloc]initWithFrame:FRAME(0, 0, CGRectGetWidth(self.view.frame), 240)];
        [self.view addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset = 0;
            make.height.offset = HEIGHT-64;
        }];
    }
    return _mapView;
}
-(void)reloadCellWithModel:(JHWaimaiOrderDetailModel *)model{
    if([model.order_status integerValue] == 2 && [model.staff_id integerValue] > 0){//骑手正在取餐
        float shop_lat = [model.waimai[@"lat"] floatValue];
        float shop_lng = [model.waimai[@"lng"] floatValue];
        CLLocationCoordinate2D shop = CLLocationCoordinate2DMake(shop_lat, shop_lng);
        float pei_lat = [model.staff[@"lat"] floatValue];
        float pei_lng = [model.staff[@"lng"] floatValue];
        CLLocationCoordinate2D pei = CLLocationCoordinate2DMake(pei_lat, pei_lng);
        
        [_mapView changeDistanceWithShopCoordinate:shop peiCoordinate:pei];
    }
    if ([model.order_status integerValue] == 3) {//配送员正在送餐
        float pei_lat = [model.staff[@"lat"] floatValue];
        float pei_lng = [model.staff[@"lng"] floatValue];
        CLLocationCoordinate2D pei = CLLocationCoordinate2DMake(pei_lat, pei_lng);
        float custom_lat = [model.lat floatValue];
        float custom_lng = [model.lng floatValue];
        CLLocationCoordinate2D custom = CLLocationCoordinate2DMake(custom_lat, custom_lng);
        [_mapView changeDistanceWithCustomCoordinate:custom peiCoordinate:pei];
    }
}
@end
