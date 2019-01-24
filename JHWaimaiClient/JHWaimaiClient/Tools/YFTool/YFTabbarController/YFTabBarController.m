//
//  YFTabBarController.m
//  YFTabar
//
//  Created by jianghu3 on 16/4/20.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "YFTabBarController.h"
#import "YFTabBar.h"
#import "JHBaseNavVC.h"
#import "JHJumpRouteModel.h"
#import "AppDelegate.h"
@interface YFTabBarController ()
@property(nonatomic,assign)BOOL tabbarIsChanged;
@end

@implementation YFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//-(void)normalTableView{
//
//    NSArray *vcArr = @[@"JHHomeVC",@"JHCategoryVC",@"JHWaiMaiShopCartVC",@"JHAllOrderVC",@"JHMySelfVC"];
//
//    NSArray *titleArr = @[NSLocalizedString(@"首页", @"AppDelegate"),NSLocalizedString(@"分类", nil),NSLocalizedString(@"购物车", nil),NSLocalizedString(@"订单", @"AppDelegate"),NSLocalizedString(@"我的", @"AppDelegate")];
//    NSArray *selectedArr = @[@"tabbar01-pre",@"tabbar02-pre",@"tabbar03-pre",@"tabbar04-pre",@"tabbar05-pre"];
//    NSArray *normalArr = @[@"tabbar01",@"tabbar02",@"tabbar03",@"tabbar04",@"tabbar05"];
//    self.tabbarType = YFTabBarControllerTypeAll;
//    [self setUpViewWithViewControllers:vcArr titleArr:titleArr normalImageArr:normalArr selectedArr:selectedArr];
//}

-(void)waimaiTabbar{
    
    NSArray *vcArr = @[@"JHWaiMaiHomeVC",@"JHWaiMaiShopCartVC",@"JHWaiMaiOrderVC",@"JHNewWaiMaiMySelfVC"];
    NSArray *titleArr = @[NSLocalizedString(@"首页", @"AppDelegate"),NSLocalizedString(@"购物车", nil),NSLocalizedString(@"订单", @"AppDelegate"),NSLocalizedString(@"我的", @"AppDelegate")];
    NSArray *selectedArr = @[@"tabbar01-pre",@"tabbar03-pre",@"tabbar04-pre",@"tabbar05-pre"];
    NSArray *normalArr = @[@"tabbar01",@"tabbar03",@"tabbar04",@"tabbar05"];
    self.tabbarType = YFTabBarControllerTypeWai;
    NSMutableArray *vcArray = [self viewControllers:vcArr titleArr:titleArr normalImageArr:normalArr selectedArr:selectedArr];

    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *tabbarDic = app_delegate.tabbarConfig.tabbarDic;
    [self tabBarChanged:tabbarDic vcArr:vcArray];
    
    self.is_goNew = YES;
}

//-(void)mallTabbar{
//    NSArray *vcArr = @[@"JHMallHomeVC",@"JHMallCategoryVC",@"JHMallCartVC",@"JHMallCenterVC"];
//    NSArray *titleArr = @[NSLocalizedString(@"首页", nil),NSLocalizedString(@"分类", nil),NSLocalizedString(@"购物车", nil),NSLocalizedString(@"我的", nil)];
//    NSArray *selectedArr = @[@"tabbar01-pre",@"tabbar02-pre",@"tabbar03-pre",@"tabbar05-pre"];
//    NSArray *normalArr = @[@"tabbar01",@"tabbar02",@"tabbar03",@"tabbar05"];
//    self.tabbarType = YFTabBarControllerTypeMall;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [self setUpViewWithViewControllers:vcArr titleArr:titleArr normalImageArr:normalArr selectedArr:selectedArr];
//    self.is_goNew = YES;
//}
//
//-(void)tuanGouTabbar{
//    NSArray *vcArr = @[@"JHTuanGouHomePageVC",@"JHTuanGouOrderMainVC",@"JHTuanCenterVC"];
//    NSArray *titleArr = @[NSLocalizedString(@"首页", nil),NSLocalizedString(@"订单", nil),NSLocalizedString(@"我的", nil)];
//    NSArray *selectedArr = @[@"tuantabbar01_pre",@"tuantabbar02_pre",@"tuantabbar03_pre"];
//    NSArray *normalArr = @[@"tuantabbar01",@"tuantabbar02",@"tuantabbar03"];
//    self.tabbarType = YFTabBarControllerTypeTuan;
//    [self setUpViewWithViewControllers:vcArr titleArr:titleArr normalImageArr:normalArr selectedArr:selectedArr];
//    self.is_goNew = YES;
//}
//
//-(void)paoTuiTabbar{
//    NSArray *vcArr = @[@"JHPaoTuiHomeVC",@"JHPaoTuiOrderVC",@"JHPaoTuiPersonCenterVC"];
//    NSArray *titleArr = @[NSLocalizedString(@"跑腿", nil),NSLocalizedString(@"订单", nil),NSLocalizedString(@"我的", nil)];
//    NSArray *selectedArr = @[@"paotui_tabbar01_pre",@"paotui_tabbar02_pre",@"paotui_tabbar03_pre"];
//    NSArray *normalArr = @[@"paotui_tabbar01",@"paotui_tabbar02",@"paotui_tabbar03"];
//    self.tabbarType = YFTabBarControllerTypePaoTui;
//    [self setUpViewWithViewControllers:vcArr titleArr:titleArr normalImageArr:normalArr selectedArr:selectedArr];
//    self.is_goNew = YES;
//}


