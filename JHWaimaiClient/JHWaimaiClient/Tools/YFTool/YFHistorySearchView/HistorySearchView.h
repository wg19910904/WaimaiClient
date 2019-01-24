//
//  HistorySearchView.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTitle)(NSString *title);

@interface HistorySearchView : UIView

@property(nonatomic,copy)ClickTitle clickTitle;

// 搜索历史的存储路径
@property(nonatomic,copy)NSString *historyCashDataFilePath;

// 热门搜索的路径
@property(nonatomic,copy)NSString *hotSearchUrl;

// 添加搜索历史
-(void)searchHistoryAddStr:(NSString *)str;

// 清除搜索历史
-(void)clearSearchHistory;
@end
