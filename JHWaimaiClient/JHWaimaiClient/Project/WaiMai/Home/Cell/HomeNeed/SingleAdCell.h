//
//  SingleAdCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/4/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickAd)();

@interface SingleAdCell : UITableViewCell
@property(nonatomic,copy)ClickAd clickAd;

-(void)reloadCellWithImgUrl:(NSString *)url;
@end
