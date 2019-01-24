//
//  WMShopCartOfShopCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickDeleteShopDB)();

@interface WMShopCartOfShopCell : UITableViewCell
@property(nonatomic,copy)MsgBlock showMoreGoodBlock;
@property(nonatomic,copy)ClickDeleteShopDB clickDeleteShopDB;
-(void)reloadCellWithModel:(WMShopDBModel *)model;
@end
