//
//  YFTimerManager.h
//  Timer_Demo
//
//  Created by ios_yangfei on 2018/12/15.
//  Copyright © 2018年 jianghu3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFSingleTon.h"
#import "YFTimer.h"

@protocol YFTimerDelegate;

@interface YFTimerManager : NSObject

@property(nonatomic,strong)NSMutableArray *timers;

YFSingleTonH(YFTimerManager)

// 添加一个时间间隔是interval的定时器
+(void)addTimerWithTimeInterval:(NSTimeInterval)interval;

// 给时间间隔是interval的定时器设置代理
+(void)addTimerDelegate:(id<YFTimerDelegate>)delegate forTimeInterval:(NSTimeInterval)interval;

// 给时间间隔是interval的定时器取消代理
+(void)deleteTimerDelegate:(id<YFTimerDelegate>)delegate forTimeInterval:(NSTimeInterval)interval;

// 取消一个时间间隔是interval的定时器
+(void)invalidateTimerForTimeInterval:(NSTimeInterval)interval;

// 取消所有的定时器
+(void)invalidateAllTimer;

@end

