//
//  JHSkyHongBaoVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHSkyHongBaoVC : JHBaseVC
@property(nonatomic,strong)NSDictionary *hongBaoDic;
@property(nonatomic,copy)void(^getBlock)(void);
@end
