//
//  JHWMAddBankCardVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "MineBankModel.h"

@interface JHWMAddBankCardVC : JHBaseVC
@property(nonatomic,strong)MineBankModel *model;
@property(nonatomic,copy)MsgBlock successBlock;
@end
