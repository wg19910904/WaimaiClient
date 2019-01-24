//
//  JHWMPayOrderMoneyCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeStatus)(BOOL is_money);

@interface JHWMPayOrderMoneyCell : UITableViewCell
@property(nonatomic,copy)ChangeStatus changeStatus;
@property(nonatomic,assign)BOOL is_hidden_line;

-(void)relaodCellWith:(NSString *)order_money;

@end
