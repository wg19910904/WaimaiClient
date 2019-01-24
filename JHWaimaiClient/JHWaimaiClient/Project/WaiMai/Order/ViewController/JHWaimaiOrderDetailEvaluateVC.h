//
//  JHWaimaiOrderDetailEvaluateVC.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "HZQChoseImage.h"
@interface JHWaimaiOrderDetailEvaluateVC : JHBaseVC<HZQChoseImageDelegate>
@property(nonatomic,copy)NSString *order_id;//订单id
@property(nonatomic,copy)NSString *shopImg;//商家头像
@property(nonatomic,copy)NSString *shopName;//商家姓名
@property(nonatomic,strong)NSArray *timeArr;//时间的数组
@property(nonatomic,copy)NSString *jifenNum;//评价后获得积分
@property(nonatomic,strong)NSArray *productsArr;//菜品的数组
@property(nonatomic,assign)BOOL isziti;//是否是自提
@end
