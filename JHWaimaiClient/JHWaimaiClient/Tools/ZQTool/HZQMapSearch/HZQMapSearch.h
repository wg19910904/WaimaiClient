//
//  HZQMapSearch.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
#import "HZQSearchModel.h"
#import <CoreLocation/CoreLocation.h>
@protocol HZQMapSearchDelegate<NSObject>
@optional
-(void)returnAddress:(HZQSearchModel *)model;
@end

@interface HZQMapSearch : JHBaseVC
@property(nonatomic,assign)id<HZQMapSearchDelegate>delegate;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@end
