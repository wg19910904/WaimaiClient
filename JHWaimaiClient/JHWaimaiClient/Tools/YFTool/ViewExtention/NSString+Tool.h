//
//  NSString+Tool.h
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/30.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)

/**
 *  将字典转换为json字符串
 *
 *  @param dic 需要装换成json字符串的字典
 *
 *  @return json字符串
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

/**
 *  md5加密
 *
 *  @param input 需要加密的str
 *
 *  @return MD5加密后的str
 */
+(NSString *)md5HexDigest:(NSString *)input;


/**
 获取时间戳

 @param date 需要获取时间戳的时间
 @param formate 时间的格式
 @return 时间戳
 */
+(NSInteger)getDatelineOfDate:(NSString *)date formate:(NSString *)formate;

/**
 *  距离现在多长时间
 *
 *  @param unixTime 时间戳
 *
 *  @return 在当前时间之前多久的时间
 */
+(NSString *)distanceTimeFormNow:(NSInteger)unixTime;

/**
 *  截取小数点后两位
 *
 *  @param str 需要截取的字符串
 *
 *  @return 返回的值
 */
+(NSString *)getFloatString:(NSString *)str;

/**
 根据自己需要的时间格式获取时间
 @"yyyy-MM-dd HH:mm"
 @param formate 时间格式
 @param unixTime 时间戳
 @return 返回格式化后的时间
 */
+(NSString *)formateDate:(NSString *)formate dateline:(NSInteger)unixTime;

/**
 获取AttributeString
 
 @param str 未处理过的str
 @param attributeDic 需要添加的属性
 @return 返回ttributeString
 */
+(NSAttributedString *)getAttributeString:(NSString *)str strAttributeDic:(NSDictionary *)attributeDic;

/**
 获取AttributeString
 
 @param str 完整的str
 @param dealStr 需要处理的str
 @param attributeDic 需要添加的属性
 @return 返回ttributeString
 */
+(NSAttributedString *)getAttributeString:(NSString *)str dealStr:(NSString *)dealStr strAttributeDic:(NSDictionary *)attributeDic;

/**
 给AttributeString添加属性
 
 @param str 完整的str
 @param dealStr 需要处理的str
 @param attributeDic 需要添加的属性
 @return 返回ttributeString
 */
+(NSAttributedString *)addAttributeString:(NSAttributedString *)str dealStr:(NSString *)dealStr strAttributeDic:(NSDictionary *)attributeDic;

// 获取价格的AttributeString
+(NSAttributedString *)priceLabText:(NSString *)money attributeFont:(float)font;

// 获取带有行间距的字符串
+(NSAttributedString *)getParagraphStyleAttributeStr:(NSString *)str lineSpacing:(float)lineSpace;

// 获取带有行间距的字符串
+(NSAttributedString *)addParagraphStyleAttributeStrWithAttributeStr:(NSAttributedString *)attStr lineSpacing:(float)lineSpace;

/**
 处理带小数的字符串 3.50 -> 3.5  3.00 -> 3
 
 @param ft 需要处理的小数
 @param bitCount 最多保留的小数位数
 @return 处理好的字符串
 */
+(NSString *)getStrFromFloatValue:(float)ft bitCount:(int)bitCount;

/**
 获取url中的单个参数（url格式  http://waimai.o2o.jhcms.cn/shop/detail.html?abc=jsdlfjlsd）

 @param urlStr url
 @param param 参数名
 @return 参数对应的值
 */
+(NSString *)getSingleParamFormUrlStr:(NSString *)urlStr param:(NSString *)param;


/**
  获取url中的所有参数（url格式  http://waimai.o2o.jhcms.cn/shop/detail.html?abc=jsdlfjlsd）

 @param urlStr url
 @return 所有参数字典
 */
+(NSDictionary *)getParamsFormUrlStr:(NSString *)urlStr;

/**
 改变图片的大小
 
 @param img     传入需要改变的图片
 @param newSize 新的尺寸
 
 @return 返回新的图片
 */
+(UIImage * )scaleFromImage:(UIImage*)img scaledToSize:(CGSize)newSize;
@end
