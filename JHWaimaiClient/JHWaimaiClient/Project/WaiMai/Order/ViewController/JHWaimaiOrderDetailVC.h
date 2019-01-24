//
//  JHWaimaiOrderDetailVC.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
@interface JHWaimaiOrderDetailVC : JHBaseVC
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,assign)BOOL FromPayVC;//是否从订单支付界面跳转过来的
@end
