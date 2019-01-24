//
//  JHWaimaiRechargeMoneyCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaimaiRechargeMoneyModel.h"
@interface JHWaimaiRechargeMoneyCell : UICollectionViewCell
@property(nonatomic,copy)void(^myBlock)();
@property(nonatomic,strong)JHWaimaiRechargeMoneyModel *model;
@end
