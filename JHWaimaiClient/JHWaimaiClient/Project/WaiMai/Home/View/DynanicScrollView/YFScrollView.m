//
//  YFScrollView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "YFScrollView.h"

@interface YFScrollView ()

@end

@implementation YFScrollView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 当上下拖动的时候不能左右滑动
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        if (fabs(point.y)  >=  fabs(point.x)) {
            return NO;
        }
    }
    return YES;
}

@end
