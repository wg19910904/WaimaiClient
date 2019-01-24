//
//  JHHomeHeaderView.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/8/30.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHHomeHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(NSUInteger)type;

//根据偏移量改变状态
- (void)changeStatusWithOffset_y:(CGFloat)offset_y;

- (void)addrL_addTarget:(id)target action:(SEL)action;
//设置数据
- (void)setDataDic:(NSDictionary *)dataDic;

@end
