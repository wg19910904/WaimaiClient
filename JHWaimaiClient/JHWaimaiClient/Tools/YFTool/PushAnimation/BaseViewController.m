//
//  BaseViewController.m
//  NavigationPresent
//
//  Created by kamous on 2017/1/8.
//  Copyright © 2017年 kamous. All rights reserved.
//

#import "BaseViewController.h"
#import "PresentAnimationTransition.h"
#import "PushAnimationTranstion.h"

@interface BaseViewController () <
UIViewControllerTransitioningDelegate,
UIGestureRecognizerDelegate,UINavigationControllerDelegate
>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@property(nonatomic,weak)UINavigationController *presentNav;
@end

@implementation BaseViewController

//封装原presentViewController:animated:completion:接口
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
                    pushStyle:(BOOL)isPushStyle {
    
//    self.transitioningDelegate = self;
//    self.modalPresentationStyle = UIModalPresentationCustom;
    
    if (animated && isPushStyle) {
        viewControllerToPresent.transitioningDelegate = self;
        
        // 只给tabBar的第一个控制器的第一个vc添加dismiss手势
        UIViewController *gestureVC = viewControllerToPresent;
        if ([viewControllerToPresent isKindOfClass:NSClassFromString(@"UITabBarController")]) {
            UIViewController * vc = [(UITabBarController *)viewControllerToPresent viewControllers].firstObject;
            if ([vc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *)vc;
                gestureVC = nav;
                self.presentNav = nav;
            }
        }
        //添加自定义的返回手势
        UIScreenEdgePanGestureRecognizer *screenGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                            action:@selector(onPanGesture:)];
        screenGesture.delegate = self;
        screenGesture.edges = UIRectEdgeLeft;
        [gestureVC.view addGestureRecognizer:screenGesture];
        if (self.presentNav) {
            [screenGesture requireGestureRecognizerToFail:self.presentNav.interactivePopGestureRecognizer];
        }
    }
    [self presentViewController:viewControllerToPresent animated:animated completion:completion];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
    return [[PresentAnimationTransition alloc] initWithTransitionType:YFPresentTransitionTypePushPresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[PresentAnimationTransition alloc] initWithTransitionType:YFPresentTransitionTypePushDismiss];;
}

//present的返回手势需要实现
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    if ([animator isKindOfClass:[PresentAnimationTransition class]] && [(PresentAnimationTransition *)animator type] == YFPresentTransitionTypePushDismiss) {
        return self.percentDrivenTransition;
    }
    return nil;
}

#pragma mark - UIGestureRecognizer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]
        && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;//和NavigationController自带的返回手势能同时执行
    } else {
        return  NO;
    }
}
- (void)onPanGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    // 解决手势返回导致返回多层的问题
    if (![(BaseViewController *)self.presentNav.viewControllers.firstObject gesture_present_enable]) {
        return;
    }
    
    float progress = [gesture translationInView:self.view].x / [UIScreen mainScreen].bounds.size.width;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [UIPercentDrivenInteractiveTransition new];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    } else if (gesture.state == UIGestureRecognizerStateCancelled ||
               gesture.state == UIGestureRecognizerStateEnded) {
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        } else {
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
    }
}

@end
