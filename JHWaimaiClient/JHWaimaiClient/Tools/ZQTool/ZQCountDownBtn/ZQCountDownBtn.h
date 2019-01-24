//
//  ZQCountDownBtn.h
//  ZQCountDownBtn
//
//  Created by ijianghu on 17/3/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
//倒计时的按钮
@interface ZQCountDownBtn : UIButton
@property(nonatomic,copy)void(^clickBlock)(void);
//开始倒计时
-(void)startCountDown;
@end
