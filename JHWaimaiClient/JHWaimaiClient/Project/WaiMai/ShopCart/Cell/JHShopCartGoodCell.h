//
//  JHShopCartGoodCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/8/16.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"
#import "WMShopGoodModel.h"

@interface JHShopCartGoodCell : YFBaseTableViewCell
-(void)reloadCellWithModel:(WMShopGoodModel *)model;
@end
