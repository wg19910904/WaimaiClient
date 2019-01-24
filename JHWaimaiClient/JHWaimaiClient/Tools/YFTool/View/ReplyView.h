//
//  ReplayView.h
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/30.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyView : UIView
@property(nonatomic,copy)NSString *timeStr;
@property(nonatomic,copy)NSString *replyStr;
@property(nonatomic,assign)BOOL is_shoper;//是不是商家回复
@property(nonatomic,assign)NSInteger numberOfLines;
@end
