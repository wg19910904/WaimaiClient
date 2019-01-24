//
//  ZQPerSonCenterBtn.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/7/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQPerSonCenterBtn : UIButton
@property(nonatomic,strong)UIImageView *imageV;//图片
@property(nonatomic,strong)UILabel *textL;//显示文字的
@property(nonatomic,copy)NSString *num;//显示角标的数值
@property(nonatomic,assign)BOOL isShowLine;//是否展示右边的线
@end
