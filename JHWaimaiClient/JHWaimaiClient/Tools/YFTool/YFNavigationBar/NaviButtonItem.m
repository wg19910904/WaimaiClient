//
//  ButtonItemView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2017/9/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "NaviButtonItem.h"

@implementation NaviButtonItem

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.width = 0;
    for (UIView *view in self.subviews) {
        self.width += view.width;
        if (self.type == NaviButtonItemTypeRight) {
            NSInteger index = [self.subviews indexOfObject:view];
            view.x = 40 * index + 15;
        }else{
            view.x -= 15;
        }
//        self.type == NaviButtonItemTypeRight ? (view.x += 15) : (view.x -= 15);
    }
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    for (UIView *view in self.subviews) {
        CGPoint pt = [self convertPoint:point toView:view];
//        NSLog(@"pt  %@",NSStringFromCGPoint(pt));
        if ([view hitTest:pt withEvent:event]) {
            return view;
        }
    }
//    NSLog(@"%@",NSStringFromCGPoint(point));
    return [super hitTest:point withEvent:event];
}

@end
