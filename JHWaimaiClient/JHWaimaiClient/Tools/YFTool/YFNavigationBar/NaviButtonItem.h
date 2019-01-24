//
//  ButtonItemView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2017/9/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NaviButtonItemType) {
    NaviButtonItemTypeLeft = 0,
    NaviButtonItemTypeRight
};

@interface NaviButtonItem : UIView
@property(nonatomic,assign)NaviButtonItemType type;
@end
