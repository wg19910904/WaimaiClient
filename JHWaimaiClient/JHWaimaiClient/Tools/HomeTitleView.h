//
//  HomeTitleView.h
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/25.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTitleView : UIControl

/**
 展示标题的view

 @param title 需要展示的标题
 @param frame 位置大小
 @param view  承载的View
 */
+(HomeTitleView *)showViewWithTitle:(NSString *)title
                   frame:(CGRect )frame
                withView:(UINavigationItem *)view;
@property(nonatomic,copy)NSString *titleText;
@property(nonatomic,assign)float backViewAlpha;
@property(nonatomic, assign) CGSize intrinsicContentSize;
@end
