//
//  FilterCollectionView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

// 点击的回调
typedef void(^ChooseBlock)(NSInteger first,NSInteger second,NSInteger third);

@interface FilterCollectionView : UIView
@property(nonatomic,strong)NSArray *firstArr;
@property(nonatomic,strong)NSArray *secondArr;
@property(nonatomic,strong)NSArray *thirdArr;
@property(nonatomic,copy)ChooseBlock chooseBlock;
// 刷新CollectionView
-(void)reloadCollectionViews;

@end
