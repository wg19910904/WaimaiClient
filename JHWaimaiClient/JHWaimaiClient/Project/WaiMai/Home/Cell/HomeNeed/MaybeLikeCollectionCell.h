//
//  MaybeLikeCollectionCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/4/28.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaybeLikeGood.h"

@interface MaybeLikeCollectionCell : UICollectionViewCell
-(void)reloadCellWithModel:(MaybeLikeGood *)model showCount:(BOOL)show;
@end
