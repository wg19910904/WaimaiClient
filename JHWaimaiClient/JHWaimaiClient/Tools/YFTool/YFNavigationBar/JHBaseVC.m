//
//  JHBaseVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
#import "DSToast.h"
#import "AppDelegate.h"
#import "ShowEmptyDataView.h"
#import "YFTabBarController.h"
#import "YFTabBar.h"
#import "JHShowAlert.h"
#import "JHADWebVC.h"
#import "JHJumpRouteModel.h"
#import "NSObject+XHTool.h"
#import "NaviButtonItem.h"
#import <MQChatViewManager.h>
@interface JHBaseVC ()
{
    AppDelegate *_delegate;
}
@property(nonatomic,strong)DSToast *textToast;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)ShowEmptyDataView *emptyView;

@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@end

@implementation JHBaseVC

-(NSMutableDictionary *)heightAtIndexPath{
    if (_heightAtIndexPath==nil) {
        _heightAtIndexPath=[[NSMutableDictionary alloc] init];
    }
    return _heightAtIndexPath;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height != nil){
        return height.floatValue;
    }else{
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

-(void)viewWillAppear:(BOOL)animated{
   
    if ([self.navigationController.viewControllers.firstObject isEqual:self]) {
        [self.navigationController.navigationBar yf_setCurrentNavBarVC:self];
    }
    if (self.naviColor) {
        [self.navigationController.navigationBar yf_setBackgroundColor:self.naviColor];
    }
    self.naviColor = [self.navigationController.navigationBar yfBackgroundColor];
    [super viewWillAppear:animated];
    NSLog(@"\n\n\n********************\n当前控制器为:  %@\n********************\n\n\n",   NSStringFromClass([self class]));
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.naviColor = [self.navigationController.navigationBar yfBackgroundColor];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    #pragma mark ====== 导航栏颜色出现问题时处理 =======
    if (!self.naviColor) {
        if ([(YFTabBarController *)self.tabBarController tabbarType] == YFTabBarControllerTypeMall) {
            self.naviColor = [UIColor whiteColor];
        }else{
             self.naviColor = NaVi_COLOR_Alpha(1.0);
        }
    }
    
    //判断是否需要隐藏左侧按钮
    [self judgeShowOrHidden];
    [super viewDidLoad];
    
    self.view.backgroundColor = BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;

}

//#pragma mark - 创建左边按钮
- (void)createBackBtn
{
    if (self.backBtn) return;
    
    NSString *image = @"nav_btn_back";
    if ([self.navigationController isKindOfClass:[JHBaseNavVC class]]) {
        if ([(YFTabBarController *)self.tabBarController tabbarType] == YFTabBarControllerTypeMall) {
            image = @"mall_btn_top_back";
        }else{
            NSInteger count = self.navigationController.viewControllers.count;
            if (count > 1 && [(YFTabBarController *)self.tabBarController tabbarType] == YFTabBarControllerTypeMall) {
                 image = @"mall_btn_top_back";
            }else{
                 image = @"nav_btn_back";
            }
        }
    }
   self.backBtn = [self addLeftBtnWith:image sel:@selector(clickBackBtn)];
}

// 重置返回按钮的图片
-(void)setBackBtnImgName:(NSString *)backBtnImgName{
    [self.backBtn setImage:IMAGE(backBtnImgName) forState:UIControlStateNormal];
}

#pragma mark - 判断是否需要隐藏左侧按钮
- (void)judgeShowOrHidden
{
    UINavigationController *self_nav = self.navigationController;
    if (self_nav && self_nav.viewControllers[0] == self) {
        self.backBtn.hidden = YES;
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        //创建左边的按纽
        if (self.backBtn)  self.backBtn.hidden=NO;
        else  [self createBackBtn];
    }
}

#pragma mark - 点击导航栏左按钮
- (void)clickBackBtn
{
    //通知关闭分类筛选
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_close_fenlei_shaixuan object:nil];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark====添加左边的按钮======
- (UIButton *)addLeftBtnWith:(NSString *)imageStr sel:(SEL)action{
    
    NSMutableArray *arr=[NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    
    NaviButtonItem *navBarBtnView;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:action
      forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:IMAGE(imageStr) forState:UIControlStateNormal];

    if (arr.count == 0) {
        navBarBtnView = [[NaviButtonItem alloc] initWithFrame:FRAME(0, 0, 44, 44)];
        self.leftNavBtnView = navBarBtnView;
        leftBtn.frame = FRAME(0, 0, 44, 44);
    }else{
        navBarBtnView = ((UIBarButtonItem *)arr.lastObject).customView;
        leftBtn.frame = FRAME(navBarBtnView.width, 0, 44, 44);
        navBarBtnView.width += 44;
    }
    [navBarBtnView addSubview:leftBtn];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:navBarBtnView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;//@[negativeSpacer,leftBtnItem];
    
    return leftBtn;

}

- (UIButton *)addLeftTitleBtn:(NSString *)titleStr titleColor:(UIColor *)titleColor sel:(SEL)action{

    NSMutableArray *arr=[NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    
    NaviButtonItem *navBarBtnView;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:action
      forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:titleStr forState:UIControlStateNormal];
    [leftBtn setTitleColor:titleColor forState:UIControlStateNormal];
    leftBtn.titleLabel.font=FONT(16);
    
    if (arr.count == 0) {
        navBarBtnView = [[NaviButtonItem alloc] initWithFrame:FRAME(0, 0, 40, 40)];
        self.leftNavBtnView = navBarBtnView;
        leftBtn.frame = FRAME(0, 0, 40, 40);
        [leftBtn sizeToFit];
        navBarBtnView.width = leftBtn.width;
    }else{
        navBarBtnView = ((UIBarButtonItem *)arr.lastObject).customView;
        leftBtn.frame = FRAME(navBarBtnView.width, 0, 40, 40);
        [leftBtn sizeToFit];
        navBarBtnView.width += leftBtn.width;
    }
    
    [navBarBtnView addSubview:leftBtn];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:navBarBtnView];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
//    negativeSpacer.width = -10;//负数为左移，正数为右移
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;//@[negativeSpacer,leftBtnItem];
    
    return leftBtn;
}

