//
//  YFSteper.m
//  JHMainTain
//
//  Created by jianghu3 on 16/2/27.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "YFSteper.h"
#import "UIView+Extension.h"
#import "Masonry.h"

@interface YFSteper()
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)UIButton *subBtn;
@end

@implementation YFSteper

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIButton *subBtn=[UIButton new];
    [self addSubview:subBtn];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.centerY.offset=0;
        make.width.equalTo(self.mas_height);
        make.height.equalTo(self.mas_height); 
    }];
    [subBtn addTarget:self action:@selector(onClickCut) forControlEvents:UIControlEventTouchUpInside];
    [subBtn setImage:[UIImage imageNamed:@"star_gray"] forState:UIControlStateNormal];
    [subBtn setImage:[UIImage imageNamed:@"star_gray"] forState:UIControlStateSelected];
    subBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 4, 8);
    self.subBtn=subBtn;
    
    UIButton *addBtn=[UIButton new];
    [self addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=0;
        make.centerY.offset=0;
        make.width.equalTo(self.mas_height);
        make.height.equalTo(self.mas_height);
    }];
    [addBtn addTarget:self action:@selector(onClickAdd) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateSelected];
    addBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 0);
    self.addBtn=addBtn;
    
    UILabel *countLab=[UILabel new];
    [self addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn.mas_left).offset=8;
        make.left.equalTo(subBtn.mas_right).offset=-8;
        make.centerY.offset=0;
        make.height.equalTo(self.mas_height);
    }];
    countLab.lineBreakMode = NSLineBreakByTruncatingTail;
    countLab.textAlignment=NSTextAlignmentCenter;
    countLab.textColor= [UIColor blackColor];
    countLab.font=[UIFont systemFontOfSize:10];
    self.countLab=countLab;
    countLab.alpha = 0.0;
 
}

#pragma mark ======减少数量=======
-(void)onClickCut{
    int count = _currentCount - 1;
    if(count >= self.minCount){
        if (count == 0 ) {
             self.currentCount = count;
            [self startAniamtion:NO];
        }else{
            self.currentCount = count;
        }
        if ([self.delegate respondsToSelector:@selector(subCount:)]) {
            [self.delegate subCount:count];
        }
    }
}

#pragma mark ======增减数量=======
-(void)onClickAdd{
    int count=[self.countLab.text intValue];
    count++;

    if(count <= self.maxCount){
        self.currentCount = count;
        if (count == 1) {
             [self startAniamtion:YES];
        }
        if ([self.delegate respondsToSelector:@selector(addCount)]) {
            [self.delegate addCount];
        }
    }
   
}

#pragma mark ======动画处理=======
-(void)startAniamtion:(BOOL)show{
    
    CALayer *layer = self.subBtn.imageView.layer;    
    layer.bounds = CGRectMake(0, 0, self.subBtn.imageView.image.size.width, self.subBtn.imageView.image.size.height);

    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    
    CGFloat countLabAlpha = 0;
    self.subBtn.hidden = NO;
    if (show) {
        
        moveAnimation.fromValue = @(self.addBtn.frame.origin.x);
        moveAnimation.toValue = @(self.subBtn.frame.origin.x);
        animation.toValue = [NSNumber numberWithFloat:2 * M_PI]; // 终止角度
        countLabAlpha = 1.0;
    }else{
        moveAnimation.fromValue = @(self.subBtn.frame.origin.x);
        moveAnimation.toValue = @(self.addBtn.frame.origin.x);
        animation.toValue = [NSNumber numberWithFloat: -2 * M_PI]; // 终止角度
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.countLab.alpha = countLabAlpha;
    }];
    
    CAAnimationGroup *animationArr=[CAAnimationGroup animation];
    animationArr.animations=@[animation,moveAnimation];
    animationArr.duration = 0.3;
//    animationArr.removedOnCompletion = NO;
//    animationArr.fillMode = kCAFillModeForwards;
    
    [layer addAnimation:animationArr forKey:@"group"];
    [self performSelector:@selector(showSubBtn) withObject:nil afterDelay:0.3];
}

-(void)showSubBtn{
     self.subBtn.hidden = _currentCount == 0 ? YES : NO;
}

#pragma mark ======Setter=======
-(void)setMaxCount:(int)maxCount{
    _maxCount = maxCount;
    if (maxCount == 0 || maxCount == _currentCount) {
        [self.addBtn setImage:IMAGE(@"btn-num_addCart_close") forState:UIControlStateNormal];
    }else{
        [self.addBtn setImage:IMAGE(self.addBtnImg) forState:UIControlStateNormal];
    }
}

// 当前的值
-(void)setCurrentCount:(int)currentCount{
    _currentCount = currentCount;
    if (currentCount >= self.maxCount)  _currentCount = self.maxCount;
    if (currentCount <= self.minCount)  _currentCount = self.minCount;
    
    if (currentCount >= self.maxCount) {
        [self.addBtn setImage:IMAGE(@"btn-num_addCart_close") forState:UIControlStateNormal];
    }else{
        [self.addBtn setImage:IMAGE(self.addBtnImg) forState:UIControlStateNormal];
    }
    self.countLab.alpha = _currentCount == 0 ? 0.0 : 1.0;
    self.subBtn.hidden = _currentCount == 0 ? YES : NO;
    
    self.backgroundColor = _currentCount == 0 ? HEX(@"ffffff", 0.0) : HEX(@"ffffff", 1.0);
    
    self.countLab.text=[NSString stringWithFormat:@"%d",_currentCount];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(countNumChange:)]) {
        [self.delegate countNumChange:_currentCount];
    }
}

// 设置font
-(void)setCountFont:(CGFloat)countFont{
    _countFont=countFont;
    self.countLab.font=[UIFont systemFontOfSize:countFont];
}

-(void)setSubBtnImg:(NSString *)subBtnImg{
    _subBtnImg = subBtnImg;
    [self.subBtn setImage:[UIImage imageNamed:subBtnImg] forState:UIControlStateNormal];
}

-(void)setAddBtnImg:(NSString *)addBtnImg{
    _addBtnImg = addBtnImg;
    [self.addBtn setImage:[UIImage imageNamed:addBtnImg] forState:UIControlStateNormal];
}

@end
