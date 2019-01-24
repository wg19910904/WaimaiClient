//
//  YFTabBarItem.m
//  YFTabar
//
//  Created by jianghu3 on 16/4/20.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "YFTabBarItem.h"
#import "AppDelegate.h"
#define normalColor    [(AppDelegate *)[UIApplication sharedApplication].delegate tabbarConfig].normalColor
#define selectedColor [(AppDelegate *)[UIApplication sharedApplication].delegate tabbarConfig].selectedColor

@interface YFTabBarItem ()
@property(nonatomic,copy)NSString *selectedImage;
@property(nonatomic,copy)NSString *normalImage;
@property(nonatomic,weak)UIImageView *imageView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIImageView *backImageView;
@property(nonatomic,weak)UIImageView *isNewImageView;
@property(nonatomic,strong)UILabel *badgeLab;
@end
@implementation YFTabBarItem

-(YFTabBarItem *)setUpWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage title:(NSString *)title tag:(NSInteger)tag{

    if (self == [super initWithFrame:frame]) {
        self.tag = tag;
        self.selectedImage=selectedImage;
        self.normalImage=normalImage;

        UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backImage.image=[UIImage imageNamed:@"tab_clickbg"];
        [self addSubview:backImage];
        backImage.hidden=YES;
        self.backImageView=backImage;
        
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-11, 5, 22, 22)];
        if ([normalImage hasPrefix:@"http"]) {
            [image sd_setImageWithURL:[NSURL URLWithString:normalImage]];
        }else{
            image.image=[UIImage imageNamed:normalImage];
        }
        [self addSubview:image];
        self.imageView=image;
        
        // newImgView
        UIImageView *image2=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2.0,6, 24, 22)];
        image2.contentMode=UIViewContentModeScaleAspectFit;
        //    image2.image=[UIImage sd_animatedGIFNamed:@"new"];
        [image addSubview:image2];
        self.isNewImageView=image2;
        self.isNewImageView.hidden=YES;
        
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-18, frame.size.width, 15)];
        titleLab.text=title;
        titleLab.font=[UIFont systemFontOfSize:12];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.textColor=normalColor;
        [self addSubview:titleLab];
        self.titleLab=titleLab;

    }
    return self;
}

-(void)setSelected:(BOOL)selected{
    self.isNewImageView.hidden = YES;
    _selected = selected;
    if (selected) {
        if ([self.selectedImage hasPrefix:@"http"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.selectedImage]];
        }else{
            self.imageView.image = [UIImage imageNamed:self.selectedImage];
        }
        
        self.titleLab.textColor = selectedColor;
        self.backImageView.hidden = NO;
    }else{
        if ([self.normalImage hasPrefix:@"http"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.normalImage]];
        }else{
            self.imageView.image = [UIImage imageNamed:self.normalImage];
        }
        self.titleLab.textColor = normalColor;
        self.backImageView.hidden = YES;
    }
   
    [self showAnimationWithSelected:selected];
    
}

-(void)showAnimationWithSelected:(BOOL)selected{
    if (!self.is_animation)  { return; }
    
    CALayer *layer = self.imageView.layer;

    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
   
    if (selected) {
        scaleAnimation.toValue = @2.0;
        moveAnimation.toValue = @(-20);
    }else{
        scaleAnimation.fromValue = @2.0;
        moveAnimation.fromValue = @(-20);
        
        scaleAnimation.toValue = @1.0;
        moveAnimation.toValue = @(0);
    }
    
    CAAnimationGroup *animationArr=[CAAnimationGroup animation];
    animationArr.animations=@[scaleAnimation,moveAnimation];
    animationArr.removedOnCompletion = NO;
    animationArr.fillMode = kCAFillModeForwards;
    animationArr.duration = 0.4;

    [layer addAnimation:animationArr forKey:@"group"];

}

-(void)setShowNew:(BOOL)showNew{
    self.isNewImageView.hidden = !showNew;
}

-(UILabel *)badgeLab{
    if (_badgeLab == nil) {

        CGSize size = self.imageView.image.size;
        CGFloat x = self.imageView.frame.size.width /2 + size.width/2 - 5 ;
        _badgeLab = [[UILabel alloc] initWithFrame:CGRectMake(x, 2, 15, 15)];
        _badgeLab.backgroundColor = [UIColor redColor];
        _badgeLab.textColor = [UIColor whiteColor];
        _badgeLab.textAlignment = NSTextAlignmentCenter;
        _badgeLab.font = [UIFont systemFontOfSize:10];
        _badgeLab.layer.cornerRadius = 15/2.0;
        _badgeLab.clipsToBounds = YES;
        [self addSubview:_badgeLab];
    }
    return  _badgeLab;
}

-(void)setBadgeColor:(UIColor *)badgeColor{
    _badgeColor = badgeColor;
    self.badgeLab.backgroundColor = badgeColor;
}

-(void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
    if (!badgeValue) {
        self.badgeLab.hidden = YES;
    }else{
        self.badgeLab.text = badgeValue;
    }
}
@end
