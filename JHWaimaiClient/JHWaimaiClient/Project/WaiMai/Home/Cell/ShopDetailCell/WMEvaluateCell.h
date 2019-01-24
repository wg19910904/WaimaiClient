//
//  WMEvaluateCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMEvaluateModel.h"
#import "JHBaseVC.h"

@interface WMEvaluateCell : UITableViewCell

@property(nonatomic,weak)JHBaseVC *superVC;
-(void)reloadCellWithModel:(WMEvaluateModel *)model;
@end
