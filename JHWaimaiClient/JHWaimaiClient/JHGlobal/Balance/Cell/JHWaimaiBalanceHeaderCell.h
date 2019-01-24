//
//  JHWaimaiBalanceHeaderCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWaimaiBalanceHeaderCell : UITableViewCell
@property(nonatomic,copy)void(^myBlock)();
@property(nonatomic,copy)NSString *money;
@end
