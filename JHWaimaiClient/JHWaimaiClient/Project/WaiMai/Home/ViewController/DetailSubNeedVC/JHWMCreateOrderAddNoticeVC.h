//
//  JHWMCreateOrderAddNoticeVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

typedef void(^ClickSure)(NSString *notice);

@interface JHWMCreateOrderAddNoticeVC : JHBaseVC
@property(nonatomic,copy)ClickSure clickSure;
@property(nonatomic,copy)NSString *notice;
@end
