//
//  BaseViewController.h
//  NavigationPresent
//
//  Created by kamous on 2017/1/8.
//  Copyright © 2017年 kamous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
                    pushStyle:(BOOL)isPushStyle;

// 手势驱动时 present手势和pop手势的冲突，YES响应present手势
@property(nonatomic,assign)BOOL gesture_present_enable;
@end
