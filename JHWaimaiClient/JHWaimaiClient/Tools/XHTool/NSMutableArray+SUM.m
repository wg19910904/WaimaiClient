//
//  NSMutableArray+SUM.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/27.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "NSMutableArray+SUM.h"

@implementation NSMutableArray (SUM)
-(CGFloat)SUM:(NSInteger)index{
    if (index < 0) {
        return 0;
    }
    //
    if (index>=self.count) {
        index = self.count-1;
    }

    //
    CGFloat sum = 0;
    for (int i = 0; i <= index; i++) {
        sum += [self[i] doubleValue];
    }
    return sum;
}
@end
