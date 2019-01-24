//
//  JHWaiMaiOrderViewModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/9.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiOrderViewModel.h"

@implementation JHWaiMaiOrderViewModel
/**
 获取订单列表的数据
 
 @param dic 需要传入的参数
 @param myBlock 回调的结果
 */
+(void)postToGetOrderListInfoWithDic:(NSDictionary *)dic
                               block:(void(^)(JHWaimaiOrderListMainModel *model,NSString *err))myBlock{
    [HttpTool postWithAPI:@"client/waimai/order/index" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        JHWaimaiOrderListMainModel * model = [[JHWaimaiOrderListMainModel alloc]init];
        if (ISPostSuccess) {
            model = [JHWaimaiOrderListMainModel mj_objectWithKeyValues:json[@"data"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(model,err);
        }
        
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(nil,NOTCONNECT_STR);
        }
        
    }];
}
/**
 获取订单详情的接口
 
 @param dic 需要传入的参数
 @param myBlock 回调的结果
 */
+(void)postToGetOrderDetailInfoWithDic:(NSDictionary *)dic
                                 block:(void(^)(JHWaimaiOrderDetailModel *model,NSString *err))myBlock{
    [HttpTool postWithAPI:@"client/waimai/order/detail" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        JHWaimaiOrderDetailModel *  model = [[JHWaimaiOrderDetailModel alloc]init];
        if (ISPostSuccess) {
            model = [JHWaimaiOrderDetailModel  mj_objectWithKeyValues:json[@"data"][@"detail"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(model,err);
        }
        
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(nil,NOTCONNECT_STR);
        }
        
    }];
}
/**
 取消订单的方法
 
 @param dic dic
 @param myBlock 回调的结果
 */
+(void)postToCancelOrderWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString *err))myBlock{
    
    [HttpTool postWithAPI:@"client/waimai/order/chargeback" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        if (!ISPostSuccess) {
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
/**
 确认送达的方法
 
 @param dic dic
 @param myBlock 回调的结果
 */
+(void)postToSureOrderWithDic:(NSDictionary *)dic
                        block:(void(^)(NSString *err))myBlock{
    [HttpTool postWithAPI:@"client/waimai/order/confirm" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        if (!ISPostSuccess) {
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
/**
 订单投诉
 
 @param dic dic
 @param myBlock 回调的结果
 */
+(void)postToComplaintOrderWithDic:(NSDictionary *)dic
                          imageDic:(NSDictionary *)dic1
                             block:(void(^)(NSString *err))myBlock{
    [HttpTool postWithAPI:@"client/waimai/order/complaint" params:dic dataDic:dic1 success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        if (!ISPostSuccess) {
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
        
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
        
    }];

}
/**
 订单催单
 
 @param dic dic
 @param myBlock 回调的结果
 */
+(void)postToCuidanOrderWithDic:(NSDictionary *)dic
                          block:(void(^)(NSString *err))myBlock{
    [HttpTool postWithAPI:@"client/waimai/order/remind" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        if (!ISPostSuccess) {
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
/**
 申请客服介入
 
 @param dic dic
 @param myBlock 回调的结果
 */
+(void)postToShenqingKefuWithDic:(NSDictionary *)dic
                           block:(void(^)(NSString *err))myBlock{
    [HttpTool postWithAPI:@"client/waimai/order/kefu" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        if (!ISPostSuccess) {
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];

}
/**
 申请退款
 
 @param dic dic
 @param myBlock 回调的结果
 */
+(void)postToPayBackWithDic:(NSDictionary *)dic
                      block:(void(^)(NSString *err))myBlock{
    [HttpTool postWithAPI:@"client/waimai/order/payback" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        if (!ISPostSuccess) {
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
 }
/**
 订单评价
 
 @param dic 传入的参数
 @param myBlock 回调的结果
 */
+(void)postToEvaluateOrderWithDic:(NSDictionary *)dic
                         imageDic:(NSDictionary *)dic1
                            block:(void(^)(NSString *err))myBlock{
    [HttpTool postWithAPI:@"client/waimai/order/comment" params:dic dataDic:dic1 success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        if (!ISPostSuccess) {
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }

    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }

    }];
}
/**
 查看评价
 
 @param dic 传入的参数
 @param myBlock 回调的结果
 */
+(void)postToSeeEvaluationWithDic:(NSDictionary *)dic
                           block:(void(^)(JHWaimaiOrderSeeEvaliationModel *model,NSString *err))myBlock{
    [HttpTool postWithAPI:@"client/waimai/order/comment_detail" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        JHWaimaiOrderSeeEvaliationModel *  model = [[JHWaimaiOrderSeeEvaliationModel alloc]init];
        if (ISPostSuccess) {
            model = [JHWaimaiOrderSeeEvaliationModel  mj_objectWithKeyValues:json[@"data"][@"detail"]];
        }else{
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(model,err);
        }
        
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(nil,NOTCONNECT_STR);
        }
        
    }];

}
/**
 申请客服介入
 
 @param dic 传入的参数
 @param myBlock 回调的block
 */
+(void)postToServiseWithDic:(NSDictionary *)dic
                      block:(void(^)(NSString *err))myBlock{
    
    [HttpTool postWithAPI:@"client/waimai/order/kefu" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        NSString *err = nil;
        if (!ISPostSuccess) {
            err = Error_Msg;
        }
        if (myBlock) {
            myBlock(err);
        }
    } failure:^(NSError *error) {
        if (myBlock) {
            myBlock(NOTCONNECT_STR);
        }
    }];
}
@end
