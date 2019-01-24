//
//  JHWaimaiOrderShowImageColCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderShowImageColCell.h"
@interface JHWaimaiOrderShowImageColCell()
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UIButton *btn;
@end
@implementation JHWaimaiOrderShowImageColCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self imageV];
    }
    return self;
}
-(void)setImage:(UIImage *)image{
    _image = image;
    _imageV.image = image;
}
-(UIImageView *)imageV{
    float w = self.frame.size
    .width;
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.userInteractionEnabled = YES;
        [self addSubview:_imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset = 0;
        }];
        _btn = [[UIButton alloc]init];
        [_btn setBackgroundImage:IMAGE(@"icon-close") forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(clickRemove) forControlEvents:UIControlEventTouchUpInside];
        [_imageV addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset = w/2;
            make.top.offset = 0;
            make.left.offset = w/2;
        }];

    }
    return _imageV;
}
-(void)setHiddenRemove:(BOOL)hiddenRemove{
    _hiddenRemove = hiddenRemove;
    _btn.hidden = hiddenRemove;
}
-(void)clickRemove{
    if (_removeBlock) {
        _removeBlock();
    }
}
@end
