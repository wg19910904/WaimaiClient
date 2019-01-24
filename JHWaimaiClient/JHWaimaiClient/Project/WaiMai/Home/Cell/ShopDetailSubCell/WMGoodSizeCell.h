//
//  WMGoodSizeCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/23.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMGoodSizeCell : UICollectionViewCell
// 商品属性
@property(nonatomic,assign)BOOL is_property;

-(void)reloadCellWith:(NSString *)sizeStr is_selected:(BOOL)selected;

@end
