//
//  WaiMaiSpecialAdCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/4.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickAdIndex)(NSInteger index);

@interface WaiMaiSpecialAdCell : UITableViewCell
@property(nonatomic,copy)ClickAdIndex clickAd;
-(void)reloadCellWithArr:(NSArray *)ads;
@end
