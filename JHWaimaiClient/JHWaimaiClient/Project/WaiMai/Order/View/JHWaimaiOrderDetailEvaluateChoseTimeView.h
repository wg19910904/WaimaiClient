//
//  JHWaimaiOrderDetailEvaluateChoseTimeView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWaimaiOrderDetailEvaluateChoseTimeView : UIControl
@property(nonatomic,strong)NSArray *timeArr;
-(void)showView;
@property(nonatomic,copy)void(^myBlock)(NSString *timeL,NSInteger index_minute);
@end
