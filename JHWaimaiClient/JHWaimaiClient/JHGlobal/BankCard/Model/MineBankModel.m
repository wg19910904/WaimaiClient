//
//  MineBankModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "MineBankModel.h"
#import <MJExtension.h>

@implementation MineBankModel

-(NSString *)card_img{
    _card_img = @"card_visa02";
    if (_card_type == 2){
        _card_img = @"card_master02";
    }else if(_card_type == 3){
       _card_img = @"card_ae02";
    }
    return _card_img;
}

+(void)getCardListWith:(DataBlock)block{
    [HttpTool postWithAPI:@"client/member/card/index" withParams:@{} success:^(id json) {
        NSLog(@"信用卡列表 =======  %@",json);
        if (ISPostSuccess) {
            NSArray *arr = [MineBankModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            block(arr,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(nil,NOTCONNECT_STR);
    }];
}

+(void)bindBankCardWith:(NSDictionary *)info block:(MsgBlock)block{
    [HttpTool postWithAPI:@"client/member/card/bind" withParams:info success:^(id json) {
        NSLog(@"绑定信用卡 =======  %@",json);
        if (ISPostSuccess) {
            block(YES, NSLocalizedString(@"绑定成功", NSStringFromClass([self class])));
        }else{
            block(NO,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(NO,NOTCONNECT_STR);
    }];
}

+(void)unbindBankCardWith:(NSString *)card_id block:(MsgBlock)block{
    [HttpTool postWithAPI:@"client/member/card/unbind" withParams:@{@"card_id":card_id} success:^(id json) {
        NSLog(@"解除绑定信用卡 =======  %@",json);
        if (ISPostSuccess) {
            block(YES, NSLocalizedString(@"解绑成功", NSStringFromClass([self class])));
        }else{
            block(NO,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        block(NO,NOTCONNECT_STR);
    }];
}
@end
