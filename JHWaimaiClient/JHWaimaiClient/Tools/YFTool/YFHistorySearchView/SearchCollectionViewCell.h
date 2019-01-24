//
//  SearchCollectionViewCell.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak)UILabel *titleLab;
-(void)reloadCellWith:(NSString *)title;

@end
