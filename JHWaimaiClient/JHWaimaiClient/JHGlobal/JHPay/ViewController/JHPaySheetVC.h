//
//  JHPaySheetVC.h
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/26.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPaySheetVC : JHBaseVC
@property(nonatomic,copy)NSString *order_id;//订单号
@property(nonatomic,copy)NSString *amount;//支付金额
@property(nonatomic,copy)MsgBlock paySuccessBlock;// 支付成功的回调
@property(nonatomic,weak)JHBaseVC *superVC;
@property(nonatomic,assign)BOOL is_show_friendPay; // 是否要展示好友代付
@end

NS_ASSUME_NONNULL_END
