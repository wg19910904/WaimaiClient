//
//  JHWaimaiOrderEvaluateHeaderCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFStartView.h"
@interface JHWaimaiOrderEvaluateHeaderCell : UITableViewCell
@property(nonatomic,copy)NSString *imgUrl;//商家头像的链接
@property(nonatomic,copy)NSString *shopName;//商家姓名
@property(nonatomic,strong)UITextView *textView;//输入框
@property(nonatomic,strong)YFStartView *starView;//可以用来评价的星星
@end
