//
//  JHWaimaiOrderDetailDefaultCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWaimaiOrderDetailDefaultCell : UITableViewCell
@property(nonatomic,copy)NSString *leftTitle;//左边的标题
@property(nonatomic,copy)NSString *rightTitle;//右边的标题
@property(nonatomic,strong)UILabel *leftLabel;//左边的显示
@property(nonatomic,strong)UILabel *rightLabel;//右边的显示
@property(nonatomic,assign)BOOL isHidden;//是否隐藏底部的线
@end
