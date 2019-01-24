//
//  XHLocaitonTool.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/7/10.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "XHPlaceTool.h"
#import "XHMapKitManager.h"
#import <GoogleMaps/GoogleMaps.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ZCChinaLocation/ZCChinaLocation.h"

@import GooglePlaces;
@interface XHPlaceTool ()<CLLocationManagerDelegate,AMapSearchDelegate,GMSAutocompleteViewControllerDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D current_coordinate;
    //当前位置的回调
    void(^currentLocationSuccess)(XHLocationInfo *placeModel);
    void(^currentLocationFailure)(NSString *error);
    //周边及关键字搜索的回调
    void(^searchSuccess)(NSArray <XHLocationInfo *>*searchResult);
    void(^searchFailure)(NSString *error);;
    //高德搜索
    AMapSearchAPI * _gaodeSearch;
    AMapLocationManager *_amapLocationManager;
    //google地图搜索
    GMSPlacesClient *_googleSearchClient;
    void(^gmsSearchSuccess)(XHLocationInfo *model);
}
@property(nonatomic,strong) AMapSearchAPI *search;
@end

@implementation XHPlaceTool

+ (instancetype)sharePlaceTool{
    static XHPlaceTool *sharePlaceTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePlaceTool = [[XHPlaceTool alloc] init];
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        [manager requestWhenInUseAuthorization];
        manager.delegate = sharePlaceTool;
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        manager.distanceFilter=100;
        [sharePlaceTool setValue:manager forKey:@"locationManager"];
        [manager startUpdatingLocation];
    });
    return sharePlaceTool;
}

#pragma mark - 获取当前的位置
- (void)getCurrentPlaceWithSuccess:(void (^)(XHLocationInfo *))success
                           failure:(void (^)(NSString *))failure{
    
    currentLocationSuccess = success ;
    currentLocationFailure = failure ;
    [locationManager startUpdatingLocation];
    
}
#pragma mark - 更新位置delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    
    if (locations.count == 0) {
        //提示出错
        [manager stopUpdatingLocation];
        if (currentLocationFailure) currentLocationFailure(@"请检查是否获取定位权限");
        
    }else{
        [manager stopUpdatingLocation];
        CLLocation *currnet_location = locations[0];
        
        //存储位置
        XHLocationInfo *place = [XHLocationInfo new];
        place.address = @"";
        place.name = @" ";
        place.street = @"";
        place.city = @"";
        place.district = @"";
        place.province = @"";
        place.postalCode = @"";
        place.country = @"";
        
        place.adcode = @"";
        
        if ([XHMapKitManager shareManager].is_International) {
            place.coordinate = currnet_location.coordinate;
            if (currentLocationSuccess) {
                currentLocationSuccess(place);
            }
        }else{
            place.coordinate =  AMapLocationCoordinateConvert(currnet_location.coordinate, AMapLocationCoordinateTypeGPS);
            //判断是否在高德可用范围内
            BOOL isGaodeRange = [[ZCChinaLocation shared] isInsideChina:currnet_location.coordinate];
            if (isGaodeRange == NO) {
                place.coordinate = AMapLocationCoordinateConvert(CLLocationCoordinate2DMake(31.832098, 117.243886),
                                                                 AMapLocationCoordinateTypeGPS) ;
            }
            [self reGeocode:place.coordinate];
        }
        
        [XHMapKitManager shareManager].lat = place.coordinate.latitude;
        [XHMapKitManager shareManager].lng = place.coordinate.longitude;
        
        current_coordinate = place.coordinate;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (currentLocationFailure) {
        currentLocationFailure(@"没有定位权限");
    }
}
-(void)reGeocode:(CLLocationCoordinate2D)coordinate success:(void (^)(XHLocationInfo *))success failure:(void (^)(NSString *))failure{
    
    currentLocationFailure = failure;
    currentLocationSuccess = success;
    [self reGeocode:coordinate];
}

-(void)reGeocode:(CLLocationCoordinate2D)coordinate{
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.location =[AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    AMapSearchAPI *search = [[AMapSearchAPI alloc]init];
    search.delegate = self;
    self.search = search;
    [search AMapReGoecodeSearch:regeoRequest];
}

-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if(response.regeocode != nil)
    {
        XHLocationInfo *place = [XHLocationInfo new];
        place.coordinate = current_coordinate;
        place.address = response.regeocode.formattedAddress;
        place.name = @" ";
        place.street = response.regeocode.addressComponent.streetNumber.street;
        place.city = response.regeocode.addressComponent.city;
        place.district = response.regeocode.addressComponent.district;
        place.province = response.regeocode.addressComponent.province;
        place.postalCode = @"";
        place.country = @"";
        place.adcode = response.regeocode.addressComponent.adcode;
        if (response.regeocode.addressComponent.businessAreas.firstObject) {
            place.name = [response.regeocode.addressComponent.businessAreas.firstObject name];
        }
        if (currentLocationSuccess) {
            currentLocationSuccess(place);
        }
    }else{
        if (currentLocationFailure) {
            currentLocationFailure( NSLocalizedString(@"获取位置失败", NSStringFromClass([self class])));
        }
    }
}

