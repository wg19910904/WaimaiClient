//
//  JHWMShowChangeGoodsVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/15.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMShowChangeGoodsVC.h"
#import "PresentAnimationTransition.h"

@interface JHWMShowChangeGoodsVC ()<UIViewControllerTransitioningDelegate>

@end

@implementation JHWMShowChangeGoodsVC

-(instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor clearColor];
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

-(void)setChangedGoodsArr:(NSArray *)changedGoodsArr{
    _changedGoodsArr = changedGoodsArr;
    [self setUpView];
}

-(void)setUpView{
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius=4;
    view.clipsToBounds=YES;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.centerY.offset=0;
        make.width.offset=WIDTH * 0.75;
    }];
    
    UILabel *titleLab = [UILabel new];
    [view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.top.offset=15;
        make.height.offset=20;
    }];
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.font = FONT(16);
    titleLab.text = NSLocalizedString(@"以下商品发生了变化", @"JHWMShowChangeGoodsVC");
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    float marginTop = 5;
    for (NSInteger i=0; i<self.changedGoodsArr.count; i++) {
        NSDictionary *dic = self.changedGoodsArr[i];
        UILabel *lab = [UILabel new];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset= 10;
            make.right.offset= -10;
            make.top.equalTo(titleLab.mas_bottom).offset = marginTop;
            make.height.offset=30;
        }];
        lab.textColor = HEX(@"666666", 1.0);
        lab.font = FONT(12);
        lab.numberOfLines = 0;
        NSString *name = [dic[@"spec_id"] isEqualToString:@"0"] ? dic[@"product_name"] : [NSString stringWithFormat:@"%@(%@)",dic[@"product_name"],dic[@"spec_name"]];
        lab.text = [NSString stringWithFormat:@"%@    x%@",name,dic[@"product_number"]];
        if ([dic[@"specification"] length] > 0) {
            lab.text = [NSString stringWithFormat:@"%@    %@",lab.text,dic[@"specification"]];
        }
        marginTop += 35;
    }
 
    UIButton *btn = [UIButton new];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-15;
        make.top.equalTo(titleLab.mas_bottom).offset = marginTop;
        make.width.offset=50;
        make.height.offset=30;
        make.bottom.offset= -10;
    }];
    btn.layer.cornerRadius=4;
    btn.clipsToBounds=YES;
    btn.layer.borderColor=HEX(@"666666", 1.0).CGColor;
    btn.layer.borderWidth=0.5;
    btn.titleLabel.font = FONT(14);
    [btn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickDismiss) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickDismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
    
    return  [[PresentAnimationTransition alloc] initWithTransitionType:YFPresentTransitionTypeShowHongBao];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return  [[PresentAnimationTransition alloc] initWithTransitionType:YFPresentTransitionTypeDismiss];
    
}


@end
