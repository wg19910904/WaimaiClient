//
//  ZQPhotoModelTool.h
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQAlbumModel.h"
#import "ZQImageModel.h"
@interface ZQPhotoModelTool : NSObject

/**
 将十六进制的转化为颜色

 @param hexValue 十六进制的颜色字符串
 @param alpha 透明度(0~1)
 @return 转化后的颜色对象
 */
+(UIColor *)colorWithHex:(NSString *)hexValue
                   alpha:(CGFloat)alpha;

/**
 获取所有的相册信息

 @param block 返回获取到的相册信息模型数组
 */
+(void)loadAlbumInfoWithBlock:(void(^)(NSArray * albumArr))block;

/**
 获取某一个asset的原始图片

 @param asset 传入的asset
 @param block 回调结果
 */
+(void)getOriginImageWithAsset:(PHAsset *)asset
                   block:(void(^)(UIImage *image))block;
/**
 获取某一个asset的缩略图片
 
 @param asset 传入的asset
 @param block 回调结果
 */
+(void)getScaleImageWithAsset:(PHAsset *)asset
                         block:(void(^)(UIImage *image))block;
/**
 改变图片的大小
 
 @param img     传入需要改变的图片
 @param newSize 新的尺寸
 
 @return 返回新的图片
 */
+(UIImage * )scaleFromImage:(UIImage*)img scaledToSize:(CGSize)newSize;
@end
