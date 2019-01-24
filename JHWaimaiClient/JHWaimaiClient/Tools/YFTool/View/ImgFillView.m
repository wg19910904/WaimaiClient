//
//  ImgFillView.m
//  testContext
//
//  Created by jianghu3 on 16/2/27.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "ImgFillView.h"

@implementation ImgFillView

-(void)setImgName:(NSString *)imgName{
    _imgName=imgName;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:_imgName];
    // 利用drawAsPatternInRec方法绘制图片到layer, 是通过平铺原有图片
    [image drawAsPatternInRect:rect];
}

@end
