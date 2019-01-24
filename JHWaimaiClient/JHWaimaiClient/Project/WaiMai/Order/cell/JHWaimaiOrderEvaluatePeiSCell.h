//
//  JHWaimaiOrderEvaluatePeiSCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFStartView.h"
@interface JHWaimaiOrderEvaluatePeiSCell : UITableViewCell
@property(nonatomic,copy)void(^myBlock)();
@property(nonatomic,copy)NSString *str;
@property(nonatomic,strong)YFStartView *starView;//评价的星星
@end
