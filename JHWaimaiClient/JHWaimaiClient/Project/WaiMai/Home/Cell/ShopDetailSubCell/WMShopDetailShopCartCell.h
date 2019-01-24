//
//  WMShopDetailShopCartCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/18.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMShopGoodModel.h"

typedef void(^CountChangeBlock)(BOOL is_add);

@interface WMShopDetailShopCartCell : UITableViewCell
@property(nonatomic,copy)CountChangeBlock block;
-(void)reloadCellWithModel:(WMShopGoodModel *)model isCou:(BOOL)is_cou;
@end
