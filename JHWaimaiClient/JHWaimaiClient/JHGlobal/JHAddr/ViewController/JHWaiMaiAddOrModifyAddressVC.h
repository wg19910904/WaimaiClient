//
//  JHWaiMaiAddAddressVC.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

typedef  NS_ENUM(NSUInteger,AddressVC_type){
    E_ModifyAddress_vc = 0,
    E_addAddress_vc,
};

#import "JHBaseVC.h"
#import "JHWaimaiMineAddressListDetailModel.h"
@interface JHWaiMaiAddOrModifyAddressVC : JHBaseVC

@property(nonatomic,assign) AddressVC_type vctype;
@property(nonatomic,strong)JHWaimaiMineAddressListDetailModel * detailModel;
@property(nonatomic,assign)BOOL is_paotui;// 跑腿地址
@end
