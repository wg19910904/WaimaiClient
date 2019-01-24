//
//  JHWaiMaiOrderListCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/23.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaiMaiOrderListModel.h"
@protocol JHWaiMaiOrderListCellDelegate <NSObject>
@optional
/**
 点击按钮的回调
 */
-(void)clickBtnWithBtn:(UIButton *)sender
                 index:(NSIndexPath*)indexPath;

/**
 进入商家
 */
-(void)clickToShopDetail:(NSIndexPath *)indexPath;
/**
 支付倒计时结束的回调
 */
-(void)payTimerOverWithIndex:(NSIndexPath*)indexPath;
@end
@interface JHWaiMaiOrderListCell : UITableViewCell
@property(nonatomic,assign)EWaimaiOrderStatus status;//订单当前所处的状态
@property(nonatomic,strong)JHWaiMaiOrderListModel *model;//处理数据的模型

@property(nonatomic,strong)NSIndexPath *index;
@property(nonatomic,weak)id<JHWaiMaiOrderListCellDelegate>delegate;
@end
