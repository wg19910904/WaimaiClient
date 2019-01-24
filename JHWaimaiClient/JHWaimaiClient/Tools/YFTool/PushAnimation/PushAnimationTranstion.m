//
//  PushAnimationTranstion.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "PushAnimationTranstion.h"
#import "JHBaseVC.h"
#import "UINavigationBar+Awesome.h"
#import "JHWMShopGoodDetailVC.h"
#import "JHWMSearchOnShopVC.h"

@interface PushAnimationTranstion ()

@end

@implementation PushAnimationTranstion

// 所属的导航栏有没有TabBarController
-(BOOL)isTabbarExist:(UINavigationController *)navigationController{
    
    UIViewController *beyondVC = navigationController.view.window.rootViewController;
    //判断该导航栏是否有TabBarController
    if (navigationController.tabBarController == beyondVC || [beyondVC isKindOfClass:[UITabBarController class]]) {
        return YES;
    }
    else
    {
        return  NO;
    }
}

+ (instancetype)transitionWithTransitionType:(YFPushAnimationTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(YFPushAnimationTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

//主要方法返回 界面显示和消失所需的时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return  0.3;
}
//主要方法返回 界面显示和消失具体动画如何实现
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_type) {
        case YFPushTransitionType:
            [self pushAnimation:transitionContext];
            break;
            
        case YFPopTransitionType:
            [self popAnimation:transitionContext];
            break;
    }
}

-(void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    JHBaseVC *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    JHBaseVC *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect fromVCRect = fromVC.view.frame;
    fromVCRect.origin.x = 0;
    fromVC.view.frame = fromVCRect;
    
     // tabBar的处理
    UIView *tabbarView = nil;
    if (([self isTabbarExist:fromVC.navigationController] && fromVC.navigationController.viewControllers.firstObject == fromVC )) {
//        tabbarView = [container viewWithTag:100];
        tabbarView = [self screenShotWith:fromVC update:NO];
        if (tabbarView) {
            // SYSTEM_GESTURE_HEIGHT 因为HEIGHT里面减了SYSTEM_GESTURE_HEIGHT

            tabbarView.frame = FRAME(0, HEIGHT - VC_TABBAR_HEIGHT, WIDTH, TABBAR_HEIGHT);
            [container addSubview:tabbarView];
            fromVC.navigationController.tabBarController.tabBar.alpha = 0;
            tabbarView.tag = 100;
        }
    }
    
    UIView *shopDetailView = nil;
    if ([toVC isKindOfClass:NSClassFromString(@"JHWMShopGoodDetailVC")] || [toVC isKindOfClass:NSClassFromString(@"JHWMSearchOnShopVC")]) {
        shopDetailView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
        [fromVC.view addSubview:shopDetailView];
    }

    [container addSubview:toVC.view];
    
    CGRect toVCRect = toVC.view.frame;
    toVCRect.origin.x = screenWidth;
    toVC.view.frame = toVCRect;
    
    toVC.view.layer.masksToBounds = NO;
    toVC.view.layer.shadowRadius = 6;
    toVC.view.layer.shadowOpacity = 0.8;
    toVC.view.layer.shadowOffset = CGSizeMake(0, 3);
    toVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (toVC.view.layer.shadowPath == NULL) {
        toVC.view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:toVC.view.bounds] CGPath];
    }
    
    fromVCRect.origin.x = -screenWidth * 0.3;
    toVCRect.origin.x = 0;
    
   
    // 导航栏的颜色处理
   
    [toVC.navigationController.navigationBar yf_setBackgroundColor:fromVC.naviColor];

    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [toVC.navigationController.navigationBar yf_setBackgroundColor:toVC.naviColor];
                         fromVC.view.frame = fromVCRect;
                         toVC.view.frame = toVCRect;
                         if (tabbarView) {
                             tabbarView.x = -WIDTH * 0.3;
                         }

                     }
                     completion:^(BOOL finished) {

                         if (![transitionContext transitionWasCancelled]) {
                             fromVC.navigationController.tabBarController.tabBar.alpha = 1.0;
                             if (shopDetailView) {
                                 [shopDetailView removeFromSuperview];
                             }
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];//动画结束、取消必须调用
                     }];
}

