//
//  YFTimer.m
//  Timer_Demo
//
//  Created by ios_yangfei on 2018/12/15.
//  Copyright © 2018年 jianghu3. All rights reserved.
//

#import "YFTimer.h"

@interface YFTimer()
// NSPointerArray 可以让数组中的引用是弱引用
// 关于NSPointerArray的使用 https://blog.csdn.net/jeffasd/article/details/50505550
// 所有定时器的代理
@property(nonatomic,strong)NSPointerArray *delegates;
// 定时器
@property (nonatomic,strong)dispatch_source_t timer;

@end

@implementation YFTimer

// 添加定时器
-(void)fireTimeWithInterval:(NSTimeInterval)interval{
    
    self.interval = interval;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0); //每多少秒触发timer，误差多少秒
    dispatch_source_set_event_handler(timer, ^{
        // 定时器触发时执行的 block
        [self isTimeToDoThing];
    });
    dispatch_resume(timer);
    
    self.timer = timer;

}

// 取消定时器
-(void)invalidate{
    self.delegates = nil;
    self.timer = nil;
}

// 添加代理
-(void)timerAddDelegate:(id<YFTimerDelegate>)delegate{
    if (![self.delegates.allObjects containsObject:delegate]) {
        [self.delegates addPointer:(__bridge void * _Nullable)(delegate)];
    }
}

// 取消代理
-(void)timerDeleteDelegate:(id<YFTimerDelegate>)delegate{
    if ([self.delegates.allObjects containsObject:delegate]) {
        NSInteger index = [self.delegates.allObjects indexOfObject:delegate];
        [self.delegates removePointerAtIndex:index];
    }
}

// 倒计时要做的事
-(void)isTimeToDoThing{
    
    if (self.delegates.count == 0) return;
    
    for (id<YFTimerDelegate>delegate in self.delegates.allObjects) {
        if (delegate && [delegate respondsToSelector:@selector(toDoThingsWhenTimeCome:)]) {
            [delegate toDoThingsWhenTimeCome:self.interval];
        }
    }
   
}

-(NSPointerArray *)delegates{
    if (!_delegates) {
        _delegates = [NSPointerArray weakObjectsPointerArray];
    }
    return _delegates;
}

@end