#pragma mark - 周边搜索(GMS 和 高德)
- (void)aroundSearchWithSuccess:(void(^)(NSArray <XHLocationInfo *>*))success
                        failure:(void (^)(NSString *))failure{
    searchSuccess = success;
    searchFailure = failure;
    
    if ([XHMapKitManager shareManager].is_International) {
        _googleSearchClient = [[GMSPlacesClient alloc] init];
        [_googleSearchClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
            if (error){
                searchFailure(NSLocalizedString(@"获取位置信息失败,请检查是否开启定位和网络", nil));
                return ;
            }
             NSMutableArray<XHLocationInfo *> *result = @[].mutableCopy;
            if (placeLikelihoodList != nil) {
                NSArray<GMSPlaceLikelihood *>*pois = [placeLikelihoodList likelihoods];
                for (GMSPlaceLikelihood *likelihood in pois) {
                    GMSPlace *poi = likelihood.place;
                    XHLocationInfo *model = [XHLocationInfo new];
                    model.address = poi.formattedAddress;
                    model.name = poi.name;
                    model.street = @"";
                    model.city = @"";
                    model.district = @"";
                    model.province = @"";
                    model.postalCode = @"";
                    model.cityCode = @"";
                    model.country = @"";
                    model.coordinate = poi.coordinate;
                    model.adcode = @"";
                    [result addObject:model];
                }
            }
            searchSuccess(result);
        }];
        
    }else{
        _gaodeSearch = [[AMapSearchAPI alloc]init];
        _gaodeSearch.delegate = self;
        //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:[XHMapKitManager shareManager].lat
                                                    longitude:[XHMapKitManager shareManager].lng];
        request.types = NSLocalizedString(@"学校|商务住宅|门牌信息", nil);
        request.radius = 50000;
        request.sortrule = 0;
        request.requireExtension = YES;
        //发起周边搜索
        [_gaodeSearch AMapPOIAroundSearch:request];
    }
}

- (void)startGmsKeySearch:(void(^)(XHLocationInfo *model))GmsPlaceSelectedSuccess{
    gmsSearchSuccess = GmsPlaceSelectedSuccess;
    
    GMSAutocompleteViewController *keySearchVC = [[GMSAutocompleteViewController alloc] init];
    keySearchVC.delegate = self;
    //是否能获取到导航控制器
    UINavigationController *nav = [[self getCurrentVC] navigationController];
    if (nav) {
        [nav pushViewController:keySearchVC animated:YES];
    }else{
        [[self getCurrentVC] presentViewController:keySearchVC animated:YES completion:nil];
    } 
}
#pragma mark - 关键字搜索
- (void)keywordsSearchWithKeyString:(NSString *)key
                            success:(void(^)(NSArray <XHLocationInfo *>*))success
                            failure:(void (^)(NSString *))failure{
    
    searchSuccess = [success copy];
    searchFailure = [failure copy];
    if ([XHMapKitManager shareManager].is_International) {
        
        
    }else{
        //高德地图关键字搜索
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        request.keywords = key;
        request.city = [XHMapKitManager shareManager].currentCity;
        request.sortrule = 0;
        request.requireExtension = YES;
        request.cityLimit = YES;
        
        _gaodeSearch = [[AMapSearchAPI alloc]init];
        _gaodeSearch.delegate = self;
        
        //发起关键字搜索
        [_gaodeSearch AMapPOIKeywordsSearch:request];
    }
}

- (void)keywordsSearchWithKeyString:(NSString *)key page:(int)page type:(NSString *)type
                               city:(NSString *)city
                            success:(void(^)(NSArray <XHLocationInfo *>*))success
                            failure:(void (^)(NSString *))failure{
    
    searchSuccess = [success copy];
    searchFailure = [failure copy];
    if ([XHMapKitManager shareManager].is_International) {
        
        
    }else{
        //高德地图关键字搜索
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        request.keywords = key;
        request.page = page;
        request.types = type;
        request.city = city;
        request.sortrule = 0;
        request.requireExtension = YES;
        
        _gaodeSearch = [[AMapSearchAPI alloc]init];
        _gaodeSearch.delegate = self;
        
        //发起关键字搜索
        [_gaodeSearch AMapPOIKeywordsSearch:request];
    }
}

#pragma mark - GMSAutocompleteViewControllerDelegate
//谷歌关键字搜索点击某个地点
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place{
    
    GMSPlace *poi = place;
    XHLocationInfo *model = [XHLocationInfo new];
    model.address = poi.formattedAddress;
    model.name = poi.name;
    model.street = @"";
    model.city = @"";
    model.district = @"";
    model.province = @"";
    model.postalCode = @"";
    model.cityCode = @"";
    model.country = @"";
    model.adcode = @"";
    model.coordinate = poi.coordinate;
    if (gmsSearchSuccess){
        gmsSearchSuccess(model);
    }
}
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController{

}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error{

}


#pragma mark - 高德搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    NSArray *pois = response.pois;
    NSMutableArray<XHLocationInfo *> *result = @[].mutableCopy;
    if (pois && pois.count > 0) {
        for (AMapPOI *poi in pois) {
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
            model.adcode = poi.adcode;
            model.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            [result addObject:model];
        }
    }
    searchSuccess(result);
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    if (error && searchFailure) {
        searchFailure(@"失败了");
    }
}

#pragma mark - 解析获取到的地点
- (NSArray *)handlePlace:(NSArray *)items{
    NSMutableArray *addressArr = @[].mutableCopy;
    for (id item in items) {
        CLPlacemark *placemark;
        if ([item isMemberOfClass:[MKMapItem class]]) {
            placemark = [(MKMapItem *)item placemark];
        }else{
            placemark = item;
        }
        XHLocationInfo *model = [[XHLocationInfo alloc]init];
        model.address = @"";
        model.name = placemark.name;
        model.street = [placemark.thoroughfare stringByAppendingString:placemark.subThoroughfare?placemark.subThoroughfare:@""];
        model.city = placemark.locality;
        model.district = placemark.subLocality;
        model.province = placemark.administrativeArea;
        model.postalCode = placemark.postalCode;
        model.country = placemark.country;
        model.coordinate = placemark.location.coordinate;
        [addressArr addObject:model];
    }
    return addressArr;
}
#pragma mark - 获取当前显示的控制器
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
@end
