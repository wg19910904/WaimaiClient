//
//  JHWaimaiOrderDetailSubmitImageCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaimaiOrderDetailComplaintVC.h"
#import "ZQImageModel.h"
@interface JHWaimaiOrderDetailSubmitImageCell : UITableViewCell
@property(nonatomic,weak)JHWaimaiOrderDetailComplaintVC * superVC;
@property(nonatomic,strong)NSArray *modelArr;
@property(nonatomic,copy)void(^removeBlock)(NSInteger index);
@end
