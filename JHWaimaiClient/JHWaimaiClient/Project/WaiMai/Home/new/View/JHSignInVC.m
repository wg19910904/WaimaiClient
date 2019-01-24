//
//  JHSignInVC.m
//  JHWaimaiClient
//
//  Created by xixixi on 2018/12/24.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHSignInVC.h"
#import "PresentAnimationTransition.h"

@interface JHSignInVC ()<UIViewControllerTransitioningDelegate>
@property(nonatomic,strong)UIControl *bgControl;
@property(nonatomic,strong)UIImageView *centerIV;
@property(nonatomic,strong)UILabel *titleL;
@property(nonatomic,strong)UILabel *contentL;
@property(nonatomic,strong)UIButton *signInBtn;
@property(nonatomic,strong)UIButton *closeBtn;
@end

@implementation JHSignInVC

-(instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor clearColor];
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    self.bgControl = [UIControl new];
    [self.view addSubview:_bgControl];
    [_bgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
    //
    self.centerIV = [UIImageView new];
    [_bgControl addSubview:_centerIV];
    //
    [_centerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = -20;
        make.centerX.offset = 0;
        make.width.offset = 270;
        make.height.offset = 202;
    }];
    _centerIV.image = IMAGE(@"bg_qdtanc");
    _centerIV.userInteractionEnabled = YES;
    //
    self.titleL = [UILabel new];
    [_centerIV addSubview:_titleL];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 109;;
        make.left.right.offset = 0;
        make.height.offset = 25;
    }];
    _titleL.text = NSLocalizedString(@"签到赢奖励", nil);
    _titleL.font = FONT(18);
    _titleL.textAlignment = NSTextAlignmentCenter;
    //
    self.contentL = [UILabel new];
    [_centerIV addSubview:_contentL];
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.equalTo(_titleL.mas_bottom).offset = 7;
    }];
    _contentL.text = @"已经签到    天，再签    天必得红包";
    _contentL.font = FONT(12);
    _contentL.textAlignment = NSTextAlignmentCenter;
    //
    self.signInBtn = [UIButton new];
    [_centerIV  addSubview:_signInBtn];
    [_signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.centerY.equalTo(_centerIV.mas_bottom);
        make.width.offset = 153;
        make.height.offset = 48;
    }];
    _signInBtn.backgroundColor = HEX(@"FF725C", 1.0);
    [_signInBtn setTitle:NSLocalizedString(@"去签到", nil) forState:(UIControlStateNormal)];
    [_signInBtn setTitleColor:HEX(@"ffffff", 1.0) forState:(UIControlStateNormal)];
    _signInBtn.titleLabel.font = FONT(16);
    [_signInBtn addTarget:self action:@selector(clickSignInBtn) forControlEvents:(UIControlEventTouchUpInside)];
    //
    self.closeBtn = [UIButton new];
    [_bgControl addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset = 28;
        make.centerX.offset = 0;
        make.top.equalTo(_centerIV.mas_bottom).offset = 48;
    }];
    [_closeBtn setBackgroundImage:IMAGE(@"qiandao_btn_close") forState:(UIControlStateNormal)];
    [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)clickSignInBtn{
    
    
}

- (void)clickCloseBtn{
    [self dismissViewControllerAnimated:NO completion:nil];
}

///
#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
    
    return  [[PresentAnimationTransition alloc] initWithTransitionType:YFPresentTransitionTypeShowHongBao];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return  [[PresentAnimationTransition alloc] initWithTransitionType:YFPresentTransitionTypeDismissHongBao];
    
}

@end
