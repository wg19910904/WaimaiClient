//
//  WMShopGoodCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMShopGoodModel.h"

typedef void(^ProductNumChange)(UIView *fromView);
typedef void(^ChooseGoodSize)();// 选择规格商品

@interface WMShopGoodCell : UITableViewCell
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,copy)ProductNumChange productNumChange;
@property(nonatomic,copy)ChooseGoodSize chooseGoodSize;

-(void)reloadCellWithModel:(WMShopGoodModel *)model;
// 店内搜索的处理
-(void)reloadCellWithModel:(WMShopGoodModel *)model keyword:(NSString *)keyword;

-(void)countChange:(int)count;
@end
