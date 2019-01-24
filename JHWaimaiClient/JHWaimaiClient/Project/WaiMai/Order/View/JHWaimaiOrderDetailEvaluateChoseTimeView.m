//
//  JHWaimaiOrderDetailEvaluateChoseTimeView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailEvaluateChoseTimeView.h"
@interface JHWaimaiOrderDetailEvaluateChoseTimeView()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSInteger tag;
}
@property(nonatomic,strong)UIView *centerView;//中间展示的View
@property(nonatomic,strong)UILabel *timeL;//送达的时间
@property(nonatomic,strong)UIButton *sureBtn;//确定的按钮
@property(nonatomic,strong)UIPickerView *myPickView;//中间选择时间的view
@property(nonatomic,copy)NSString *timeStr;
@end
@implementation JHWaimaiOrderDetailEvaluateChoseTimeView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}
//基础配置
-(void)config{
    self.backgroundColor = HEX(@"000000", 0.4);
    self.alpha = 0;
    [self addTarget:self action:@selector(clickRemove) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
    [self centerView];
}
-(void)clickRemove{
    [self removeAnimaiton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });

}
#pragma mark - 中间的view
-(UIView *)centerView{
    if (!_centerView) {
        _centerView = [UIView new];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.cornerRadius = 4;
        _centerView.layer.masksToBounds = YES;
        [self addSubview:_centerView];
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.offset = 335*SCALE;
            make.height.offset = 240*SCALE;
        }];
        [self timeL];
        [self sureBtn];
        [self myPickView];
        [self showAnimation];
    }
    return _centerView;
}
#pragma mark - 展示送达时间的
-(UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = HEX(@"333333", 1);
        _timeL.font = FONT(16*SCALE);
        [_centerView addSubview:_timeL];
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20*SCALE;
            make.top.offset = 17*SCALE;
            make.height.offset = 18*SCALE;
        }];
    }
    return _timeL;
}
#pragma mark - 确定的按钮
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]init];
        [_sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:THEME_COLOR_Alpha(1) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = FONT(16*SCALE);
        [_centerView addSubview:_sureBtn];
        [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -30*SCALE;
            make.width.offset = 50*SCALE;
            make.height.offset = 30*SCALE;
            make.bottom.offset = -20*SCALE;
        }];
    }
    return _sureBtn;
}
-(void)setTimeArr:(NSArray *)timeArr{
    _timeArr = timeArr;
    _timeL.text = _timeArr[0][@"date"];
}
#pragma mark - 点击确定的按钮
-(void)clickSureBtn{
    if (self.myBlock) {
        self.myBlock(_timeStr,tag);
    }
    [self clickRemove];
}
#pragma mark - 中间显示时间的
-(UIPickerView *)myPickView{
    if (!_myPickView) {
        _myPickView = [[UIPickerView alloc]init];
        _myPickView.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _myPickView.delegate = self;
        _myPickView.dataSource = self;
        _myPickView.showsSelectionIndicator = YES;
        [_centerView addSubview:_myPickView];
        [_myPickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_centerView.mas_centerX);
            make.centerY.mas_equalTo(_centerView.mas_centerY);
            make.height.offset = 120*SCALE;
            make.width.offset = 100*SCALE;
        }];
    }
    return _myPickView;
}
#pragma mark - 这是pickerView的代理和数据源方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _timeArr.count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40*SCALE;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 100*SCALE;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    CGRect rect1 = [pickerView.subviews objectAtIndex:1].frame;
    rect1.origin.x = 0;
    rect1.size.width = pickerView.frame.size.width ;
    [[pickerView.subviews objectAtIndex:1] setFrame:rect1];
    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:THEME_COLOR_Alpha(1)];
    CGRect rect2 = [pickerView.subviews objectAtIndex:2].frame;
    rect2.origin.x = 0;
    rect2.size.width = pickerView.frame.size.width ;
    [[pickerView.subviews objectAtIndex:2] setFrame:rect2];
    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:THEME_COLOR_Alpha(1)];
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100*SCALE, 30*SCALE)];
    myView.text = _timeArr[row][@"minute"];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:14];
    myView.backgroundColor = [UIColor clearColor];
    return myView;

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%ld",row);
    tag = row;
     _timeL.text = _timeArr[row][@"date"];
    _timeStr = [NSString stringWithFormat:NSLocalizedString(@"%@分钟(%@送达)", nil),_timeArr[row][@"minute"],_timeArr[row][@"date"]];
}
#pragma mark - 展示
-(void)showView{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}
#pragma mark - 出现的动画
-(void)showAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.25;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(0),@(1)];
    [_centerView.layer addAnimation:animation forKey:nil];
}
#pragma mark - 消失的动画
-(void)removeAnimaiton{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.5;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(1),@(1.1),@(0)];
    [_centerView.layer addAnimation:animation forKey:nil];
}
@end
