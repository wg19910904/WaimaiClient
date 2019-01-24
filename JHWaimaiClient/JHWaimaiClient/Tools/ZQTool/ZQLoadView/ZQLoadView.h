//
//  ZQLoadView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQLoadView : UIView
@property(nonatomic,copy)void(^removeBlock)();
+(ZQLoadView *)showInView:(UIView *)view frame:(CGRect)frame;
-(void)removeView;
@end
