//
//  WMCreateOrderZitiAddrCell.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/11/9.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "WMCreateOrderZitiAddrCell.h"
#import "JHOrderDetailBigMapVC.h"
#import "XHMapView.h"

@interface WMCreateOrderZitiAddrCell ()<XHMapViewDelegate>
@property(nonatomic,weak)UILabel *addrLab;
@property(nonatomic,strong)XHMapView *mapView;//地图
@property(nonatomic,strong)WMCreateOrderModel *model;
@end

@implementation WMCreateOrderZitiAddrCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *lab = [UILabel new];
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.height.offset(20);
    }];
    lab.text =  NSLocalizedString(@"商家地址", NSStringFromClass([self class]));
    lab.textColor = HEX(@"999999", 1.0);
    lab.font = FONT(12);
    
    UILabel *addrLab = [UILabel new];
    [self.contentView addSubview:addrLab];
    [addrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(lab.mas_bottom).offset(10);
        make.height.offset(50);
        make.right.offset(-30);
        make.bottom.offset(-10);
    }];
    addrLab.numberOfLines = 2;
    addrLab.font = FONT(18);
    addrLab.textColor = HEX(@"333333", 1.0);
    addrLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.addrLab = addrLab;
    
    UIImageView *arrowImgView = [UIImageView new];
    [self.contentView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.width.offset=7;
        make.height.offset=12;
    }];
    arrowImgView.image = IMAGE(@"btn_arrowr_gray");
//    [self mapView];
    
}

#pragma mark - 展示的地图
-(XHMapView *)mapView{
    if (!_mapView) {
        _mapView = [[XHMapView alloc]initWithFrame:FRAME(0, 0, WIDTH, 200)];
        _mapView.XHDelegate = self;
        [self.contentView addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(self.addrLab.mas_bottom).offset(15);
            make.height.offset(200);
            make.bottom.offset(0);
        }];
    }
    return _mapView;
}

-(void)XHmapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
//    JHOrderDetailBigMapVC *vc = [JHOrderDetailBigMapVC new];
//    
//    [self.superVC.navigationController pushViewController:vc animated:YES];
    
}

-(void)reloadCellWithModel:(WMCreateOrderModel *)model{
   
    _model = model;
    self.addrLab.text = model.shop_addr;
    
    float shop_lat = [model.shop_lat floatValue];
    float shop_lng = [model.shop_lng floatValue];
    CLLocationCoordinate2D shop = CLLocationCoordinate2DMake(shop_lat, shop_lng);
    
    float custom_lat = [JHConfigurationTool shareJHConfigurationTool].lat;
    float custom_lng = [JHConfigurationTool shareJHConfigurationTool].lng;
    CLLocationCoordinate2D pei = CLLocationCoordinate2DMake(custom_lat, custom_lng);

    [_mapView changeDistanceWithShopCoordinate:shop customCoordinate:pei];
    
}

@end
