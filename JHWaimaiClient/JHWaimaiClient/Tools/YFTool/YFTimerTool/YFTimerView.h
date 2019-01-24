//
//  YFTimerView.h
//  Timer_Demo
//
//  Created by ios_yangfei on 2018/12/15.
//  Copyright © 2018年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFTimer.h"

@interface YFTimerView : UIView <YFTimerDelegate>

// HH:mm:ss SSS  mm:ss SSS   HH:mm:ss  mm:ss
@property(nonatomic,copy)NSString *formatter;

@property(nonatomic,strong)UIFont *time_font;

@property(nonatomic,strong)UIColor *time_color;

@property(nonatomic,strong)UIColor *time_background_color;

@property(nonatomic,strong)UIColor *ms_color;
// 单个倒计时lab的width
@property(nonatomic,assign)CGFloat single_w;
// 倒计时的结束时间
@property(nonatomic,assign)NSTimeInterval dateline;

/**
 初始化

 @param params 上面的参数
 @return        倒计时view
 */
/*
 params  @{
 @"formatter":@"HH:mm:ss SSS",
  @"time_font":time_font,
  @"time_color":time_color,
  @"time_background_color":time_background_color,
  @"ms_color":ms_color
 }
 */
-(instancetype)initWithConfigParams:(NSDictionary *)params;


@end


