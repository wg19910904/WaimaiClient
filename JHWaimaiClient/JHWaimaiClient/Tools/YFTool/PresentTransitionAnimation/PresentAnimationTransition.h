//
//  PresentOneTransition.h
//  TransitionTest
//
//  Created by ios_yangfei on 16/11/25.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//非手势动画  显示和消失都会调用这个类
typedef NS_ENUM(NSUInteger, YFPresentTransitionType) {
    YFPresentTransitionTypePresent = 0,//管理present动画
    YFPresentTransitionTypeDismiss,//管理dismiss动画
    YFPresentTransitionTypePresentWithAnimation,//管理present动画从底部慢慢弹出
    YFPresentTransitionTypeDismissWithAnimation,//管理dismiss动画从底部慢慢消失
    YFPresentTransitionTypePresentCaseIn, // 淡入
    YFPresentTransitionTypeDismissCaseOut,// 淡出
    YFPresentTransitionTypePushPresent,// present动画类似push
    YFPresentTransitionTypePushDismiss,// dismiss动画类似push
    YFPresentTransitionTypeShowImgs,// 图片浏览器的动画
    YFPresentTransitionTypeHiddenImgs,// 图片浏览器消失的动画
    YFPresentTransitionTypeShowHongBao,// 天降红包的动画
    YFPresentTransitionTypeDismissHongBao,// 天降红包消失的动画
};

@protocol PresentAnimationTransitionShowImgDelegate <NSObject>

-(CGRect )presentAnimationTransitionViewFrame;
-(UIImage *)presentAnimationTransitionWillNeedView;

@end

@interface PresentAnimationTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property(nonatomic,weak)id<PresentAnimationTransitionShowImgDelegate> delegate;
@property(nonatomic,assign)YFPresentTransitionType type;
//根据定义的枚举初始化的两个方法,确定是消失还是现实
+ (instancetype)transitionWithTransitionType:(YFPresentTransitionType)type;
- (instancetype)initWithTransitionType:(YFPresentTransitionType)type;

@end
