//
//  JHMyMessageModel.h
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/25.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMyMessageModel : NSObject
/*
 "can_id" = 0;
 clientip = "127.0.0.1";
 content = "\U60a8\U5728[\U6d4b\U8bd5\U4e09\U65b9\U8ba2\U5355\U5e97\U94fa]\U4e0b\U7684\U8ba2\U5355(12035)\Uff0c\U7528\U6237\U786e\U8ba4\U8ba2\U5355\U5b8c\U6210";
 dateline = 1545902969;
 "is_read" = 1;
 "message_id" = 334090;
 "order_id" = 0;
 title = "\U8ba2\U5355\U5df2\U5b8c\U6210";
 type = 2;
 uid = 4;
 */
@property(nonatomic,copy)NSString *message_id;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *is_read;
@property(nonatomic,copy)NSString *dateline;

@end

NS_ASSUME_NONNULL_END
