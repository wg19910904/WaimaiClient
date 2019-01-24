//
//  ZQCountDownBtn.m
//  ZQCountDownBtn
//
//  Created by ijianghu on 17/3/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQCountDownBtn.h"
@interface ZQCountDownBtn (){
    int num;
    NSTimer *timer;
}
@end
@implementation ZQCountDownBtn
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}
-(void)config{
    num = 60;
    [self setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.backgroundColor = [UIColor orangeColor];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    [self addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void)startCountDown{
    [self startTimer];
    [self setTitleColor:HEX(@"999999", 1) forState:UIControlStateNormal];
}
-(void)clickBtn{
    if ([self.titleLabel.text isEqualToString:NSLocalizedString(@"获取验证码", nil)] || [self.titleLabel.text isEqualToString:NSLocalizedString(@"重新获取",nil)]) {
        if (self.clickBlock) {
            self.clickBlock();
        }
       
    }
}
-(void)startTimer{
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [timer fire];
    }
}
-(void)onTimer{
    num --;
     [self setTitle:[NSString stringWithFormat:@"%dS",num] forState:UIControlStateNormal];
    if (num == 0) {
        [self setTitle:NSLocalizedString(@"重新获取", nil) forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:THEME_COLOR_Alpha(1) forState:UIControlStateNormal];
        num = 60;
        [self stopTimer];
    }
}
-(void)stopTimer{
    [timer invalidate];
    timer = nil;
}
-(void)dealloc{
    [timer invalidate];
    timer = nil;
}
@end
