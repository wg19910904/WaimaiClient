//
//  ZQShowAnnotationMapView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/7/12.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ZQShowAnnotationMapView : UIView
/**
 大头针的图片
 */
@property(nonatomic,strong)UIImage * annotationImage;
/**
 回调地图的点击事件(假如需求让点击地图跳转到大的地图,只有在订单详情中需要)
 */
@property(nonatomic,copy)void(^clickBlock)();
/**
 改变配送员和商家之间的距离的
 
 @param shopCoordinate 商家的经纬度
 @param peiCoordinate 配送员的经纬度
 */
-(void)changeDistanceWithShopCoordinate:(CLLocationCoordinate2D)shopCoordinate
                          peiCoordinate:(CLLocationCoordinate2D)peiCoordinate;
/**
 改变配送员和客户之间的距离的
 
 @param customCoordinate 客户的经纬度
 @param peiCoordinate 配送员的经纬度
 */
-(void)changeDistanceWithCustomCoordinate:(CLLocationCoordinate2D)customCoordinate
                            peiCoordinate:(CLLocationCoordinate2D)peiCoordinate;


/**
 地图中展示一个大头针(用户纯展示)
 
 @param lat 传入的纬度
 @param lng 传入的经度
 */
-(void)showAnnotationViewLat:(NSString *)lat
                         lng:(NSString *)lng;
@end
