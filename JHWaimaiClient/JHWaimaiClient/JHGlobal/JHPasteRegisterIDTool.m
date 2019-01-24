//
//  JHPasteRegisterIDTool.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/22.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHPasteRegisterIDTool.h"
#import "JHShowAlert.h"
@interface JHPasteRegisterIDTool()
@property(nonatomic,weak)UIViewController *vc;
@end
@implementation JHPasteRegisterIDTool
-(instancetype)initWithVC:(UIViewController *)superVC touchView:(UIView *)view{
    self = [super init];
    if (self) {
        self.vc = superVC;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickVC:)];
        tap.numberOfTapsRequired = 10;
        [view addGestureRecognizer:tap];
        
    }
    return self;
}
#pragma mark -点击剪贴
-(void)clickVC:(UITapGestureRecognizer *)tap{
    [JHShowAlert showAlertWithMsg:[JHUserModel shareJHUserModel].registrationID withBtnTitle:NSLocalizedString(@"复制到剪贴板",nil) withController:self .vc withBtnBlock:^{
        [[UIPasteboard generalPasteboard] setString:[JHUserModel shareJHUserModel].registrationID];
    }];
}
@end
