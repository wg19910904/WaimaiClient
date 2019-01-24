//
//  JHMyMessageListModel.h
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/25.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMyMessageListModel : NSObject
@property(nonatomic,copy)NSString *message_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)int type;//  1:红包消息, 2:订单消息,3:其它消息
@property(nonatomic,assign)BOOL is_read;//0:未读 1:已读
@property(nonatomic,assign)NSInteger dateline;//收到消息的UNIXTIME
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *order_link;


/**
 获取消息列表
 
 @param page 分页
 @param block 回调的block
 */
+(void)getMsgListWith:(NSDictionary *)dic block:(DataBlock)block;


/**
 阅读消息
 
 @param msg_id 消息id
 @param block 回调的block
 */
+(void)readMsgWith:(NSDictionary *)dic block:(MsgBlock)block;
@end

NS_ASSUME_NONNULL_END
