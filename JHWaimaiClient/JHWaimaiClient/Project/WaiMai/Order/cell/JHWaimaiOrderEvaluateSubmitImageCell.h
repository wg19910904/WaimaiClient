//
//  JHWaimaiOrderEvaluateSubmitImageCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaimaiOrderDetailEvaluateVC.h"
#import "ZQImageModel.h"
@interface JHWaimaiOrderEvaluateSubmitImageCell : UITableViewCell
@property(nonatomic,weak)JHWaimaiOrderDetailEvaluateVC * superVC;
@property(nonatomic,strong)NSArray *modelArr;
@property(nonatomic,copy)void(^removeBlock)(NSInteger index);
@end