-(void)setUpViewWithViewControllers:(NSArray *)subControllers titleArr:(NSArray *)titleArr normalImageArr:(NSArray *)normalArr selectedArr:(NSArray *)selectedArr{
    
    YFTabBar *tabbar = [[YFTabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    [tabbar setUpViewWithTitleArr:titleArr normalImageArr:normalArr selectedArr:selectedArr];
    //KVC实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
     __weak typeof(self) weakSelf=self;
    tabbar.clickBarItem=^(NSInteger index){
        weakSelf.selectedIndex = index;
    };
    
    NSMutableArray *vcArr = [NSMutableArray array];
    for (NSInteger i=0; i<subControllers.count; i++) {
        if ([subControllers[i] isKindOfClass:[UINavigationController class]]) {
            [vcArr addObject:subControllers[i]];
        }else if([subControllers[i] isKindOfClass:[UIViewController class]]){
            JHBaseNavVC *nav=[[JHBaseNavVC alloc]initWithRootViewController:subControllers[i]];
            if (self.tabbarType == YFTabBarControllerTypeMall) {
                nav.is_white_nav = YES;
            }
            [vcArr addObject:nav];
        }else if([subControllers[i] isKindOfClass:[NSString class]]){
            JHBaseNavVC *nav;
            nav=[[JHBaseNavVC alloc]initWithRootViewController:[NSClassFromString(subControllers[i]) new]];
            if (self.tabbarType == YFTabBarControllerTypeMall) {
                nav.is_white_nav = YES;
            }
            [vcArr addObject:nav];
        }
    }
    [self setViewControllers:vcArr];

}
-(NSMutableArray *)viewControllers:(NSArray *)subControllers titleArr:(NSArray *)titleArr normalImageArr:(NSArray *)normalArr selectedArr:(NSArray *)selectedArr{
    
//    YFTabBar *tabbar = [[YFTabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
//    [tabbar setUpViewWithTitleArr:titleArr normalImageArr:normalArr selectedArr:selectedArr];
//    //KVC实质是修改了系统的_tabBar
//    [self setValue:tabbar forKeyPath:@"tabBar"];
//    __weak typeof(self) weakSelf=self;
//    tabbar.clickBarItem=^(NSInteger index){
//        weakSelf.selectedIndex = index;
//    };
//
    NSMutableArray *vcArr = [NSMutableArray array];
    for (NSInteger i=0; i<subControllers.count; i++) {
        if ([subControllers[i] isKindOfClass:[UINavigationController class]]) {
            [vcArr addObject:subControllers[i]];
        }else if([subControllers[i] isKindOfClass:[UIViewController class]]){
            JHBaseNavVC *nav=[[JHBaseNavVC alloc]initWithRootViewController:subControllers[i]];
            if (self.tabbarType == YFTabBarControllerTypeMall) {
                nav.is_white_nav = YES;
            }
            [vcArr addObject:nav];
        }else if([subControllers[i] isKindOfClass:[NSString class]]){
            JHBaseNavVC *nav;
            nav=[[JHBaseNavVC alloc]initWithRootViewController:[NSClassFromString(subControllers[i]) new]];
            if (self.tabbarType == YFTabBarControllerTypeMall) {
                nav.is_white_nav = YES;
            }
            [vcArr addObject:nav];
        }
    }
    return vcArr;
}
-(NSUInteger)selectedIndex{
    return  ((YFTabBar *)self.tabBar).selectedIndex;
}

// 显示特殊角标
-(void)setShowNew:(BOOL)showNew{
    _showNew = showNew;
    ((YFTabBar *)self.tabBar).showNew = showNew;
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    if (super.selectedIndex != selectedIndex) {
        super.selectedIndex = selectedIndex;
        ((YFTabBar *)self.tabBar).selectedIndex = selectedIndex;
    }
}
#pragma mark - tabbar改变了
- (void)tabBarChanged:(NSDictionary *)tabbarDic vcArr:(NSMutableArray *)vcArray{
    NSArray *content = [tabbarDic valueForKey:@"content"];
    NSMutableArray *titleArr = @[].mutableCopy;
    NSMutableArray *normalArr = @[].mutableCopy;
    NSMutableArray *selectedArr = @[].mutableCopy;
    for (NSDictionary *dataDic in content) {
        [titleArr addObject:dataDic[@"title"]];
        [normalArr addObject:dataDic[@"icon_nochecked"]];
        [selectedArr addObject:dataDic[@"icon_checked"]];
    }
    //修改tabbar
    __weak typeof(self) weakSelf=self;
    YFTabBar *tabbar = [[YFTabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    [tabbar setUpViewWithTitleArr:titleArr normalImageArr:normalArr selectedArr:selectedArr];
    tabbar.clickBarItem=^(NSInteger index){
        weakSelf.selectedIndex = index;
    };
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    //修改控制器
    if (content.count == 3 && vcArray.count == 4) {
        //去除默认的第二个控制器
        NSArray *vcShowArr = @[vcArray[0],vcArray[2],vcArray[3]];
        self.viewControllers = vcShowArr;
    }else if (content.count == 4 && vcArray.count == 4){
        //更改默认的第二个控制器
        NSString *vcLink = [(NSDictionary *)(content[1]) valueForKey:@"link"];
        if (vcLink.length) {
            UIViewController *rootVC =  (UIViewController *)[JHJumpRouteModel jumpWithLink:vcLink];
            JHBaseNavVC *navVC = [[JHBaseNavVC alloc] initWithRootViewController:rootVC];
            NSArray *vcShowArr = @[vcArray[0],navVC,vcArray[2],vcArray[3]];
            self.viewControllers = vcShowArr;
        }else{
            self.viewControllers = vcArray;
        }
    }else{
        self.viewControllers = vcArray;
    }
}


//- (void)dealloc{
//    YFTabBarController* tab = (YFTabBarController *)[[self topViewController] tabBarController];
//    if ([tab tabbarType] == YFTabBarControllerTypeMall) {
//        
//    }else{
//         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
//}

@end
