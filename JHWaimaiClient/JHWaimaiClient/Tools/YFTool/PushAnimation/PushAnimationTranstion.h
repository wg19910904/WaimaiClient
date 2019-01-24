//
//  PushAnimationTranstion.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

//非手势动画  显示和消失都会调用这个类
typedef NS_ENUM(NSUInteger, YFPushAnimationTransitionType) {
    YFPushTransitionType = 0,//管理present动画
    YFPopTransitionType
};

@interface PushAnimationTranstion : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign)YFPushAnimationTransitionType type;
//根据定义的枚举初始化的两个方法,确定是消失还是现实
+ (instancetype)transitionWithTransitionType:(YFPushAnimationTransitionType)type;
- (instancetype)initWithTransitionType:(YFPushAnimationTransitionType)type;

@end
