//
//  JHWaimaiShopStoreCloseView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMShopShowStatusView.h"
@interface JHWMShopShowStatusView()
@property(nonatomic,weak)UIImageView *imgView;//展示图片的
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UILabel *titleLab;
@end
@implementation JHWMShopShowStatusView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    self.backgroundColor = HEX(@"000000", 0.5);
    self.alpha = 0;
    
    CGFloat backW = (float)300/375 * WIDTH;
    UIView *backView = [UIView new];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.centerX.offset(0);
        make.width.height.offset(backW) ;
    }];
    backView.layer.cornerRadius=4;
    backView.clipsToBounds=YES;
//    backView.backgroundColor = [UIColor whiteColor];
    self.backView = backView;
    
    UIImageView * imgView = [[UIImageView alloc]init];
    [backView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset( backW * 0.1);
        make.width.height.offset(backW * 0.9 );
    }];
    self.imgView = imgView;
    
//    UIButton *btn = [UIButton new];
//    [backView addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.offset(0);
//        make.bottom.offset(- backW * 0.1);
//        make.width.offset(180);
//        make.height.offset(44);
//    }];
//    [btn setTitle: NSLocalizedString(@"我知道了", NSStringFromClass([self class])) forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor =HEX(@"FA5842", 1.0);
//    btn.layer.cornerRadius=22;
//    btn.clipsToBounds=YES;
//
    UILabel *titleLab = [UILabel new];
    [imgView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-25);
        make.height.offset(20);
    }];
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.font = FONT(14);
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab = titleLab;
    
    UIButton *btn = [UIButton new];
    [backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(0);
        make.width.offset(30);
        make.height.offset(30);
    }];
    [btn setImage:IMAGE(@"btn_close") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView=[UIView new];
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX).offset=0;
        make.top.equalTo(btn.mas_bottom).offset=0;
        make.width.offset=1;
        make.height.offset=80;
    }];
    lineView.backgroundColor=LINE_COLOR;

}
#pragma mark - 点击移除的方法
-(void)clickToRemove{
    [self hiddleAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
   
}

//展示的动画
-(void)showAnimation{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.4;
    animation.values = @[@(0),@(1)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.backView.layer addAnimation:animation forKey:nil];
    
}
-(void)hiddleAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.4;
    animation.values = @[@(1),@(1.2),@(0)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.backView.layer addAnimation:animation forKey:nil];
}

-(void)setShopStatus:(ShopShowStatusViewType)shopStatus{
    _shopStatus = shopStatus;
    switch (shopStatus) {
        case ShopShowStatusViewCloseType:
        {
            self.imgView.image = IMAGE(@"dayang");
            self.titleLab.text =  NSLocalizedString(@"非营业时间,商户休息中", NSStringFromClass([self class]));
        }
            break;
        case ShopShowStatusViewDistanceType:
        {
            self.imgView.image = IMAGE(@"distance_shop");
            self.titleLab.text =  NSLocalizedString(@"已超出配送范围", NSStringFromClass([self class]));
        }
            break;
        default:
            break;
    }
    
    
}

@end
