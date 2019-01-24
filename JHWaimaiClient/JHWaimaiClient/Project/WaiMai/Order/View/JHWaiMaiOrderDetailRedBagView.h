//
//  JHWaiMaiOrderDetailRedBagView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/9/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWaiMaiOrderDetailRedBagView : UIControl
@property(nonatomic,copy)NSString *titleL;
@property(nonatomic,copy)NSString *alertTitle;
@property(nonatomic,copy)void(^clickBlock)(void);
-(void)showView;
@end
