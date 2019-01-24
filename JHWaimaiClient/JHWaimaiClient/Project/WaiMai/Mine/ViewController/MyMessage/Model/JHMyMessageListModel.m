//
//  JHMyMessageListModel.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/25.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHMyMessageListModel.h"

@implementation JHMyMessageListModel
+(void)getMsgListWith:(NSDictionary *)dic block:(DataBlock)block{
    [HttpTool postWithAPI:@"client/member/msg/msg" withParams:dic success:^(id json) {
        NSLog(@"消息列表 =======  %@",json);
        if (ISPostSuccess) {
            NSArray *arr = [JHMyMessageListModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(nil,NOTCONNECT_STR);
    }];
}

+(void)readMsgWith:(NSDictionary *)dic block:(MsgBlock)block{
    [HttpTool postWithAPI:@"client/member/msg/readmsg" withParams:dic success:^(id json) {
        NSLog(@"阅读消息 =======  %@",json);
        if (ISPostSuccess) {
            block(YES,nil);
        }else{
            block(NO,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(NO,NOTCONNECT_STR);
    }];
}
@end
