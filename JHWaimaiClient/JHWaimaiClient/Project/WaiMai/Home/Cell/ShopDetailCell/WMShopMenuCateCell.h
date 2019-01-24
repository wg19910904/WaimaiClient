//
//  WMShopCateCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMShopCateModel.h"

@interface WMShopMenuCateCell : UITableViewCell
-(void)reloadCellWithModel:(WMShopCateModel *)model;
// 当前分类下选择的商品个数发生变化
-(void)countChange:(BOOL)is_add;
@end
