//
//  WaiMaiGoodCollectionCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHomeShopProducts.h"

@interface WaiMaiGoodCollectionCell : UICollectionViewCell
-(void)reloadCellWithModel:(WMHomeShopProducts *)model;
@end