#pragma mark====创建右边的按钮======
- (UIButton *)addRightBtnWith:(NSString *)imageStr sel:(SEL)action{
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:action
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:IMAGE(imageStr) forState:UIControlStateNormal];
    NaviButtonItem *navBarBtnView;
    NSMutableArray *arr=[NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    BOOL isWeb = [NSStringFromClass([self class]) isEqualToString:@"JHADWebVC"];
    if (arr.count == 0 || isWeb) {
        navBarBtnView = [[NaviButtonItem alloc] initWithFrame:FRAME(0, 0, 40, 40)];
        navBarBtnView.type = NaviButtonItemTypeRight;
        self.rightNavBtnView = navBarBtnView;
        rightBtn.frame = FRAME(0, 0, 40, 40);
    }else{
        navBarBtnView = ((UIBarButtonItem *)arr.lastObject).customView;
        rightBtn.frame = FRAME(0, 0, 40, 40);
        navBarBtnView.width += 40;
    }
    [navBarBtnView addSubview:rightBtn];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:navBarBtnView];
    self.navigationItem.rightBarButtonItem = rightBtnItem;// @[negativeSpacer,rightBtnItem];
    return rightBtn;
}

- (UIButton *)addRightTitleBtn:(NSString *)titleStr titleColor:(UIColor *)titleColor sel:(SEL)action{
    NSMutableArray *arr=[NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    NaviButtonItem *navBarBtnView;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:action
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:titleStr forState:UIControlStateNormal];
    [rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    CGFloat width = 40;
    BOOL isWeb = [NSStringFromClass([self class]) isEqualToString:@"JHADWebVC"];
    if (arr.count == 0 || isWeb) {
        navBarBtnView = [[NaviButtonItem alloc] initWithFrame:FRAME(0, 0, width, 40)];
        navBarBtnView.type = NaviButtonItemTypeRight;
        self.rightNavBtnView = navBarBtnView;
        rightBtn.frame = FRAME(0, 0, width, 40);
        navBarBtnView.width = rightBtn.width;
    }else{
            navBarBtnView = ((UIBarButtonItem *)arr.lastObject).customView;
            rightBtn.frame = FRAME(0, 0, width, 40);
            navBarBtnView.width += rightBtn.width;
        }
    rightBtn.titleLabel.font = FONT(14); [navBarBtnView addSubview:rightBtn];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:navBarBtnView];
    self.navigationItem.rightBarButtonItem = rightBtnItem;//@[negativeSpacer,rightBtnItem];
    return rightBtn;
}



