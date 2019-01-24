
//
//  YFSlider.m
//  JHMainTain
//
//  Created by jianghu3 on 16/3/5.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "YFSlider.h"

@interface YFSlider()
@property(nonatomic,assign)float thumbH;
@property(nonatomic,strong)UIImageView *bgImgView;
@property(nonatomic,weak)UILabel *valueLab;
@property (nonatomic, strong) UILabel *lab;
@property(nonatomic,weak)UILabel *minLab;
@property(nonatomic,weak)UILabel *maxLab;
@end

@implementation YFSlider
- (UILabel *)lab
{
    if (_lab == nil) {
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 30, 20)];
        _lab.font=[UIFont systemFontOfSize:12];
        _lab.textColor=[UIColor redColor];
        _lab.textAlignment=NSTextAlignmentCenter;
        [self updatePopoverFrame];
        [self addSubview:_lab];

    }
    return _lab;
}

-(UIImageView *)bgImgView{
    if (_bgImgView==nil) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -10, 30, 25)];
         _bgImgView.image=[UIImage imageNamed:@"ph_slider_tips"];
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        lab.font=[UIFont systemFontOfSize:12];
        lab.textColor=[UIColor whiteColor];
        lab.textAlignment=NSTextAlignmentCenter;
        [_bgImgView addSubview:lab];
        lab.text=[NSString stringWithFormat:@"%d",(int)self.value];
        self.valueLab=lab;
        [self addSubview:_bgImgView];
    }
    return _bgImgView;
}

#pragma mark ======设置小于最小值不能滑动=======
-(void)setValue:(float)value animated:(BOOL)animated{
    
    if (value<=_minNum) {
        [super setValue:_minNum animated:animated];
        value=_minNum;
    }else{
        [super setValue:value animated:animated];
    }
    
    if (self.isShowTop) {
        self.valueLab.text=[NSString stringWithFormat:@"%d",(int)value];
    }else self.lab.text = [NSString stringWithFormat:@"%d",(int)value];
    
    [self updatePopoverFrame];
}

-(void)setMinNum:(float)minNum{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _minNum=minNum;
        self.value=minNum;
    });
}

-(void)setTopY:(float)topY{
    _topY=topY;
    self.bgImgView.y=topY;
}

-(void)setThumbName:(NSString *)thumbName{
    [self setThumbImage:[UIImage imageNamed:thumbName] forState:UIControlStateNormal];
    self.thumbH=[UIImage imageNamed:thumbName].size.height;
}

#pragma mark ======更新位置=======
- (void)updatePopoverFrame
{
    for (UIView *view in self.subviews) {
        if (view.height==self.thumbH) {
            if (self.isShowTop) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.bgImgView.centerX=view.centerX;
                });
            }
            else self.lab.centerX=view.centerX;
        }
    }
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    for (int i=0; i<2; i++) {
        CGFloat x=3;
        if (i==1) {
            x=self.width-40;
        }
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(x, self.height-15, 40, 20)];
        lab.textColor=HEX(@"333333", 1.0);
        lab.font=[UIFont systemFontOfSize:12];
        if (i==1)  {
            lab.textAlignment=NSTextAlignmentRight;
            self.maxLab=lab;
        }else self.minLab=lab;
        [self addSubview:lab];

    }
    
}

-(void)setMinimumValue:(float)minimumValue{
    [super setMinimumValue:minimumValue];
    self.minLab.text=[NSString stringWithFormat:@"%d",(int)minimumValue];
}

-(void)setMaximumValue:(float)maximumValue{
    [super setMaximumValue:maximumValue];
    self.maxLab.text=[NSString stringWithFormat:@"%d",(int)maximumValue];
}

-(void)setTopImgName:(NSString *)topImgName{
    _topImgName=topImgName;
    _bgImgView.image=[UIImage imageNamed:topImgName];
}


@end
