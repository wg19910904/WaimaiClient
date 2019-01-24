//
//  JHShopMenuTableHeaderView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/31.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMShopModel.h"

typedef void(^ClickMenuHeaderItem)(NSInteger index,BOOL is_adv);

@interface JHShopMenuTableHeaderView : UIView
@property(nonatomic,copy)ClickMenuHeaderItem clickItemBlock;
-(void)reloadViewWith:(WMShopModel *)shop;
@end
