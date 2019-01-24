//
//  ShopCartOfShopCollectionCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMShopGoodModel.h"

@interface ShopCartOfShopCollectionCell : UICollectionViewCell
-(void)reloadCellWithModel:(WMShopGoodModel *)model;
@end
