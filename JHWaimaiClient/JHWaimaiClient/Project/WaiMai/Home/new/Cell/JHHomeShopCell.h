//
//  JHHomeShopCell.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaimaiHomeShopModel.h"
#import "YFTypeBtn.h"

@interface JHHomeShopCell : UITableViewCell
@property(nonatomic,strong)JHWaimaiHomeShopModel *dataModel;

@property(nonatomic,strong)YFTypeBtn *huodongCountBtn; //展示活动的按钮

@end
