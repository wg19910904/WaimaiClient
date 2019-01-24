//
//  ZQChoseImageVC.h
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQPhotoModelTool.h"
@interface ZQChoseImageVC : UIViewController
/**
 最多选择的个数
 */
@property(nonatomic,assign)NSInteger maxCount;

/**
 传入的相册的内容
 */
@property(nonatomic,strong)PHFetchResult *result;
@end
