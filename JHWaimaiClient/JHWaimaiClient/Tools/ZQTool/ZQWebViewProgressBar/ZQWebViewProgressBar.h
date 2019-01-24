//
//  ZQWebViewProgressBar.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/11/29.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQWebViewProgressBar : UIView

/**
 进度条设置的颜色
 */
@property(nonatomic,strong)UIColor *tintColor;
/**
 一开始需要加载的动画
 */
-(void)initAnimation;

/**
 网页加载完成需要的动画
 */
-(void)completionAnimation;
@end
