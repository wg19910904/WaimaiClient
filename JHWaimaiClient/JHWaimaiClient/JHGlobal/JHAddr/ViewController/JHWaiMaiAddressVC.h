//
//  JHWaiMaiAddressVC.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "JHWaimaiMineAddressListDetailModel.h"
@interface JHWaiMaiAddressVC : JHBaseVC
@property(nonatomic,copy)NSString *shop_id;//商户id
@property(nonatomic,assign)float order_price;//订单价格
@property(nonatomic,copy)NSString * addr_id;//地址ID(上次选中的地址)
@property(nonatomic,copy)void(^selectorBlock)(JHWaimaiMineAddressListDetailModel *model);

@property(nonatomic,assign)BOOL is_paotui;// 跑腿地址列表
@end