#pragma mark--===用于提示信息
- (void)showToastAlertMessageWithTitle:(NSString *)title
{
    if (_textToast == nil) {
        _textToast = [[DSToast alloc] initWithText:title];
        _textToast.backgroundColor = HEX(@"000000", 0.7);
        _textToast.textColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf=self;
        [_textToast showInView:_delegate.window showType:DSToastShowTypeBottom withBlock:^{
            weakSelf.textToast = nil;
        }];
    }
}

- (void)showToastAlertMessageWithTitle:(NSString *)title inView:(UIView *)view
{
    if (_textToast == nil) {
        _textToast = [[DSToast alloc] initWithText:title];
        _textToast.backgroundColor = HEX(@"000000", 0.7);
        _textToast.textColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf=self;
        [_textToast showInView:_delegate.window showType:DSToastShowTypeCenter withBlock:^{
            weakSelf.textToast = nil;
        }];
    }
}
- (void)showAlertWithTitle:(NSString *)title
                       msg:(NSString *)msg
                  btnTitle:(NSString *)btnTitle
                    action:(void (^)())btnAction{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:msg
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:btnTitle
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                if (btnAction) {
                                                    btnAction();
                                                }
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 没有数据时展示
- (void)showHaveNoMoreData
{
    if (_textToast == nil) {
        _textToast = [[DSToast alloc] initWithText: NSLocalizedString(@"亲,没有更多数据了", NSStringFromClass([self class]))];
        _textToast.backgroundColor = HEX(@"000000", 0.7);
        _textToast.textColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf=self;
        [_textToast showInView:_delegate.window showType:DSToastShowTypeCenter withBlock:^{
            weakSelf.textToast = nil;
        }];
    }
    
}

#pragma mark ======显示和隐藏没有数据的view=======
-(void)showEmptyViewWithImgName:(NSString *)imgName desStr:(NSString *)desStr btnTitle:(NSString *)btnTitle inView:(UIView *)view{
    
//    if (imgName  && imgName.length>0)
        self.emptyView.emptyImg = imgName;
    
    NetworkStatus status = [JHConfigurationTool shareJHConfigurationTool].netStatus;
    if (status == NotReachable) {
//        self.emptyView.desStr = NSLocalizedString(@"亲,您的网络貌似短路了哟!", nil);
        self.emptyView.emptyImg = @"icon_wu";
//        btnTitle = NSLocalizedString(@"点击刷新", nil);
    }else if (desStr && desStr.length>0)  self.emptyView.desStr = desStr;
    
    if (btnTitle  && btnTitle.length>0) {
        self.emptyView.is_showBtn=YES;
        self.emptyView.statusBtnTitle=btnTitle;
    }else  self.emptyView.is_showBtn=NO;
    
    [view addSubview:self.emptyView];
    [view bringSubviewToFront:self.emptyView];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset=0;
        make.left.offset=0;
        make.right.offset=0;
        make.bottom.offset=0;
        
        make.centerX.offset = 0;
        make.centerY.offset = 0;

    }];
    
}

