//
//  JHWMBankCardListVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@class MineBankModel;

@interface JHWMBankCardListVC : JHBaseVC
@property(nonatomic,assign)BOOL is_choose;
@property(nonatomic,copy)NSString *card_id;
@property(nonatomic,copy)ModelBlock chooseBank;

@end
