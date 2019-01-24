//
//  JHWaimaiOrderPayTypeCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWaimaiOrderPayTypeCell : UITableViewCell
@property(nonatomic,copy)NSString *typeImg;//类型的图标
@property(nonatomic,copy)NSString *title;//显示支付类型
@property(nonatomic,assign)BOOL isHid;//是否隐藏底部的线
@property(nonatomic,copy)NSString *rightImg;//右边的图片;
@property(nonatomic,copy)NSString *bankCardName;// 银行卡名称
@end
