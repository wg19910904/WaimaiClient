//
//  JHBaseVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Awesome.h"
#import "YFTabBarItem.h"
#import "JHBaseNavVC.h"
#import "BaseViewController.h"

@interface JHBaseVC : BaseViewController
// 获取这个页面对应的baritem
@property(nonatomic,strong,readonly)YFTabBarItem *yfTabBarItem;
// 返回按钮的图片
@property(nonatomic,copy)NSString *backBtnImgName;

@property(nonatomic,weak)UIView *leftNavBtnView;
@property(nonatomic,weak)UIView *rightNavBtnView;

-(void)createBackBtn;
/**
 *  返回按钮的回调
 */
-(void)clickBackBtn;

#pragma mark ======显示和隐藏没有数据的view=======
/**
 *  显示状态图
 *
 *  @param imgName  状态的图片
 *  @param desStr   状态的描述
 *  @param btnTitle 按钮的文字
 *  @param view     显示在哪个View上
 */
-(void)showEmptyViewWithImgName:(NSString *)imgName desStr:(NSString *)desStr btnTitle:(NSString *)btnTitle inView:(UIView *)view;

-(void)showEmptyViewWithImgName:(NSString *)imgName desAttrStr:(NSAttributedString *)desAttrStr btnTitle:(NSString *)btnTitle inView:(UIView *)view;

/**
 *  移除状态图
 */
-(void)hiddenEmptyView;

/**
 *  点击状态btn的回调事件
 */
-(void)clickStatusBtnAction;

#pragma mark - 提示信息

/**
 *  用于提示信息(在控制器的View上)
 *
 *  @param title 提示信息
 */
- (void)showToastAlertMessageWithTitle:(NSString *)title;

/**
 *  用于提示信息
 *
 *  @param title 提示信息
 *  @param view  显示的view
 */
- (void)showToastAlertMessageWithTitle:(NSString *)title inView:(UIView *)view;
//展示系统默认提醒框
- (void)showAlertWithTitle:(NSString *)title
                       msg:(NSString *)msg
                  btnTitle:(NSString *)btnTitle
                    action:(void (^)())btnAction;
/**
 没有数据时展示
 */
- (void)showHaveNoMoreData;

/**
 打电话
 
 @param phone 传入的电话号码
 */
-(void)callWithPhone:(NSString *)phone;

#pragma mark -- 导航栏的按钮
/**
 *  创建左边的图片按钮
 *
 *  @param imageStr     imageName
 *  @param action       action
 */
- (UIButton *)addLeftBtnWith:(NSString *)imageStr sel:(SEL)action;


/**
 给导航栏的左边再添加一个文字按钮

 @param titleStr 按钮title
 @param action 按钮的事件
 @param titleColor 文字颜色
 @return 添加的按钮
 */
- (UIButton *)addLeftTitleBtn:(NSString *)titleStr titleColor:(UIColor *)titleColor sel:(SEL)action;

/**
 *  创建右边的图片按钮
 *
 *  @param imageStr     imageName
 *  @param action       action
 */
- (UIButton *)addRightBtnWith:(NSString *)imageStr sel:(SEL)action;

/**
 *  创建右边的文字按钮
 *
 *  @param titleStr     titlestr
 *  @param action       action
 */
- (UIButton *)addRightTitleBtn:(NSString *)titleStr titleColor:(UIColor *)titleColor sel:(SEL)action;

/**
 *  自定义控件创建右边按钮
 *
 *  @param view 自定义控件
 */
//- (void)creatRightBtnWithCustomView:(UIView *)view;

/**
 push到一个新的控制器
 
 @param vcName 新的控制器的名称
 */
-(void)pushToNextVcWithVcName:(NSString *)vcName;

/**
 push到一个新的控制器
 
 @param vcName 新的控制器的名称
 @param dic 需要的参数
 */
-(void)pushToNextVcWithVcName:(NSString *)vcName params:(NSDictionary *)dic;

/**
 present到一个新的控制器
 
 @param vcName 新的控制器的名称
 */
-(void)presentToNextVcWithVcName:(NSString *)vcName;

/**
 present到一个新的控制器
 
 @param vcName 新的控制器的名称
 @param dic 需要的参数
 */
-(void)presentToNextVcWithVcName:(NSString *)vcName params:(NSDictionary *)dic;

/**
 present到一个新的带有导航栏的控制器
 @param vcName 新的控制器的名称
 */
-(void)presentToNextNaviVcWithVcName:(NSString *)vcName params:(NSDictionary *)dic;

/**
 通过路由跳转界面
 
 @param url 路由链接
 @param fromVC 跳转开始的控制器
 */
-(void)pushToNextByRoute:(NSString *)url vc:(UIViewController *)fromVC;

#pragma mark ======  =======

/**
 跳转到网页

 @param title 网页的title
 @param url 网页的链接
 */
-(void)gotoWebVC:(NSString *)title link:(NSString *)url;

#pragma mark ====== 美洽 =======
/**
 打开美洽客服
 
 @param fromVc 从哪个界面present处客服界面
 */
-(void)pushToMQkefuFrom:(__weak UIViewController *)fromVc;

@end

