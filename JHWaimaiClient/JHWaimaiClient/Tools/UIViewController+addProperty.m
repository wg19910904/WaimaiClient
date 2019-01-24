//
//  UIViewController+addProperty.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/3.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "UIViewController+addProperty.h"
#import "NSObject+XHTool.h"

static char navicolor;
//static char vc_flag;
//static char willDismissVcKey;

@implementation UIViewController (addProperty)

// 给属性提供getter和setter方法
- (UIColor *)naviColor{
    return objc_getAssociatedObject(self, &navicolor);
}

-(void)setNaviColor:(UIColor *)naviColor{
    
    objc_setAssociatedObject(self, &navicolor,naviColor,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//- (BOOL)vc_present_flag{
//    return [objc_getAssociatedObject(self, &vc_flag) boolValue];
//}
//
//-(void)setVc_present_flag:(BOOL)vc_present_flag{
//
//    objc_setAssociatedObject(self, &vc_flag,@(vc_present_flag),OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//- (NSString *)willDismissVC{
//    return objc_getAssociatedObject(self, &willDismissVcKey);
//}
//
//-(void)setWillDismissVC:(NSString *)willDismissVC{
//
//    objc_setAssociatedObject(self, &willDismissVcKey,willDismissVC,OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

+(void)load{
    [super load];

    Method systemMethod = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
    Method customMethod = class_getInstanceMethod(self, @selector(yf_presentViewController:animated:completion:));
    method_exchangeImplementations(systemMethod, customMethod);
    
    
    Method smethod = class_getInstanceMethod(self, @selector(dismissViewControllerAnimated:completion:));
    Method cmethod= class_getInstanceMethod(self, @selector(yf_dismissViewControllerAnimated:completion:));
    method_exchangeImplementations(smethod, cmethod);

}

-(void)yf_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    
    if ([viewControllerToPresent isKindOfClass:NSClassFromString(@"UIDocumentMenuViewController")] || [viewControllerToPresent isKindOfClass:NSClassFromString(@"UIImagePickerController")] || [viewControllerToPresent isKindOfClass:NSClassFromString(@"UIDocumentPickerViewController")]) {
//        [self setVc_present_flag:YES];
//        [self setWillDismissVC:NSStringFromClass([viewControllerToPresent class])];
//        NSLog(@"vc: %@  bool: %d",viewControllerToPresent,[self vc_present_flag]);
    }
    
    [self yf_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

-(void)yf_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    
    if ([self isKindOfClass:NSClassFromString(@"JHMoreShopCartVCViewController")]) {
        [self yf_dismissViewControllerAnimated:flag completion:completion];
        return;
    }
    #pragma mark ======function 1======= (2,3 方法没写好)
    static BOOL before = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        before = YES;
        NSLog(@"YES");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"NO");
            before = NO;
        });
    });
    
    if (before) {
        before = NO;
        NSLog(@"RETURN");
        return;
    }
    NSLog(@"DISMISS");
    [self yf_dismissViewControllerAnimated:flag completion:completion];
    
    #pragma mark ======function 2=======
//    NSLog(@"%d",[self vc_present_flag]);
//    static BOOL before = NO;
//    if ([self vc_present_flag]) {
//        [self setVc_present_flag:NO];
//        before = YES;
////        [self yf_dismissViewControllerAnimated:flag completion:completion];
//        return;
//    }
//    if (before) {
//         before = NO;
//        return;
//    }
//    [self yf_dismissViewControllerAnimated:flag completion:completion];
    
    #pragma mark ======function 3=======
    
//
//    NSLog(@"%d",[self vc_present_flag]);
//
//    id dismissVC = [self willDismissVC];
//    if ([dismissVC isKindOfClass:NSClassFromString(@"UIDocumentMenuViewController")]
//        ||
//        [dismissVC isKindOfClass:NSClassFromString(@"UIImagePickerController")]) {
//
//
//            static BOOL before = NO;
//            if ([self vc_present_flag]) {
//                [self setVc_present_flag:NO];
//                before = YES;
//                [self yf_dismissViewControllerAnimated:flag completion:completion];
//                return;
//            }
//            if (before) {
//                 before = NO;
//                return;
//            }
//            [self yf_dismissViewControllerAnimated:flag completion:completion];
//
//    }else if ([dismissVC isKindOfClass:NSClassFromString(@"UIDocumentPickerViewController")]){
//
//        static BOOL before = NO;
//        if ([self vc_present_flag]) {
//            [self setVc_present_flag:NO];
//            before = YES;
//            [self yf_dismissViewControllerAnimated:flag completion:completion];
//            return;
//        }
//        if (before) {
//             before = NO;
//            return;
//        }
//        [self yf_dismissViewControllerAnimated:flag completion:completion];
//
//    }else{
//       [self yf_dismissViewControllerAnimated:flag completion:completion];
//    }

}


- (UIViewController*)topViewController
{
    //解决Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!问题
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
    
}


@end
