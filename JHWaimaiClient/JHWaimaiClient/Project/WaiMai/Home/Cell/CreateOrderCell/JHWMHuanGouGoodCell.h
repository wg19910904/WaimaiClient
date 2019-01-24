//
//  JHWMHuanGouGoodCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/28.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"
#import "WMShopGoodModel.h"

@interface JHWMHuanGouGoodCell : YFBaseTableViewCell
@property(nonatomic,copy)ModelBlock chooseGoodReloadBlock;// 选择商品后需要刷新界面
-(void)reloadCellWithModel:(WMShopGoodModel *)model;
@end
