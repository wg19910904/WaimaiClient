//
//  XHGaodePlacePickerCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2018/8/14.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHLocationInfo.h"

@interface XHGaodePlacePickerCell : UITableViewCell

-(void)reloadModel:(XHLocationInfo *)model showImg:(BOOL)is_show searchWord:(NSString *)str isSearch:(BOOL)is_search;
@end
