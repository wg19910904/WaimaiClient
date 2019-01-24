//
//  JHWaimaiMineAddressListDetailModel.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWaimaiMineAddressListDetailModel : NSObject
@property(nonatomic,copy)NSString * addr_id;//地址ID
@property(nonatomic,copy)NSString * uid;//会员ID
@property(nonatomic,copy)NSString * contact;//联系人
@property(nonatomic,copy)NSString * mobile;//联系电话
@property(nonatomic,copy)NSString * addr;//地址
@property(nonatomic,copy)NSString * house;//小区门牌
@property(nonatomic,copy)NSString * is_default;//是否为默认地址 1：默认地址
@property(nonatomic,copy)NSString * lat;//坐标纬度
@property(nonatomic,copy)NSString * lng;//坐标经度
@property(nonatomic,copy)NSString * type;//1:公司,2:家,3:学校,4:其他
@property(nonatomic,copy)NSString *typeName;//1:公司,2:家,3:学校,4:其他
@property(nonatomic,copy)NSString *typeColor;//背景色
@property(nonatomic,copy)NSString *is_in;//是否可以选中
@property(nonatomic,copy)NSString *min_price;//起送价
@property(nonatomic,copy)NSString *shipping_fee;//配送费

#pragma mark ====== 跑腿地址需要的属性 =======
@property(nonatomic,assign)int is_available;// 是否在配送范围 1：是 0：否

@end
