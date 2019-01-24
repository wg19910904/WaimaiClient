//
//  ZQPhotoAlbumPickVC.h
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQPhotoAlbumPickVC : UIViewController

/**
 最多选择的个数
 */
@property(nonatomic,assign)NSInteger maxCount;
@property(nonatomic,copy)void(^resultBlock)(NSArray *modelArr);
@end
