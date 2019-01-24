//
//  UIScrollView+XHTool.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/9/22.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "UIScrollView+XHTool.h"
#import <objc/runtime.h>
@implementation UIScrollView (XHTool)
+ (void)load{
    Method systemMethod = class_getInstanceMethod(self, @selector(initWithFrame:));
    Method customMethod = class_getInstanceMethod(self, @selector(xh_initWithFrame:));
    method_exchangeImplementations(systemMethod, customMethod);
}
- (instancetype)xh_initWithFrame:(CGRect)frame{
    UIScrollView *scrollV = [self xh_initWithFrame:frame];
    if (@available(iOS 11.0, *)) {
        scrollV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return scrollV;
}
@end
