//
//  JHWaiMaiAddAddressTagCell.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWaiMaiAddAddressTagCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleL;
@property(nonatomic,strong)UIButton *selectedBtn; //选中的按钮
@property(nonatomic,copy)void(^myBlock)(NSInteger tag);
@property(nonatomic,assign)NSInteger index;
@end
