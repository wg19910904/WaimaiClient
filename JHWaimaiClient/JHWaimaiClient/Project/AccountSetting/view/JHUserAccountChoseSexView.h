//
//  JHUserAccountChoseSexView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHUserAccountChoseSexView : UIControl
@property(nonatomic,copy)void(^myBlock)(NSInteger sex);
@property(nonatomic,copy)NSString * sex;//0为男,1是女,nil就是第一次选择
-(void)showSexView;
@end
