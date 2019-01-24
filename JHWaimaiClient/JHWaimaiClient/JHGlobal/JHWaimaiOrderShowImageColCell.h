//
//  JHWaimaiOrderShowImageColCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWaimaiOrderShowImageColCell : UICollectionViewCell
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,assign)BOOL hiddenRemove;
@property(nonatomic,copy)void(^removeBlock)();
@end
