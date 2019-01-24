//
//  JHWaiMaiAddressListCell.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaimaiMineAddressListDetailModel.h"
@interface JHWaiMaiAddressListCell : UITableViewCell

-(void)reloadCellWithModel:(JHWaimaiMineAddressListDetailModel *)model is_choose_paotui:(BOOL)is_choose_paotui;
@property(nonatomic,strong)UIButton *editBtn;
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,copy)NSString *addr_id;
@end
