//
//  ZQChoseImageCell.h
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ZQImageModel.h"
@interface ZQChoseImageCell : UICollectionViewCell
@property(nonatomic,strong)PHAsset *asset;
@property(nonatomic,copy)void(^myBlock)(BOOL isSeletor,UIImage * image);
@property(nonatomic,strong)NSMutableArray * arr;
@property(nonatomic,assign)NSInteger maxNum;
@property(nonatomic,strong)ZQImageModel * model;
@property(nonatomic,weak)UIViewController * superVC;
@end
