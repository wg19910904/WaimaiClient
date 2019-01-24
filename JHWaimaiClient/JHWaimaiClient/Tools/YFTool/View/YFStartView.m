//
//  YFStartView.m
//  PresentAnimationTest
//
//  Created by ios_yangfei on 17/4/19.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import "YFStartView.h"

@implementation YFStartView

-(instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    
    _fullStarNum = 5;
    _interSpace = 5;
    _starType = YFStarViewFloat;
    _backStar = @"Star-defualt";
    _topStar = @"Star-pre";
    _currentStarScore = 0.0;
    _imgSize = CGSizeMake(20, 20);
    [self initGesture];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y , (_imgSize.width + _interSpace) * _fullStarNum, _imgSize.height);
    self.backgroundColor = [UIColor whiteColor];
}

-(void)initGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChooseStarNum:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panChooseStarNum:)];
    [self addGestureRecognizer:pan];
    
}

#pragma mark ======draw star=======
- (void)drawRect:(CGRect)rect {
    
    UIImage *topStarImg = [UIImage imageNamed:_topStar];
    UIImage *backStarImg = [UIImage imageNamed:_backStar];
    
    for (NSInteger i=0; i< _fullStarNum; i++) {
        CGPoint point = [self getStarPointWith:i];
        [backStarImg drawInRect:CGRectMake(point.x, point.y, _imgSize.width, _imgSize.height)];
    }
    
    switch (_starType) {
        case YFStarViewFull:
        {
            for (NSInteger i=0; i< (int)_currentStarScore; i++) {
                CGPoint point = [self getStarPointWith:i];
                [topStarImg drawInRect:CGRectMake(point.x, point.y, _imgSize.width, _imgSize.height)];
            }
        }
            break;
        default:
        {
            for (NSInteger i=0; i< (int)_currentStarScore; i++) {
                CGPoint point = [self getStarPointWith:i];
                [topStarImg drawInRect:CGRectMake(point.x, point.y, _imgSize.width, _imgSize.height)];
            }
            float f = _currentStarScore - (int)_currentStarScore;
            if (f == 0) break;
            CGPoint point = [self getStarPointWith:(int)_currentStarScore];
            UIImage *img = [self clipImageWith:f img:topStarImg];
            [img drawInRect:CGRectMake(point.x, point.y, _imgSize.width * f, _imgSize.height)];
        }
            break;
    }
    
}

// 获取每一个星星的起始位置
-(CGPoint)getStarPointWith:(NSInteger)starNum{
    return CGPointMake((_imgSize.width + _interSpace) * starNum, 0);
}

/**
 裁剪不完整的星星
 
 @param prencet 星星的百分比
 @param clipImage 需要裁剪的图片
 @return 裁剪后的图片
 */
- (UIImage *)clipImageWith:(float)prencet img:(UIImage *)clipImage
{
    
    CGImageRef cgimg = CGImageCreateWithImageInRect(clipImage.CGImage, CGRectMake(0, 0, clipImage.size.width * prencet * clipImage.scale , clipImage.size.height * clipImage.scale  ));
    UIImage *destImg = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return destImg;
    
}

#pragma mark ======Functions =======
-(void)tapChooseStarNum:(UITapGestureRecognizer *)tap{
    
    CGPoint point=[tap locationInView:tap.view];
    [self containtStarNumWith:point];
    
}

-(void)panChooseStarNum:(UIPanGestureRecognizer *)pan{
    
    CGPoint point=[pan locationInView:pan.view];
    BOOL isIn = CGRectContainsPoint(self.bounds, point);
    if (isIn)  [self containtStarNumWith:point];
    
}

// 获取手势点包含几个星星
-(void)containtStarNumWith:(CGPoint)point{
    float num = (int)(point.x /( _imgSize.width + _interSpace));
    float x = point.x - num * ( _imgSize.width + _interSpace);
    if (x > _imgSize.width) {
        num += 1;
    }else{
        num += x/_imgSize.width;
    }
    self.currentStarScore = num;
}

#pragma mark ======Setter=======
-(void)setCurrentStarScore:(float)currentStarScore{
    
    switch (_starType) {
        case YFStarViewFull:
        {
            float f = currentStarScore - (int)currentStarScore;
            _currentStarScore = (int)currentStarScore;
            if (f > 0.5){
                _currentStarScore +=  1;
            }
            
        }
            break;
        case YFStarViewHalf:
        {
            float f = currentStarScore - (int)currentStarScore;
            _currentStarScore = (int)currentStarScore;
            if (f > 0.2 && f < 0.7) {
                _currentStarScore += 0.5;
            }else if (f >= 0.7){
                _currentStarScore +=  1;
            }
            
        }
            break;
        default:
            _currentStarScore = currentStarScore;
            break;
    }
    
    if (_currentStarScore < 0) {
        _currentStarScore = 0;
    }else if (_currentStarScore > _fullStarNum){
        _currentStarScore = _fullStarNum;
    }
    
    [self setNeedsDisplay];
}

-(void)setImgSize:(CGSize)imgSize{
    _imgSize = imgSize;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y , (_imgSize.width + _interSpace) * _fullStarNum, _imgSize.height);
}

-(void)setInterSpace:(float)interSpace{
    _interSpace = interSpace;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y , (_imgSize.width + _interSpace) * _fullStarNum, _imgSize.height);
}

-(void)setFullStarNum:(int)fullStarNum{
    _fullStarNum = fullStarNum;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y , (_imgSize.width + _interSpace) * _fullStarNum, _imgSize.height);
    [self setNeedsDisplay];
}

@end
