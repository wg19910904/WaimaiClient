//
//  YFCollectionViewAutoFlowLayout.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YFCollectionViewAutoFlowLayoutDelegate <NSObject>

@required
/**
 *  每个item的尺寸
 *
 *  @param indexPath 所在的分组
 *
 *  @return item的尺寸
 */
-(CGSize)collectionViewItemSizeForIndexPath:(NSIndexPath *)indexPath;


/**
 每个section的headerView的大小

 @param section 分区
 @return 返回section的headerView的大小
 */
-(CGSize)collectionViewSectionHeadSizeForSection:(NSInteger)section;

@end

@interface YFCollectionViewAutoFlowLayout : UICollectionViewFlowLayout

@property(nonatomic,weak)id <YFCollectionViewAutoFlowLayoutDelegate>delegate;

/**
 *  列数或者行数
 */
//@property (nonatomic, assign)NSInteger colOrLineNum;
/**
 *  每个item的间隔
 */
@property (nonatomic, assign)CGFloat interSpace;

@end
