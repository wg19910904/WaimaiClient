//
//  YFCubeLab.m
//  LayoutTest
//
//  Created by ios_yangfei on 17/3/29.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import "YFCubeLab.h"

@interface YFCubeLab ()<CAAnimationDelegate>
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation YFCubeLab

-(instancetype)init{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLab)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if ( self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLab)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
    
}

-(void)initTimer{
    
    if (self.timer == nil) {
        
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:2.0]
                                             interval:2.0
                                               target:self
                                             selector:@selector(timerActive)
                                             userInfo:nil
                                              repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }
}

-(void)timerActive{
    static int index = 0;
    if (_textArr.count > 1) {
        
        index++ ;
        if (index == _textArr.count) {
            index = 0;
        }
        self.text = _textArr[index];
        
        CATransition *ca = [CATransition animation];
        ca.type = @"cube";
        ca.duration = self.duration;
        ca.delegate = self;
        [self.layer addAnimation:ca forKey:nil];
        
    }else{
        index = 0;
    }
    
}

-(void)setTextArr:(NSArray *)textArr{
    if (textArr.count == 0) {
        return;
    }
    _textArr = textArr;
    [self initTimer];
    [super setText:textArr[0]];
}

-(void)clickLab{
    
    NSInteger index =  [_textArr indexOfObject:self.text];
    if (self.clickIndex) {
        self.clickIndex(index);
    }
}

@end
