//
//  JHPayVC.h
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPayVC : JHBaseVC
@property(nonatomic,copy)NSString *order_id;//订单号
@property(nonatomic,copy)NSString *amount;//支付金额
@property(nonatomic,assign)BOOL isDetailVC;//是否是从详情进入的
@property(nonatomic,copy)MsgBlock paySuccessBlock;// 支付成功的回调
@property(nonatomic,assign)NSInteger dateline;// 倒计时的时间戳
@property(nonatomic,assign)BOOL is_show_friendPay; // 是否要展示好友代付
@end

NS_ASSUME_NONNULL_END
