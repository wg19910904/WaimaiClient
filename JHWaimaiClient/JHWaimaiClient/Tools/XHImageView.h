//
//  XHImageView.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHImageView : UIImageView
@property(nonatomic,assign)NSUInteger badgeNum;
- (void)addTarget:(id _Nullable )target action:(nullable SEL)selector;
@end
