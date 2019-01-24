//
//  UILabel+XHTool.m
//  XHToolkit_OC
//
//  Created by xixixi on 16/12/24.
//  Copyright © 2016年 xixixi. All rights reserved.
//

#import "UILabel+XHTool.h"

@implementation UILabel (XHTool)


- (void)setColor:(UIColor *)color string:(NSString *)string{
    if (![self.text containsString:string]) return;
    NSMutableAttributedString *attStr = self.attributedText.mutableCopy;
    NSRange range = [self.text rangeOfString:string];
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:color
                   range:range];
    self.attributedText = attStr;
}

- (void)setFont:(UIFont *)font string:(NSString *)string{
    if (![self.text containsString:string]) return;
    NSMutableAttributedString *attStr = self.attributedText.mutableCopy;
    NSRange range = [self.text rangeOfString:string];
    [attStr addAttribute:NSFontAttributeName
                   value:font
                   range:range];
    self.attributedText = attStr;
}

- (void)setLineSpacing:(CGFloat)lineSpace{

    NSMutableAttributedString *attStr = self.attributedText.mutableCopy;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //调整行间距
    [paragraphStyle setLineSpacing:lineSpace];
    [attStr addAttribute:NSParagraphStyleAttributeName
                   value:paragraphStyle
                   range:NSMakeRange(0, [self.text length])];
    self.attributedText = attStr;
}
@end
