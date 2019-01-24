//
//  ZQPhotoModelTool.m
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQPhotoModelTool.h"
@implementation ZQPhotoModelTool
/**
 将十六进制的转化为颜色
 
 @param hexValue 十六进制的颜色字符串
 @param alpha 透明度(0~1)
 @return 转化后的颜色对象
 */
+(UIColor *)colorWithHex:(NSString *)hexValue
                   alpha:(CGFloat)alpha{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    range.location =0;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green/255.0f)
                            blue:(float)(blue/255.0f)
                           alpha:alpha];
}
/**
 获取所有的相册信息
 
 @param block 返回获取到的相册信息模型数组
 */
+(void)loadAlbumInfoWithBlock:(void(^)(NSArray * albumArr))block{
    NSMutableArray *albumArr = @[].mutableCopy;
    //创建读取哪些相册的subType
    PHAssetCollectionSubtype subType = PHAssetCollectionSubtypeAlbumRegular;
    //获取所有相册的信息
    PHFetchResult *albumsCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:subType options:nil];
    //遍历albumsCollection获取每一个相册的具体信息
    [albumsCollection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //将obj转化为某个具体类型 PHAssetCollection 代表一个相册
        PHAssetCollection *collection = (PHAssetCollection *)obj;
        //创建获取相册信息的options
        PHFetchOptions *options = [[PHFetchOptions alloc]init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        //读取相册里面的所有信息 PHFetchResult <PHAsset *>
        PHFetchResult *assetsResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (assetsResult.count > 0) {
            ZQAlbumModel *model = [ZQAlbumModel new];
            model.name = collection.localizedTitle;
            model.count = assetsResult.count;
            model.result = assetsResult;
            [albumArr addObject:model];
        }
    }];
    if (block) {
        block(albumArr);
    }
}

/**
 获取相册的原始图片
 @param asset 传入的asset
 @param block 回调结果
 */
+(void)getOriginImageWithAsset:(PHAsset *)asset
                         block:(void(^)(UIImage *image))block{
    //创建异步读取图片的选项options
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = NO;
    PHCachingImageManager *cacheImageManager = [[PHCachingImageManager alloc] init];
    [cacheImageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (block) {
            block(result);
        }
    }];
}
/**
 获取某一个asset的缩略图片
 
 @param asset 传入的asset
 @param block 回调结果
 */
+(void)getScaleImageWithAsset:(PHAsset *)asset
                        block:(void(^)(UIImage *image))block{
    //创建异步读取图片的选项options
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = NO;
    PHCachingImageManager *cacheImageManager = [[PHCachingImageManager alloc] init];
    [cacheImageManager requestImageForAsset:asset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (block) {
            block(result);
        }
    }];
}
//改变图片的尺寸大小
+(UIImage * )scaleFromImage:(UIImage*)img scaledToSize:(CGSize)newSize{
    CGSize imageSize = img.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <= newSize.width && height <= newSize.height){
        return img;
    }
    if (width == 0 || height == 0){
        return img;
    }
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    UIGraphicsBeginImageContext(targetSize);
    [img drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
