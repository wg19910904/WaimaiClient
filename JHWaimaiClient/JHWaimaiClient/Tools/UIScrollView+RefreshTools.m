//
//  UIScrollView+Tools.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/9/6.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "UIScrollView+RefreshTools.h"
#import "KafkaRefresh.h"
#import "KafkaRingIndicatorHeader.h"
#import "KafkaNativeFooter.h"

@implementation UIScrollView (RefreshTools)

- (void)bindHeadRefreshHandler:(XHRefreshHandler)block{
    __kindof KafkaRefreshControl *head = nil;
    head = [[KafkaRingIndicatorHeader alloc] init];
    head.KafkaRefreshHeight = 64;
    head.refreshHandler = block;
    head.themeColor = HEX(@"ababab", 1.0);
    self.headRefreshControl = head;
}

- (void)bindFootRefreshHandler:(KafkaRefreshHandler)block {
    __kindof KafkaFootRefreshControl *foot = nil;
    foot = [[KafkaNativeFooter alloc] init];
    foot.KafkaRefreshHeight = 30;
    foot.themeColor = HEX(@"ababab", 1.0);
    foot.refreshHandler = block;
    self.footRefreshControl = foot;
}

- (void)endRefresh{
    [self.headRefreshControl endRefreshing];
    [self.footRefreshControl endRefreshing];
}
- (void)removeHeadRefresh{
    self.headRefreshControl = nil;
}
- (void)removeFootRefresh{
    self.footRefreshControl = nil;
}
- (BOOL)isRefresh{
    return self.footRefreshControl.refresh;
}
@end
