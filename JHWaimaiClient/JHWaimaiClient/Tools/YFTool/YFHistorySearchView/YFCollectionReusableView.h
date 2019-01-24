//
//  YFCollectionReusableView.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteHistory)();

@interface YFCollectionReusableView : UICollectionReusableView
@property(nonatomic,copy)DeleteHistory deleteHistory;
@property (nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *titleImg;
@property(nonatomic,assign)BOOL hidden_delete;
@end
