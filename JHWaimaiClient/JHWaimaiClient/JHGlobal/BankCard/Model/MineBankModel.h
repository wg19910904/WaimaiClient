//
//  MineBankModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineBankModel : NSObject
@property(nonatomic,copy)NSString *card_id;
@property(nonatomic,copy)NSString *card_name;
@property(nonatomic,assign)int card_type;       // 1:Visa,2:MasterCard,3:American Express
@property(nonatomic,copy)NSString *card_number;
@property(nonatomic,copy)NSString *exp_month;
@property(nonatomic,copy)NSString *exp_year;
@property(nonatomic,copy)NSString *cvc;             // 安全码
@property(nonatomic,copy)NSString *card_label;

#pragma mark ====== 自己添加的属性=======
@property(nonatomic,copy)NSString *card_img;
/**
 获取信用卡列表

 @param block       回调的block
 */
+(void)getCardListWith:(DataBlock)block;


/**
 绑定信用卡

 @param info        信用卡的信息
 @param block       回调的block
 */
+(void)bindBankCardWith:(NSDictionary *)info block:(MsgBlock)block;


/**
 解除绑定

 @param card_id     信用卡id
 @param block       回调的block
 */
+(void)unbindBankCardWith:(NSString *)card_id block:(MsgBlock)block;
@end
