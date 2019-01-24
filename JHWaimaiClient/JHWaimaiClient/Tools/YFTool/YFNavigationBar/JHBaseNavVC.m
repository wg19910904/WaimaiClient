//
//  CZNavigationController.m
//  ChongZu
//
//  Created by cz10000 on 16/4/27.
//  Copyright © 2016年 cz10000. All rights reserved.
//

#import "JHBaseNavVC.h"
#import "UIImage+Extension.h"
#import "UINavigationBar+Awesome.h"
#import "PushAnimationTranstion.h"

@interface JHBaseNavVC ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@end

@implementation JHBaseNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.gesture_enable = YES;
    self.navigationBar.translucent = YES;
    
    self.navigationBar.tintColor = NaVi_COLOR_Alpha(1.0);
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName:HEX(@"333333", 1.0)}];

    // 1,创建Pan手势识别器,并绑定监听方法
    UIScreenEdgePanGestureRecognizer *panGestureRec = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(dealPanGesture:)];
    panGestureRec.edges = UIRectEdgeLeft;
    // 为导航控制器的view添加Pan手势识别器
    [self.view addGestureRecognizer:panGestureRec];
}

-(void)setIs_white_nav:(BOOL)is_white_nav{
    _is_white_nav = is_white_nav;
    if (is_white_nav) {
        [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
}

// push到新界面的处理
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    UIViewController *hadVc;
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:[viewController class]]) {
            hadVc = vc;
            break;
        }
    }
    if (hadVc) {
        NSMutableArray *vcArr = [NSMutableArray arrayWithArray:self.viewControllers];
        [vcArr removeObject:hadVc];
        self.viewControllers = vcArr.copy;
    }
    
    if (self.viewControllers.count >= 1) {
         viewController.hidesBottomBarWhenPushed = YES;
        
    }

    [super pushViewController:viewController animated:animated];
    
}
#pragma mark ====== Push =======
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    // push和pop的动画管理对象
    if( operation == UINavigationControllerOperationPush){
        return [[PushAnimationTranstion alloc] initWithTransitionType:YFPushTransitionType];
    }else{
        return [[PushAnimationTranstion alloc] initWithTransitionType:YFPopTransitionType];
    }
    
}


- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.percentDrivenTransition;
}

- (void)dealPanGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    float progress = [gesture translationInView:self.view].x / [UIScreen mainScreen].bounds.size.width;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [UIPercentDrivenInteractiveTransition new];
        
        if (self.tabBarController.selectedIndex == 0 && [self.visibleViewController isKindOfClass:NSClassFromString(@"JHWaimaiOrderDetailVC")]){
            return;
        }else{
            [self popViewControllerAnimated:YES];
        }
        
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
