//
//  JHWaimaiOrderDetailZitimaView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/31.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWaimaiOrderDetailZitimaView : UIControl
@property(nonatomic,copy)NSString*code;
@property(nonatomic,assign)NSInteger  ziti_status;
-(void)showView;
-(void)hiddenView;
@end
