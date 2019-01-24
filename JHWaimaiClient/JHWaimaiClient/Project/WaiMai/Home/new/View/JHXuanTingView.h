//
//  JHXuanTingView.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/27.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHHomeShaiXuanView.h"
//样式
typedef NS_ENUM(NSInteger,E_XUANTING_TYPE) {
    E_XUANTING_TYPE_ONE = 0,//确定完成
    E_XUANTING_TYPE_TWO
};

@interface JHXuanTingView : UIView<UITextFieldDelegate>
@property(nonatomic,assign)E_XUANTING_TYPE xuan_ting_type;
@property(nonatomic,strong)JHHomeShaiXuanView *shaiXuanV;
//根据偏移量改变状态
- (void)changeStatusWithOffset_y:(CGFloat)offset_y showFenLei:(BOOL)show;
//地址的点击事件
- (void)addrL_addTarget:(id)target action:(SEL)action;
//数据
@property(nonatomic,copy)NSDictionary *dataDic;
@end
