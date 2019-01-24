//
//  MineBankCardListCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineBankModel.h"

@interface MineBankCardListCell : UITableViewCell
-(void)reloadCellWithModel:(MineBankModel *)model is_choose:(BOOL)is_choose;
@end
