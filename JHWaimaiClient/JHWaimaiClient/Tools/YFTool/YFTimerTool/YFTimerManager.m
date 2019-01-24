//
//  YFTimerManager.m
//  Timer_Demo
//
//  Created by ios_yangfei on 2018/12/15.
//  Copyright © 2018年 jianghu3. All rights reserved.
//

#import "YFTimerManager.h"

@interface YFTimerManager ()<YFTimerDelegate>

@end

@implementation YFTimerManager

YFSingleTonM(YFTimerManager)

// 添加一个时间间隔是interval的定时器
+(void)addTimerWithTimeInterval:(NSTimeInterval)interval{
    
    for (YFTimer *timer in [YFTimerManager shareYFTimerManager].timers) {
        if (timer.interval == interval) {// 防止重复添加定时器
            return;
        }
    }
    
    YFTimer *timer = [[YFTimer alloc] init];
    [timer fireTimeWithInterval:interval];
    
    [[YFTimerManager shareYFTimerManager].timers addObject:timer];

}

// 取消一个时间间隔是interval的定时器
+(void)invalidateTimerForTimeInterval:(NSTimeInterval)interval{
    for (YFTimer *timer in [YFTimerManager shareYFTimerManager].timers) {
        if (timer.interval == interval) {// 防止重复添加定时器
            [timer invalidate];
            [[YFTimerManager shareYFTimerManager].timers removeObject:timer];
            return;
        }
    }
}

// 取消所有的定时器
+(void)invalidateAllTimer{
    
    for (YFTimer *timer in [YFTimerManager shareYFTimerManager].timers) {
        [timer invalidate];
    }
    [[YFTimerManager shareYFTimerManager].timers removeAllObjects];
}

// 给时间间隔是interval的定时器设置代理
+(void)addTimerDelegate:(id<YFTimerDelegate>)delegate forTimeInterval :(NSTimeInterval)interval{
    
    for (YFTimer *timer in [YFTimerManager shareYFTimerManager].timers) {
        if (timer.interval == interval) {// 防止重复添加定时器
            [timer timerAddDelegate:delegate];
            return;
        }
    }
}

// 给时间间隔是interval的定时器取消代理
+(void)deleteTimerDelegate:(id<YFTimerDelegate>)delegate forTimeInterval:(NSTimeInterval)interval{
    for (YFTimer *timer in [YFTimerManager shareYFTimerManager].timers) {
        if (timer.interval == interval) {// 防止重复添加定时器
            [timer timerDeleteDelegate:delegate];
            return;
        }
    }
}

-(NSMutableArray *)timers{
    if (_timers==nil) {
        _timers=[[NSMutableArray alloc] init];
    }
    return _timers;
}

@end