-(void)showEmptyViewWithImgName:(NSString *)imgName desAttrStr:(NSAttributedString *)desAttrStr btnTitle:(NSString *)btnTitle inView:(UIView *)view{

    self.emptyView.emptyImg = imgName;
    
    NetworkStatus status = [JHConfigurationTool shareJHConfigurationTool].netStatus;
    if (status == NotReachable) {
        self.emptyView.emptyImg = @"icon_wu";
    }else if (desAttrStr && desAttrStr.length>0)  self.emptyView.desAttrStr = desAttrStr;
    
    if (btnTitle  && btnTitle.length>0) {
        self.emptyView.is_showBtn=YES;
        self.emptyView.statusBtnTitle=btnTitle;
    }else  self.emptyView.is_showBtn=NO;
    
    [view addSubview:self.emptyView];
    [view bringSubviewToFront:self.emptyView];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset=0;
        make.left.offset=0;
        make.right.offset=0;
        make.bottom.offset=0;
        
        make.centerX.offset = 0;
        make.centerY.offset = 0;
        
    }];
    
}

-(void)hiddenEmptyView{
    [self.emptyView removeFromSuperview];
    _emptyView=nil;
}

-(ShowEmptyDataView *)emptyView{
    if (_emptyView==nil) {
        __weak typeof(self) weakSelf=self;
        _emptyView=[[ShowEmptyDataView alloc] initWithFrame:weakSelf.view.frame];
        _emptyView.clickStatusBtn=^{
            [weakSelf clickStatusBtnAction];
        };
    }
    return _emptyView;
}

-(void)clickStatusBtnAction{
    
}

#pragma mark ====== 跳转到网页 =======
-(void)gotoWebVC:(NSString *)title link:(NSString *)url{
    JHADWebVC *ad = [JHADWebVC new];
    ad.titleStr = title;
    ad.url = url;
    [self.navigationController pushViewController:ad animated:YES];
}

/**
 通过路由跳转界面

 @param url 路由链接
 @param fromVC 跳转开始的控制器
 */
