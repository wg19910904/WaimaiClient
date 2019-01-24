//
//  YFSegmentedControl.m
//  PresentAnimationTest
//
//  Created by ios_yangfei on 17/4/20.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#define btn_tag 200
#define badge_tag 300

#import "YFSegmentedControl.h"
#import "YFTypeBtn.h"

@interface YFSegmentedControl ()
@property(nonatomic,weak)UIView *indicatorView;
@property(nonatomic,weak)YFTypeBtn *selectedBtn;
@end


@implementation YFSegmentedControl

-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleImgArr{
    if (self = [super initWithFrame:frame]) {
        self.titleImgArr = titleImgArr;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setUpView{
    _showIndicator = YES;
    if (_titleImgArr.count == 0) {  return;  }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    _normalColor = _normalColor == nil ? [UIColor whiteColor] : _normalColor;
    _selectedColor = _selectedColor == nil ? [UIColor greenColor] : _selectedColor;
    
    CGFloat btnW = self.frame.size.width / _titleImgArr.count;
    CGFloat btnH = self.frame.size.height - 2;
    
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, btnH, btnW, 2)];
    lineView.backgroundColor = self.selectedColor;
    self.indicatorView = lineView;
    [self addSubview:lineView];
    
    for (NSInteger i=0; i<_titleImgArr.count; i++) {
        NSDictionary *dic = _titleImgArr[i];
        YFTypeBtn *btn = [[YFTypeBtn alloc] initWithFrame:CGRectMake(btnW*i, 0, btnW, btnH)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = btn_tag + i ;
        if ([dic.allKeys containsObject:@"title"]) {
            [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
            [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
            [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
            btn.btnType = TitleCenter;
        }
        if ([dic.allKeys containsObject:@"icon"]) {
            [btn setImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
            btn.btnType = AllCenterImgageFront;
        }
        
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i == 0) {
            [self clickBtn:btn];
        }
        
        UILabel *badgeLab = [UILabel new];
        [btn.titleLabel addSubview:badgeLab];
        CGFloat labW = 12;
        [badgeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset= 0;//labW/2;
            make.top.offset= -labW/2;
            make.width.offset=labW;
            make.height.offset=12;
        }];
        badgeLab.layer.cornerRadius=labW/2;
        badgeLab.clipsToBounds=YES;
        badgeLab.backgroundColor = [UIColor redColor];
        badgeLab.font = FONT(9);
        badgeLab.textColor = [UIColor whiteColor];
        badgeLab.textAlignment = NSTextAlignmentCenter;
        badgeLab.tag = badge_tag + i;
        badgeLab.hidden = YES;
        
    }

}

#pragma mark ======Functions=======
-(void)clickBtn:(YFTypeBtn *)btn{
    if (btn == self.selectedBtn) {
        return;
    }
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedSegmentIndex = btn.tag - btn_tag;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (self.showIndicator) {
        CGFloat centerX = btn.centerX;
        [UIView animateWithDuration:0.25 animations:^{
            self.indicatorView.centerX = centerX;
        }];
        [self layoutIfNeeded];
    }else{
         btn.backgroundColor = btn.selected ? self.selectedColor : self.normalColor;
         self.selectedBtn.backgroundColor =  self.normalColor;
    }
    self.selectedBtn = btn;
}

#pragma mark ======Setter=======
-(void)setIndicatorWidth:(CGFloat )indicatorWidth{
    _indicatorWidth = indicatorWidth;
    self.indicatorView.width = indicatorWidth;
    CGFloat centerX = self.selectedBtn.centerX;
    self.indicatorView.centerX = centerX;
}

-(void)setTitleImgArr:(NSArray *)titleImgArr{
    _titleImgArr = titleImgArr;
    [self setUpView];
}

-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    for (NSInteger i=0; i<_titleImgArr.count; i++) {
        YFTypeBtn *btn = [self viewWithTag:btn_tag + i];
        btn.layer.borderColor = borderColor.CGColor;
        btn.layer.borderWidth = 1.0;
    }
}

-(void)setShowIndicator:(BOOL)showIndicator{
    _showIndicator = showIndicator;
    self.indicatorView.hidden = !showIndicator;
    if (showIndicator) {
        self.selectedBtn.backgroundColor = [UIColor whiteColor];
    }
}

-(void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    for (NSInteger i=0; i<_titleImgArr.count; i++) {
        YFTypeBtn *btn = [self viewWithTag:btn_tag + i];
        btn.titleLabel.font = textFont;
    }
}

-(void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    if (_showIndicator) {
        for (NSInteger i=0; i<_titleImgArr.count; i++) {
            YFTypeBtn *btn = [self viewWithTag:btn_tag + i];
            [btn setTitleColor:normalColor forState:UIControlStateNormal];
            if (!_showIndicator) {
                btn.backgroundColor = normalColor;
            }
            
        }
    }
}

-(void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
    for (NSInteger i=0; i<_titleImgArr.count; i++) {
        YFTypeBtn *btn = [self viewWithTag:btn_tag + i];
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    }
    
    if (!_showIndicator) {
        self.selectedBtn.backgroundColor = selectedColor;
    }else{
        self.indicatorView.backgroundColor = selectedColor;
    }
}

-(void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex{
    if (selectedSegmentIndex == _selectedSegmentIndex) {
        return;
    }
    _selectedSegmentIndex = selectedSegmentIndex;
    [self clickBtn:[self viewWithTag:btn_tag + selectedSegmentIndex]];
}

-(void)setBadgeArr:(NSArray *)badgeArr{
    _badgeArr = badgeArr;
    for (NSInteger i=0; i<self.titleImgArr.count; i++) {
        UILabel *badge_lab = [self viewWithTag:badge_tag + i];
        if ([badgeArr[i] intValue] == 0) {
            badge_lab.hidden = YES;
            continue;
        }else{
            badge_lab.hidden = NO;
        }
        NSString *str = badgeArr[i];
        str  = [str intValue] > 99 ? @"99+" : str;
        badge_lab.text = str;
        CGFloat w = getSize(str, 12, 10).width + 5;
        [badge_lab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset=w;
        }];
    }
}

@end
