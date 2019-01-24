//
//  WaiMaiShoperCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHomeShopModel.h"

typedef void(^ClickShowMore)();
typedef void(^GoShopDetail)(NSString *good_id);

@interface WaiMaiShoperCell : UITableViewCell
@property(nonatomic,copy)GoShopDetail goShopDetail;
@property(nonatomic,copy)ClickShowMore clickShowMore;
-(void)reloadCellWithModel:(WMHomeShopModel *)model;
-(void)reloadActivityTableView:(BOOL)showMore;
@end
