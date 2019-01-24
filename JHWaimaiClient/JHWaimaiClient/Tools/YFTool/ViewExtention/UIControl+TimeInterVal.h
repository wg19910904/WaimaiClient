//
//  UIControl+TimeInterVal.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/18.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (TimeInterVal)
// 响应的时间间隔
@property (nonatomic, assign) NSTimeInterval responderTimeInterval;// 可以用这个给重复点击加间隔

@end
