//
//  YFTextField.m
//  baocmsAPP
//
//  Created by jianghu3 on 15/12/31.
//  Copyright © 2015年 jianghu3. All rights reserved.
//

#import "YFTextField.h"

@implementation YFTextField

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += _ignoreLeftMargin ? 0 : _letfMargin;;// 左偏
    return iconRect;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x -=  _ignoreRightMargin ? 0 : _rightMargin;//  右偏
    return iconRect;
}

-(id)initWithFrame:(CGRect)frame leftView:(UIView *)leftView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame rightView:(UIView *)rightView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rightView = rightView;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame leftView:(UIView *)leftView rightView:(UIView *)rightView{
    
    self = [super initWithFrame:frame];
    if (self){
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightView=rightView;
        self.rightViewMode=UITextFieldViewModeAlways;
    }
    return self;
}

-(UIColor *)placeholdeColor{
    if (_placeholdeColor==nil) {
        _placeholdeColor=[UIColor blackColor];
    }
    return _placeholdeColor;
}

-(UIFont *)placeholdeFont{
    if (!_placeholdeFont) {
        _placeholdeFont = self.font;
    }
    return _placeholdeFont;
}

-(void)setPlaceholder:(NSString *)placeholder{
    [super setPlaceholder:placeholder];
    
    NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = self.font.lineHeight/2.0 + self.placeholdeFont.lineHeight / 2.0;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                                 attributes:@{             NSParagraphStyleAttributeName : style,
                                                                                                           NSForegroundColorAttributeName : self.placeholdeColor,
                                                                                                           NSFontAttributeName : self.placeholdeFont} ];
}

@end
