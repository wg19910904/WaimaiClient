//
//  UIColor+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "UIColor+Util.h"


@implementation UIColor (Util)

#pragma mark - Hex

+ (UIColor *)colorWithHex:(NSString *)hexValue alpha:(CGFloat)alpha
{
    
    NSString * str1 = [NSString stringWithFormat:@"%@ffffff",hexValue];
    
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    range.location =0;
    [[NSScanner scannerWithString:[str1 substringWithRange:range]] scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[str1 substringWithRange:range]] scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[str1 substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green/255.0f)
                            blue:(float)(blue/255.0f)
                           alpha:alpha];
}

+ (UIColor *)randomColor{
    return  [UIColor colorWithRed:(float)(arc4random() % 255 /255.0f)
                            green:(float)(arc4random() % 255 /255.0f)
                             blue:(float)(arc4random() % 255 /255.0f)
                            alpha:1.0];
}
@end
