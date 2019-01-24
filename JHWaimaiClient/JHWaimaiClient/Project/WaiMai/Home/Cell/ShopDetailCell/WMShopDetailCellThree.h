//
//  WMShopDetailCellThree.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"

@interface WMShopDetailCellThree : UITableViewCell

@property(nonatomic,weak)JHBaseVC *superVC;
-(void)reloadCellWith:(NSString *)title imgArr:(NSArray *)imgArr;

@end
