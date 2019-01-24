//
//  YFCollectionViewLayout.h
//  LayoutTest
//
//  Created by ios_yangfei on 16/11/23.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YFCollectionViewLayoutDelegate <NSObject>

@required
/**
 *  每个item的尺寸
 *
 *  @param indexPath 所在的分组
 *
 *  @return item的尺寸
 */
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath;

/**
 每个section的headerView的大小
 
 @param section 分区
 @return 返回section的headerView的大小
 */

@optional
-(CGSize)collectionViewSectionHeadSizeForSection:(NSInteger)section;


@end

@interface YFCollectionViewLayout : UICollectionViewFlowLayout
@property(nonatomic,weak)id <YFCollectionViewLayoutDelegate>delegate;
/**
 * 每行的item个数
 */
@property (nonatomic, assign)int lineItems;

/**
 *  每个item的间隔
 */
@property (nonatomic, assign)CGFloat interSpace;

// 获取竖直方向滑动时的每个分区的y值
-(CGFloat)getSectionY:(NSInteger)section;

@end
