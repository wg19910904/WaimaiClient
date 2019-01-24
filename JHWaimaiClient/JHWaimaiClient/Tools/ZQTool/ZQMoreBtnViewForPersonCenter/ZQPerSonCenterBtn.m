//
//  ZQPerSonCenterBtn.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/7/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQPerSonCenterBtn.h"
@interface ZQPerSonCenterBtn()
@property(nonatomic,strong)UILabel *numL;
@property(nonatomic,strong)UIView *line;
@end
@implementation ZQPerSonCenterBtn
-(instancetype)init{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}
-(void)config{
    self.backgroundColor = [UIColor whiteColor];
    [self imageV];
    [self textL];
    [self numL];
    [self line];
}
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        [self addSubview:_imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 13;
            make.width.height.offset = 24;
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    return _imageV;
}
-(UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc]init];
        _textL.textColor = HEX(@"666666", 1);
        _textL.font = FONT(11);
        [self addSubview:_textL];
        _textL.textAlignment = NSTextAlignmentCenter;
        [_textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imageV.mas_bottom).offset = 7;
            make.left.right.offset = 0;
            make.height.offset = 20;
        }];
    }
    return _textL;
}
-(UILabel *)numL{
    if (!_numL) {
        _numL = [[UILabel alloc]init];
        _numL.textColor = [UIColor whiteColor];
        _numL.backgroundColor = [UIColor redColor];
        _numL.layer.cornerRadius = 7;
        _numL.layer.masksToBounds = YES;
        _numL.hidden = YES;
        _numL.font = FONT(9);
        _numL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numL];
        [_numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_imageV.mas_top).offset = 7;
            make.width.height.offset = 14;
            make.left.mas_equalTo(_imageV.mas_right).offset = -7;
        }];
    }
    return _numL;
}
-(UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = HEX(@"eae6ed", 1.0f);
        _line.hidden = YES;
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 8;
            make.bottom.offset = -8;
            make.right.offset = 0;
            make.width.offset = 0.5;
        }];
    }
    return _line;
}
-(void)setNum:(NSString *)num{
    if ([num integerValue] == 0) {
        _numL.hidden = YES;
    }else{
        _numL.hidden = NO;
    }
    if ([num integerValue] > 99) {
        num = @"99+";
        [_numL mas_updateConstraints:^(MASConstraintMaker *make) {
             make.width.offset = 24;
        }];
    }else{
        [_numL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 14;
        }];
    }
    _numL.text = num;
}
-(void)setIsShowLine:(BOOL)isShowLine{
    _isShowLine = isShowLine;
    _line.hidden = !isShowLine;
}
@end
