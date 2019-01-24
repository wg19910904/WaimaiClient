//
//  JHWaimaiOrderSeeEvaluationHeaderCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaimaiOrderSeeEvaliationModel.h"
@interface JHWaimaiOrderSeeEvaluationHeaderCell : UITableViewCell
@property(nonatomic,strong)JHWaimaiOrderSeeEvaliationModel *model;
@property(nonatomic,weak)UIViewController * superVC;
@end
