//
//  YFTimerView.m
//  Timer_Demo
//
//  Created by ios_yangfei on 2018/12/15.
//  Copyright © 2018年 jianghu3. All rights reserved.
//

#import "YFTimerView.h"

@interface YFTimerView ()

@property(nonatomic,weak)UILabel *hh_lab;
@property(nonatomic,weak)UILabel *mm_lab;
@property(nonatomic,weak)UILabel *ss_lab;
@property(nonatomic,weak)UILabel *ms_lab;
@property(nonatomic,weak)UILabel *mh_lab_1;
@property(nonatomic,weak)UILabel *mh_lab_2;
@property(nonatomic,weak)UILabel *mh_lab_3;

@end


@implementation YFTimerView

-(instancetype)initWithConfigParams:(NSDictionary *)params{
    if (self = [super init]) {
        [self setUpView];

        self.time_font = params[@"time_font"];
        self.time_color = params[@"time_color"];
        self.ms_color = params[@"ms_color"];
        self.time_background_color = params[@"time_background_color"];
        self.single_w = [params[@"single_w"] floatValue];
        self.formatter = params[@"formatter"];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    UILabel *hh_lab = [UILabel new];
    hh_lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:hh_lab];
    
    UILabel *mm_lab = [UILabel new];
    mm_lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:mm_lab];
    
    UILabel *ss_lab = [UILabel new];
    ss_lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:ss_lab];
    
    UILabel *ms_lab = [UILabel new];
    ms_lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:ms_lab];
    
    UILabel *mh_lab_1 = [UILabel new];
    mh_lab_1.textAlignment = NSTextAlignmentCenter;
    mh_lab_1.text = @":";
    [self addSubview:mh_lab_1];
    
    UILabel *mh_lab_2 = [UILabel new];
    mh_lab_2.textAlignment = NSTextAlignmentCenter;
    mh_lab_2.text = @":";
    [self addSubview:mh_lab_2];
    
    UILabel *mh_lab_3 = [UILabel new];
    mh_lab_3.textAlignment = NSTextAlignmentCenter;
    mh_lab_3.text = @":";
    [self addSubview:mh_lab_3];
    
    self.hh_lab = hh_lab;
    self.mm_lab = mm_lab;
    self.ss_lab = ss_lab;
    self.ms_lab = ms_lab;
    
    hh_lab.layer.cornerRadius=2;
    hh_lab.clipsToBounds=YES;
    
    mm_lab.layer.cornerRadius=2;
    mm_lab.clipsToBounds=YES;
    
    ss_lab.layer.cornerRadius=2;
    ss_lab.clipsToBounds=YES;
    
    ms_lab.layer.cornerRadius=2;
    ms_lab.clipsToBounds=YES;
    
    self.mh_lab_1 = mh_lab_1;
    self.mh_lab_2 = mh_lab_2;
    self.mh_lab_3 = mh_lab_3;
    
}

#pragma mark ====== YFTimerDelegate =======
-(void)toDoThingsWhenTimeCome:(NSTimeInterval)interval{
    
    CGFloat mul = interval < 1 ? 1000 : 1;
    
    NSTimeInterval dateline = self.dateline * mul - [[NSDate date] timeIntervalSince1970] * mul;

//    NSLog(@"%f",dateline);
    
    int hour = (int)(dateline/3600/mul);
    int min = (int)(dateline-3600*hour * mul)/60/mul;
    int sec = (int)(dateline-3600*hour * mul - 60 * min * mul)/mul;
    int ms = (int)(dateline- 3600*hour * mul - 60 * min  * mul - mul * sec )/100;
    
    hour = MAX(MIN(hour, 59), 0);
    min = MAX(MIN(min, 59), 0);
    sec = MAX(MIN(sec, 59), 0);
    ms = MAX(MIN(ms, 59), 0);

    self.hh_lab.text = [NSString stringWithFormat:@"%d",hour];
    self.mm_lab.text = [NSString stringWithFormat:@"%02d",min];
    self.ss_lab.text = [NSString stringWithFormat:@"%02d",sec];
    self.ms_lab.text = [NSString stringWithFormat:@"%d",ms];
    
}

#pragma mark ====== Setter =======

-(void)setFormatter:(NSString *)formatter{
    _formatter = formatter;
    
    // 默认 mm:ss
    
    self.hh_lab.hidden = ![formatter hasPrefix:@"HH"];
    self.mh_lab_1.hidden = ![formatter hasPrefix:@"HH"];
    
    self.ms_lab.hidden = ![formatter hasSuffix:@"SSS"];
    self.mh_lab_3.hidden = ![formatter hasSuffix:@"SSS"];
    
    
    [self.hh_lab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        [formatter hasPrefix:@"HH"] ? make.width.offset(_single_w) : make.width.offset(0);
        make.bottom.offset(0);
    }];
    
    [self.mh_lab_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hh_lab.mas_right);
        make.top.offset(0);
        [formatter hasPrefix:@"HH"] ? make.width.offset(_single_w/3): make.width.offset(0);
        make.bottom.offset(0);
    }];
    
    [self.mm_lab mas_remakeConstraints:^(MASConstraintMaker *make) {
        [formatter hasPrefix:@"HH"] ? make.left.equalTo(self.mh_lab_1.mas_right) : make.left.offset(0);
        make.top.offset(0);
        make.width.offset(_single_w);
        make.bottom.offset(0);
    }];
    
    [self.mh_lab_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mm_lab.mas_right);
        make.top.offset(0);
        make.width.offset(_single_w/3);
        make.bottom.offset(0);
    }];
    
    [self.ss_lab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mh_lab_2.mas_right);
        make.top.offset(0);
        make.width.offset(_single_w);
        if (![formatter hasSuffix:@"SSS"]) make.right.offset(0);
        make.bottom.offset(0);
    }];
    
    [self.mh_lab_3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ss_lab.mas_right);
        make.top.offset(0);
        [formatter hasSuffix:@"SSS"] ? make.width.offset(_single_w/3) : make.width.offset(0);
        make.bottom.offset(0);
    }];
    
    [self.ms_lab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mh_lab_3.mas_right);
        make.top.offset(0);
        [formatter hasSuffix:@"SSS"] ? make.width.offset(_single_w) : make.width.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];

}

-(void)setTime_font:(UIFont *)time_font{
    _time_font = time_font;
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            ((UILabel *)view).font = time_font;
        }
    }
}

-(void)setTime_color:(UIColor *)time_color{
    _time_color = time_color;
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            ((UILabel *)view).textColor = time_color;
        }
    }
}

-(void)setMs_color:(UIColor *)ms_color{
    _ms_color = ms_color;
    _ms_lab.textColor = ms_color;
}

-(void)setTime_background_color:(UIColor *)time_background_color{
    
    _time_background_color = time_background_color;
    self.hh_lab.backgroundColor = time_background_color;
    self.mm_lab.backgroundColor = time_background_color;
    self.ss_lab.backgroundColor = time_background_color;
    self.ms_lab.backgroundColor = time_background_color;
}

-(void)setSingle_w:(CGFloat)single_w{
    _single_w = single_w;
    [self setFormatter:self.formatter];
}
@end