-(void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    JHBaseVC *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    JHBaseVC *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect fromVCRect = fromVC.view.frame;
    fromVCRect.origin.x = 0;
    fromVC.view.frame = fromVCRect;
    
    [container insertSubview:toVC.view belowSubview:fromVC.view];
    CGRect toVCRect = toVC.view.frame;
    toVCRect.origin.x = -screenWidth * 0.3;
    toVC.view.frame = toVCRect;
    
    fromVCRect.origin.x = screenWidth;
    toVCRect.origin.x = 0;

    // 导航栏的颜色处理
    [toVC.navigationController.navigationBar yf_setBackgroundColor:fromVC.naviColor];
    
    // tabBar的处理
    toVC.navigationController.tabBarController.tabBar.alpha = 0;
    UIView *tabbarView = nil;
    if ([self isTabbarExist:toVC.navigationController] && toVC.navigationController.viewControllers.firstObject == toVC) {
        tabbarView = [container viewWithTag:100];
        [container insertSubview:tabbarView atIndex:1];// 跑腿模块时层级不对
    }
   
    
    UIView *shopDetailView = nil;
    CALayer *sublayer = nil;
    if ([fromVC isKindOfClass:NSClassFromString(@"JHWMShopGoodDetailVC")] || [fromVC isKindOfClass:NSClassFromString(@"JHWMSearchOnShopVC")]) {
        UIView *snapView;
        if ([fromVC isKindOfClass:NSClassFromString(@"JHWMShopGoodDetailVC")]) {
            snapView = [(UIViewController *)[(JHWMShopGoodDetailVC *)fromVC shopCartVC] view];
        }else{
            snapView = [(UIViewController *)[(JHWMSearchOnShopVC *)fromVC shopCartVC] view];
        }
        shopDetailView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
        [fromVC.view addSubview:shopDetailView];
        
        sublayer = [snapView.layer modelLayer];
        sublayer.frame = snapView.frame;
        [toVC.view.layer addSublayer:sublayer];
        
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = fromVCRect;
        toVC.view.frame = toVCRect;
        [toVC.navigationController.navigationBar yf_setBackgroundColor:toVC.naviColor];
        if (tabbarView) {
            tabbarView.x = 0;
        }
    } completion:^(BOOL finished){
        
        if([fromVC isKindOfClass:NSClassFromString(@"JHWaiMaiShopDetailVC")]){
            [NoticeCenter postNotificationName:@"RemoveWMShopCart" object:nil userInfo:nil];
        }
        if (![transitionContext transitionWasCancelled]) {
            fromVC.view.layer.masksToBounds = NO;
            fromVC.view.layer.shadowRadius = 0;
            fromVC.view.layer.shadowOpacity = 0;
            fromVC.view.layer.shadowOffset = CGSizeMake(0, 0);
            fromVC.view.layer.shadowColor = [UIColor clearColor].CGColor;
            
            if (fromVC.view.layer.shadowPath != NULL) {
                fromVC.view.layer.shadowPath = NULL;
            }
            
            if (tabbarView) {
                [tabbarView removeFromSuperview];
            }
            toVC.navigationController.tabBarController.tabBar.alpha = 1.0;
            
        }else{
            [toVC.navigationController.navigationBar yf_setBackgroundColor:toVC.naviColor];
            if (sublayer) {
                [fromVC.view.layer addSublayer:sublayer];
            }
        }
        
        if (shopDetailView) {
            [shopDetailView removeFromSuperview];
        }

        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];//动画结束、取消必须调用
    }];
    
}

// 存在tabbar截图tabbar
- (UIView *)screenShotWith:(UIViewController *)vc update:(BOOL)update
{
    if (vc.navigationController) {
        BOOL isTabbarExist = [self isTabbarExist:vc.navigationController];

        if (isTabbarExist) {
            return  [((UITabBarController *)vc.navigationController.tabBarController).tabBar snapshotViewAfterScreenUpdates:update];
        }
        else
        {
            return nil;
        }
    }
    
    return nil;
    
}

- (UIImage *)convertViewToImage:(UIView *)view
{
    //https://github.com/alskipp/ASScreenRecorder 录屏代码
    // 第二个参数表示是否非透明。如果需要显示半透明效果，需传NO，否则YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,[UIScreen mainScreen].scale);

    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
