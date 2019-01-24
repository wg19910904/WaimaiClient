//
//  ZQAlbumModel.h
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface ZQAlbumModel : NSObject
@property(nonatomic,copy)NSString *name;//相册的名称
@property(nonatomic,assign)NSInteger count;//相册的个数
@property(nonatomic,strong)PHFetchResult *result;//相册的内容
@end
