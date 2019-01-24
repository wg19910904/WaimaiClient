//
//  PresentOneTransition.m
//  TransitionTest
//
//  Created by ios_yangfei on 16/11/25.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "PresentAnimationTransition.h"

@implementation PresentAnimationTransition
+ (instancetype)transitionWithTransitionType:(YFPresentTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(YFPresentTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

//主要方法返回 界面显示和消失所需的时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return  0.3;//_type == YFPresentTransitionTypePushDismiss ? 0.25 : 0.5;
}
//主要方法返回 界面显示和消失具体动画如何实现
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

    switch (_type) {
        case YFPresentTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case YFPresentTransitionTypePushPresent:
            [self presentPushAnimation:transitionContext];
            break;
            
        case YFPresentTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
        
        case YFPresentTransitionTypePushDismiss:
            [self dismissPushAnimation:transitionContext];
            break;
            
        case YFPresentTransitionTypeShowImgs:
            [self imagePresentPushAnimation:transitionContext];
            break;
            
        case YFPresentTransitionTypeHiddenImgs:
            [self imageDismissPushAnimation:transitionContext];
            break;
            
        case YFPresentTransitionTypeShowHongBao:
            [self hongBaoPresentPushAnimation:transitionContext];
            break;
            
        case YFPresentTransitionTypeDismissHongBao:
            [self hongBaoDismissPushAnimation:transitionContext];
            break;
            
        case YFPresentTransitionTypePresentWithAnimation:
            [self presentWithAnimation:transitionContext];
            break;
            
        case YFPresentTransitionTypeDismissWithAnimation:
            [self dismissWithAnimation:transitionContext];
            break;
            
        case YFPresentTransitionTypePresentCaseIn:
            [self presentCaseIn:transitionContext];
            break;
            
        case YFPresentTransitionTypeDismissCaseOut:
            [self dismissCaseOut:transitionContext];
            break;

    }
}

//实现present动画逻辑代码
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    //蒙板
    UIView *view = [[UIView alloc] initWithFrame:containerView.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    view.alpha = 0.0;
    view.tag = 100;
    [containerView addSubview:view];

    toVC.view.transform = CGAffineTransformMakeTranslation(0, containerView.bounds.size.height);

   [containerView addSubview:toVC.view];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        view.alpha = 1.0;
        toVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

//实现dismiss动画逻辑代码
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *view = [containerView viewWithTag:100];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromVC.view.alpha = 0.0;
        view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        [view removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


//实现present动画从底部弹出逻辑代码
- (void)presentWithAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    //蒙板
    UIView *tempView = [[UIView alloc] initWithFrame:containerView.bounds];
    tempView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    tempView.alpha = 0.0;
    tempView.tag = 100;
    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    
    toVC.view.transform = CGAffineTransformMakeTranslation(0, containerView.bounds.size.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.alpha = 1.0;
        toVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

//实现dismiss动画从底部消失逻辑代码
- (void)dismissWithAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *tempView = [containerView viewWithTag:100];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.y = HEIGHT + containerView.bounds.size.height;
        tempView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        [tempView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

//实现present动画从底部弹出逻辑代码
- (void)presentCaseIn:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    //蒙板
    UIView *tempView = [[UIView alloc] initWithFrame:containerView.bounds];
    tempView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    tempView.alpha = 0.0;
    tempView.tag = 100;

    toVC.view.alpha = 0.0;

    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.alpha = 1.0;
        toVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

//实现present动画从底部弹出逻辑代码
- (void)dismissCaseOut:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *tempView = [containerView viewWithTag:100];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.alpha = 0.0;
        tempView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        [tempView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark ======Push Present=======
//实现push present动画逻辑代码
- (void)presentPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect fromVCRect = fromVC.view.frame;
    fromVCRect.origin.x = 0;
    fromVC.view.frame = fromVCRect;
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
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         fromVC.view.frame = fromVCRect;
                         toVC.view.frame = toVCRect;
                     }
                     completion:^(BOOL finished) {
                        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];//动画结束、取消必须调用
                     }];

}

//实现dismiss present动画逻辑代码
- (void)dismissPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect fromVCRect = fromVC.view.frame;
    fromVCRect.origin.x = 0;
    fromVC.view.frame = fromVCRect;
    
    if ([fromVC isKindOfClass:[UITabBarController class]]) {
        [container insertSubview:toVC.view belowSubview:fromVC.view];
    }
//    [container insertSubview:toVC.view belowSubview:fromVC.view];
    CGRect toVCRect = toVC.view.frame;
    toVCRect.origin.x = -screenWidth * 0.3;
    toVC.view.frame = toVCRect;
    
    fromVCRect.origin.x = screenWidth;
    toVCRect.origin.x = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = fromVCRect;
        toVC.view.frame = toVCRect;
    } completion:^(BOOL finished){
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];//动画结束、取消必须调用
    }];
    
}


#pragma mark ======Images Present=======
//实现push present动画逻辑代码
- (void)imagePresentPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
 
    UIImageView *tempView = [UIImageView new];
    UIImage *img = [self.delegate presentAnimationTransitionWillNeedView];
    tempView.image = img;
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.clipsToBounds = YES;
    
    UIView *containerView = [transitionContext containerView];
    tempView.frame = [self.delegate presentAnimationTransitionViewFrame];

    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    toVC.view.alpha = 0.0;
    //开始做动画
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:0 animations:^{
        toVC.view.alpha = 1.0;
        tempView.frame = FRAME(10, (HEIGHT - (WIDTH - 20))/2.0, WIDTH - 20, WIDTH - 20) ;
    } completion:^(BOOL finished) {
        containerView.backgroundColor = [UIColor clearColor];
        tempView.hidden = YES;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

//实现dismiss present动画逻辑代码
- (void)imageDismissPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    //这里的lastView就是push时候初始化的那个tempView
    UIImageView *tempView = containerView.subviews.lastObject;

    //设置初始状态
    tempView.hidden = NO;
    UIImage *img = [self.delegate presentAnimationTransitionWillNeedView];
    tempView.image = img;
    
    [containerView insertSubview:toVC.view atIndex:0];
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:0 animations:^{
        tempView.frame = [self.delegate presentAnimationTransitionViewFrame];
        fromVC.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        [tempView removeFromSuperview];
        
    }];
    
}

#pragma mark ======HongBao Present=======
- (void)hongBaoPresentPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *tempView = [[UIView alloc] initWithFrame:containerView.bounds];
    tempView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    tempView.alpha = 0.0;
    tempView.tag = 100;
    
    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    
    toVC.view.transform = CGAffineTransformMakeScale(0, 0);
    
     [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:0 animations:^{
        tempView.alpha = 1.0;
        toVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

- (void)hongBaoDismissPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    UIView *tempView = [containerView viewWithTag:100];
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:0 animations:^{
        tempView.alpha = 0.0;
        fromVC.view.transform = CGAffineTransformMakeTranslation(0, HEIGHT);
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        [tempView removeFromSuperview];
        
    }];
}
@end
