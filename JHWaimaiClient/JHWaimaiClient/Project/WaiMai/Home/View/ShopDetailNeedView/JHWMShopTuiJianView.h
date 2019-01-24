//
//  JHWMShopTuiJianView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/8/3.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMShopGoodModel.h"

typedef void(^GoodCountChangeBlock)(id model,BOOL is_add);

@interface JHWMShopTuiJianView : UIView
@property(nonatomic,copy)ModelBlock goShopDetailBlock;
@property(nonatomic,copy)GoodCountChangeBlock goodCountChangeBlock;
@property(nonatomic,weak)UICollectionView *collectionView;
-(void)reloadViewWithGoodArr:(NSArray *)goodArr;

@end
