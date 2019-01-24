//
//  JHWaiMaiHomeVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/3.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHWaiMaiHomeVC : JHBaseVC
- (void)clickFenlei:(UIButton *)sender;
- (void)toChooseAddr;
#pragma mark - 还原真实的高度
- (void)resetHomeTB_sectionHeight;
@end
