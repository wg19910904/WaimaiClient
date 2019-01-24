//
//  XHLabel.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/8/2.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "XHLabel.h"

@implementation XHLabel
{
    UITapGestureRecognizer *ges;
}
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (void)addTarget:(id)target action:(SEL)selector{
    self.userInteractionEnabled = YES;
    ges = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:ges];
}
@end
