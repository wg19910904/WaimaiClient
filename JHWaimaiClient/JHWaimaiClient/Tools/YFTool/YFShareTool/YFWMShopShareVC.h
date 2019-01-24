//
//  YFWMShopShareVC.h
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/21.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "WMShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFWMShopShareVC : JHBaseVC
@property(nonatomic,weak)JHBaseVC *superVC;
@property(nonatomic,strong)WMShopModel *shop;
@end

NS_ASSUME_NONNULL_END
