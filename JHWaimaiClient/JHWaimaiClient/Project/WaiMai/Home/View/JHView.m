//
//  JHView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHView.h"

@implementation JHView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (self.willToHitView && !self.willToHitView.hidden) {
        CGPoint pt = [self convertPoint:point toView:self.willToHitView];
        if ([self.willToHitView pointInside:pt withEvent:event]) {
            return self.willToHitView;
        }
    }
    
    return [super hitTest:point withEvent:event];
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BACK_COLOR;
    }
    return self;
}

@end
