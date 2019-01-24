//
//  YFDisplayImagesVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/9.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "YFDisplayImagesVC.h"
#import "YFBannerPlayer.h"

@interface YFDisplayImagesVC ()<UIViewControllerTransitioningDelegate>
@property(nonatomic,weak)YFBannerPlayer *imgPlayer;
@end

@implementation YFDisplayImagesVC

-(instancetype)init{
    if (self = [super init]) {
        self.transitioningDelegate = self;
    }
    return self;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView{
    self.view.backgroundColor = [UIColor blackColor];
    YFBannerPlayer *imgPlayer = [YFBannerPlayer initWithUrlArray:self.imgsArr withFrame:FRAME(10, (HEIGHT - (WIDTH - 20))/2.0, WIDTH - 20, WIDTH - 20) withTimeInterval:0];
    [imgPlayer invalidateTimer];
    imgPlayer.placeHolderImage = @"cate_img_default";
    imgPlayer.hidden = YES;
    self.imgPlayer = imgPlayer;
    imgPlayer.currentIndex = self.index;
    [self.view addSubview:imgPlayer];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.imgPlayer.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.imgPlayer.hidden = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.clickDismiss) {
        self.clickDismiss (self.imgPlayer.currentIndex);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
    self.presentAnimation.type = YFPresentTransitionTypeShowImgs;
    return  self.presentAnimation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    self.presentAnimation.type = YFPresentTransitionTypeHiddenImgs;
    return self.presentAnimation;
    
}

-(PresentAnimationTransition *)presentAnimation{
    if (_presentAnimation==nil) {
        _presentAnimation=[[PresentAnimationTransition alloc] init];
    }
    return _presentAnimation;
}

@end
