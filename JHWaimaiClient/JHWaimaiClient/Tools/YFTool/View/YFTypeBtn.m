//
//  TypeBtn.m
//  RQCodeTest
//
//  Created by ios_yangfei on 16/12/2.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "YFTypeBtn.h"

#import "UIView+Extension.h"

@implementation YFTypeBtn

-(void)layoutSubviews{
    [super layoutSubviews];
        switch (_btnType) {
            case TopImage:
            {
                self.imageView.y = _imageMargin;
                self.imageView.centerX = self.width/2.0;
                self.titleLabel.y = self.imageView.height + _titleMargin + _imageMargin;
                self.titleLabel.width = self.width;
                self.titleLabel.centerX = self.width/2.0;
            
            }
                break;
            case LeftImage:
            {
                self.imageView.x = _imageMargin;
                self.imageView.centerY = self.height/2.0;
                self.titleLabel.x = self.imageView.width + _titleMargin + _imageMargin;
                self.titleLabel.centerY = self.height/2.0;
            }
                break;
            case RightImage:
            {
                self.titleLabel.x = _titleMargin;
                self.titleLabel.centerY = self.height/2.0;
                self.imageView.x = self.titleLabel.width + _titleMargin + _imageMargin;
                self.imageView.centerY = self.height/2.0;
    
            }
                break;
            case BottomImage:
            {
                self.titleLabel.y = _titleMargin;
                self.titleLabel.width = self.width;
                self.titleLabel.centerX = self.width/2.0;
                self.imageView.y = self.titleLabel.height + _titleMargin + _imageMargin;
                self.imageView.centerX = self.width/2.0;

            }
                break;
            case AllCenterImgageFront:
            {
  
                CGFloat margin = (self.width - self.titleLabel.width - self.imageView.width)/3.0;
                self.imageView.x = _imageMargin + margin;
                self.imageView.centerY = self.height/2.0;
                self.titleLabel.x = self.imageView.x + self.imageView.width + margin + _titleMargin;
                self.titleLabel.centerY = self.height/2.0;
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
                
            }
                break;
            case AllCenterTitleFront:
            {
                
                CGFloat margin = (self.width - self.titleLabel.width - self.imageView.width)/3.0;
                self.titleLabel.x = _titleMargin + margin;
                self.titleLabel.centerY = self.height/2.0;
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
                self.imageView.centerY = self.height/2.0;
                self.imageView.x = self.titleLabel.x + self.titleLabel.width + margin + _imageMargin ;
                
            }
                break;
            case TitleCenter:
            {
                CGFloat margin = (self.width - self.titleLabel.width - self.imageView.width)/2.0;
                self.titleLabel.x = _imageMargin + margin;
                self.titleLabel.centerY = self.height/2.0;
                self.imageView.centerY = self.height/2.0;
                self.imageView.x = self.titleLabel.x + self.titleLabel.width + _imageMargin;
                
            }
                break;
            case NormalType:
            {
                self.imageView.x = self.imageView.x + _imageMargin;
                self.imageView.centerY = self.height/2.0;
                self.titleLabel.x = self.imageView.x + self.imageView.width + _titleMargin + _imageMargin;
                self.titleLabel.centerY = self.height/2.0;
            }
                break;
        }
}

-(void)setTitleAlignment:(NSTextAlignment)titleAlignment{
    _titleAlignment = titleAlignment;
    self.titleLabel.textAlignment = titleAlignment;
}

-(void)setTitleMargin:(CGFloat)titleMargin{
    _titleMargin = titleMargin;
    [self layoutSubviews];
}

-(void)setImageMargin:(CGFloat)imageMargin{
    _imageMargin = imageMargin;
    [self layoutSubviews];
}

@end
