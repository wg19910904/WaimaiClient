//  地点工具-当前地理位置,周边搜索,关键字搜索
//  XHLocaitonTool.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/7/10.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHLocationInfo.h"
#import <MapKit/MapKit.h>
@interface XHPlaceTool : NSObject

+ (instancetype)sharePlaceTool;

/**
 获取当前的位置
 
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)getCurrentPlaceWithSuccess:(void (^)(XHLocationInfo *model))success
                           failure:(void (^)(NSString *error))failure;

/**
 周边搜索(高德和 google)

 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)aroundSearchWithSuccess:(void(^)(NSArray <XHLocationInfo *>*pois))success
                        failure:(void (^)(NSString *error))failure;


///**
// 带参数的周边搜索(高德和 google)
//
// @param page 分页
// @param type 类型
// @param success 成功的回调
// @param failure 失败的回调
// */
//- (void)aroundSearchWithPage:(int)page type:(NSString *)type Success:(void(^)(NSArray <XHLocationInfo *>*))success
//                     failure:(void (^)(NSString *))failure;

/**
 高德关键字搜索

 @param key 搜索的内容
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)keywordsSearchWithKeyString:(NSString *)key
                            success:(void(^)(NSArray <XHLocationInfo *>*pois))success
                            failure:(void (^)(NSString *error))failure;


/**
 带参数的高德关键字搜索
 @param page 分页
 @param type 类型
 @param city 城市
 @param key 搜索的内容
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)keywordsSearchWithKeyString:(NSString *)key page:(int)page type:(NSString *)type city:(NSString *)city success:(void(^)(NSArray <XHLocationInfo *>*))success
                            failure:(void (^)(NSString *))failure;

/**
 发起google地图关键字搜索

 @param GmsPlaceSelectedSuccess 搜索成功后,点击某个地点的回调
 */
- (void)startGmsKeySearch:(void(^)(XHLocationInfo *model))GmsPlaceSelectedSuccess;


/**
 逆地理编码出来

 @param coordinate 坐标
 @param success 成功的回调
 @param failure 失败的回调
 */
-(void)reGeocode:(CLLocationCoordinate2D)coordinate success:(void (^)(XHLocationInfo *model))success
         failure:(void (^)(NSString *error))failure;
@end
