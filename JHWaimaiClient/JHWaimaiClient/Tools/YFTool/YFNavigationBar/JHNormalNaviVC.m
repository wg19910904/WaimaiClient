//
//  JHNormalNaviVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/19.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHNormalNaviVC.h"
#import "UINavigationBar+Awesome.h"

@interface JHNormalNaviVC ()

@end

@implementation JHNormalNaviVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = YES;
    [self.navigationBar yf_setBackgroundColor:NaVi_COLOR_Alpha(1.0)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:HEX(@"333333", 1.0)}];
    self.navigationBar.tintColor = NaVi_COLOR_Alpha(1.0);

}

@end
