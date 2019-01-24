//
//  JHWaimaiShopStoreCloseView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShopShowStatusViewType) {
    ShopShowStatusViewCloseType,// 打烊
    ShopShowStatusViewDistanceType// 超出配送距离
};

@interface JHWMShopShowStatusView : UIView
@property(nonatomic,assign)ShopShowStatusViewType shopStatus;
-(void)showAnimation;
@end
