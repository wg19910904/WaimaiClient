//
//  YFTimer.h
//  Timer_Demo
//
//  Created by ios_yangfei on 2018/12/15.
//  Copyright © 2018年 jianghu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YFTimerDelegate <NSObject>
@optional
-(void)toDoThingsWhenTimeCome:(NSTimeInterval)interval;

@end

@interface YFTimer : NSObject
// 定时器的间隔
@property(nonatomic,assign)NSTimeInterval interval;

// 添加代理
-(void)timerAddDelegate:(id<YFTimerDelegate>)delegate;

// 取消代理
-(void)timerDeleteDelegate:(id<YFTimerDelegate>)delegate;

// 创建定时器
-(void)fireTimeWithInterval:(NSTimeInterval)interval;

// 取消定时器
-(void)invalidate;

@end

