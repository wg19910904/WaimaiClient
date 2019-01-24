//
//  JHSearchResultOfGoods.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "HistorySearchView.h"

@interface JHSearchResultOfGoods : JHBaseVC
@property(nonatomic,weak)HistorySearchView *historySearchView;
// 根据搜索关键词搜索内容
-(void)getDataWithKeyword:(NSString *)keyword;
@end
