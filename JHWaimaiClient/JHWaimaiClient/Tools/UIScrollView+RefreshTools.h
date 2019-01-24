//
//  UIScrollView+RefreshTools.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/9/6.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XHRefreshHandler)(void);

@interface UIScrollView (RefreshTools)

- (void)bindHeadRefreshHandler:(XHRefreshHandler)block;


- (void)bindFootRefreshHandler:(XHRefreshHandler)block;

- (void)endRefresh;

- (void)removeHeadRefresh;

- (void)removeFootRefresh;

- (BOOL)isRefresh;
@end
