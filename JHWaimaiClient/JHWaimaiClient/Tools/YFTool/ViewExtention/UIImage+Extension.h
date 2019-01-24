//
//  UIImage+Extension.h
//  JHCash
//
//  Created by ios_yangfei on 16/10/29.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)


/**
 tabbar图片的处理

 @param name 图片名称
 @return 处理后的图片
 */
+ (UIImage *)originImageWithName: (NSString *)name ;

/**
 *  通过颜色获取图片
 *
 *  @param color 颜色
 *
 *  @return 返回的颜色图片
 */
+ (UIImage*)imageWithColor:(UIColor*)color;

/**
 *  话虚线
 *
 *  @param frame 范围
 *
 *  @return 虚线图
 */
+ (UIImage *)drawLineByRect:(CGRect)frame;

/**
 *  生成二维码
 *
 *  @param codeStr 需要生成的字符串
 *  @param imgName 中间的图片
 *
 *  @return  二维码图片
 */
+(UIImage *)createCoreImage:(NSString *)codeStr centerImg:(NSString *)imgName;

/**
 *  压缩图片的尺寸
 *
 *  @param img     需要压缩的图片
 *  @param newSize 想要压缩的尺寸
 *
 *  @return 返回压缩后的图片
 */
+(UIImage *)scaleFromImage:(UIImage *)img scaleToSize:(CGSize)newSize;

+ (UIImage *)convertViewToImage:(UIView *)view;
@end
