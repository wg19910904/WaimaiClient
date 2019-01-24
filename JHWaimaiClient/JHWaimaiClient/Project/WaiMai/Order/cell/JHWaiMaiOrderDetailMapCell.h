//
//  JHWaiMaiOrderDetailMapCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaimaiOrderDetailModel.h"
@interface JHWaiMaiOrderDetailMapCell : UITableViewCell
@property(nonatomic,weak)UIViewController *superVC;
-(void)reloadCellWithModel:(JHWaimaiOrderDetailModel *)model;
@end