-(void)pushToNextByRoute:(NSString *)url vc:(UIViewController *)fromVC{
    
    if (url.length == 0) { return;}
    UIViewController *toVC =  (UIViewController *)[JHJumpRouteModel jumpWithLink:url];
    if (!toVC) {
        return;
    }

    if ([toVC isKindOfClass:NSClassFromString(@"YFTabBarController")]
        || [toVC isKindOfClass:NSClassFromString(@"JHNewWaiMaiMySelfVC")]
        || [toVC isKindOfClass:NSClassFromString(@"JHWaiMaiOrderVC")])
    {
        if ([toVC isKindOfClass:NSClassFromString(@"YFTabBarController")] && [[toVC valueForKey:@"is_goNew"] boolValue]) {
            YFTabBarController * tab = (YFTabBarController *)self.tabBarController;
            if (tab.tabbarType == ((YFTabBarController *)toVC).tabbarType) {
                if ([(YFTabBarController *)toVC tabbarType] == YFTabBarControllerTypeMall) {
                    self.tabBarController.selectedIndex = 0;
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self presentViewController:toVC animated:YES completion:nil pushStyle:YES];
            }
            
        }
        [fromVC.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        
        [fromVC.navigationController pushViewController:toVC animated:YES];

    }
}

/**
 push到一个新的控制器

 @param vcName 新的控制器的名称
 */
-(void)pushToNextVcWithVcName:(NSString *)vcName{
    
    Class vc = NSClassFromString(vcName);
    if (!vc) { return; }
    [self.navigationController pushViewController:[vc new] animated:YES];
}

/**
  push到一个新的控制器

 @param vcName 新的控制器的名称
 @param dic 需要的参数
 */
-(void)pushToNextVcWithVcName:(NSString *)vcName params:(NSDictionary *)dic{
 
    Class vcClass = NSClassFromString(vcName);
    if (!vcClass) { return; }
    UIViewController *vc = [vcClass new];
    if (dic) {
        for (NSString *key in dic.allKeys) {
            id value = dic[key];
            [vc setValue:value forKey:key];
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 present到一个新的控制器
 @param vcName 新的控制器的名称
 */
-(void)presentToNextVcWithVcName:(NSString *)vcName{
    Class vc = NSClassFromString(vcName);
    if (!vc) { return; }
    if ([vcName isEqualToString:@"JHAddressMainVC"]) {
        JHBaseNavVC *nav = [[JHBaseNavVC alloc] initWithRootViewController:[vc new]];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [self presentViewController:[vc new] animated:YES completion:nil];
    }
   
}

-(void)presentToNextVcWithVcName:(NSString *)vcName params:(NSDictionary *)dic{
    
    Class vcClass = NSClassFromString(vcName);
    if (!vcClass) { return; }
    UIViewController *vc = [vcClass new];
    if (dic) {
        for (NSString *key in dic.allKeys) {
            id value = dic[key];
            [vc setValue:value forKey:key];
        }
    }
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

/**
 present到一个新的带有导航栏的控制器
 @param vcName 新的控制器的名称
 */
-(void)presentToNextNaviVcWithVcName:(NSString *)vcName params:(NSDictionary *)dic{
    
    Class vcClass = NSClassFromString(vcName);
    if (!vcClass) { return; }
    UIViewController *vc = [vcClass new];
    if (dic) {
        for (NSString *key in dic.allKeys) {
            id value = dic[key];
            [vc setValue:value forKey:key];
        }
    }
    JHBaseNavVC *nav = [[JHBaseNavVC alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark ====== 获取每个控制器的item =======
-(YFTabBarItem *)yfTabBarItem{
    for (UIViewController * vc in self.tabBarController.viewControllers) {
        for (UIViewController *sub in vc.childViewControllers) {
            if (sub == self) {
                NSInteger index = [self.tabBarController.viewControllers indexOfObject:vc];
                YFTabBarItem * item = [((YFTabBar *)self.tabBarController.tabBar) getItemWithIndex:index];
                return item;
            }
        }
    }
    return nil;
}
/**
 打电话
 @param phone 传入的电话号码
 */
-(void)callWithPhone:(NSString *)phone{
//  [JHShowAlert showCallWithMsg:phone withController:self];
    if (phone.length == 0) {
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
}
#pragma mark ====== 美洽客服处理 =======
-(void)pushToMQkefuFrom:(UIViewController *)fromVc{
    fromVc = fromVc == nil ? self : fromVc;
    [MQChatViewConfig sharedConfig].navBarTintColor = [UIColor whiteColor];
    [MQChatViewConfig sharedConfig].navBarColor = [UIColor whiteColor];
    [MQChatViewConfig sharedConfig].navTitleColor = HEX(@"333333", 1.0);
    //
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
    [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];
    [chatViewManager.chatViewStyle setNavBarTintColor:HEX(@"333333", 1.0)];
    [chatViewManager.chatViewStyle setStatusBarStyle:UIStatusBarStyleLightContent];
    NSString *name = [JHUserModel shareJHUserModel].nickname;
    NSString *tel = [JHUserModel shareJHUserModel].mobile;
    NSString *uid = [JHUserModel shareJHUserModel].uid;
    if (uid) {
        [chatViewManager setClientInfo:@{@"name":name,
                                         @"tel":tel}
                              override:YES];
        [chatViewManager setLoginCustomizedId:uid];
    }
    [chatViewManager pushMQChatViewControllerInViewController:fromVc];
    // 设置用户头像
    [MQManager setClientInfo:@{@"avatar":ImageUrl([JHUserModel shareJHUserModel].face)} completion:nil];
    [MQManager setCurrentClientOnlineWithSuccess:^(MQClientOnlineResult result, MQAgent *agent, NSArray<MQMessage *> *messages) {
        //       NSDictionary *dic = [MQManager getCurrentClientInfo];
        //        NSLog(@"客户信息  %@",dic);
    } failure:^(NSError *error) { } receiveMessageDelegate:nil];
}

-(void)dealloc{
    NSLog(@" 我释放了%@",[self class]);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

