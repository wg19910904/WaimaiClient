//
//  ZQConditionCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQConditionCell : UITableViewCell
@property(nonatomic,copy)NSString *text;
@property(nonatomic,assign)BOOL isSelector;
@property(nonatomic,assign)BOOL isClass;
@property(nonatomic,assign)BOOL isArea;
@end
