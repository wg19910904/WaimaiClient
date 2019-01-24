//
//  JHWaimaiMyBalanceListModel.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWaimaiMyBalanceListModel : NSObject
@property(nonatomic,copy)NSString *money;//当前帐户余额
@property(nonatomic,copy)NSString *total_count;//总共的信息数
@property(nonatomic,strong)NSArray *items;


@end
