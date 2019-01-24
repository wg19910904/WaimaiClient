//
//  JHWaiMaiOrderDetailMapCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiOrderDetailMapCell.h"
#import "ZQShowAnnotationMapView.h"
#import "JHShowAlert.h"
#import "XHMapView.h"
#import "JHOrderDetailBigMapVC.h"
@interface JHWaiMaiOrderDetailMapCell()<XHMapViewDelegate>
@property(nonatomic,strong)XHMapView *mapView;//地图
@property(nonatomic,strong)UIView *topView;//顶部的view
@property(nonatomic,strong)UILabel *titleL;//展示骑手信息的
@property(nonatomic,strong)UIButton *phoneBtn;//点击打给骑手的
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,strong)JHWaimaiOrderDetailModel *model;
@property(nonatomic,strong)JHOrderDetailBigMapVC *vc;
@end
@implementation JHWaiMaiOrderDetailMapCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self mapView];
        [self topView];
        [self titleL];
        [self phoneBtn];
    }
    return self;
}
#pragma mark - 展示的地图
-(XHMapView *)mapView{
    if (!_mapView) {
        _mapView = [[XHMapView alloc]initWithFrame:FRAME(0, 0, WIDTH, 240)];
        _mapView.XHDelegate = self;
        [self addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset = 0;
            make.height.offset = 240;
        }];
    }
    return _mapView;
}
-(void)XHmapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    _vc = [JHOrderDetailBigMapVC new];
    _vc.model = _model;
    [self.superVC.navigationController pushViewController:_vc animated:YES];
   
}
#pragma mark - 顶部的view
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = HEX(@"ff8800", 0.9);
        [self addSubview:_topView];
        _topView.hidden = YES;
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset = 0;
            make.height.offset = 40;
        }];
    }
    return _topView;
}
#pragma mark - 展示骑手信息的
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [UIColor whiteColor];
        _titleL.font = FONT(14);
        [_topView addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.centerY.mas_equalTo(_topView.mas_centerY);
            make.height.offset = 16;
        }];
    }
    return _titleL;
}
#pragma mark - 点击打电话给骑手的按钮
-(UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [[UIButton alloc]init];
        [_phoneBtn setImage:IMAGE(@"btn_call_white") forState:UIControlStateNormal];
        [_topView addSubview:_phoneBtn];
        [_phoneBtn addTarget:self action:@selector(clickToCall) forControlEvents:UIControlEventTouchUpInside];
        [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset = 0;
            make.right.offset = -10;
            make.width.offset = 40;
        }];
        
    }
    return _phoneBtn;
}

#pragma mark - 点击的是打给骑手的方法
-(void)clickToCall{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phone]]];
}

-(void)reloadCellWithModel:(JHWaimaiOrderDetailModel *)model{
    _model = model;
    self.phone = model.staff[@"mobile"];
    _titleL.text = [NSString stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"骑手", nil),model.staff[@"name"],model.staff[@"mobile"]];
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
