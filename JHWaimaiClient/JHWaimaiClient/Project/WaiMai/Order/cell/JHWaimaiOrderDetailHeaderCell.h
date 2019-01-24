//
//  JHWaimaiOrderDetailHeaderCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaimaiOrderDetailModel.h"
#import "JHOrderStatusActionProtocol.h"

@interface JHWaimaiOrderDetailHeaderCell : UITableViewCell
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,strong)JHWaimaiOrderDetailModel *model;
@property(nonatomic,weak)id<JHOrderStatusActionProtocol>delegate;
@property(nonatomic,copy)MsgBlock showOrderScheduleBlock;// 查看订单进度
@end
