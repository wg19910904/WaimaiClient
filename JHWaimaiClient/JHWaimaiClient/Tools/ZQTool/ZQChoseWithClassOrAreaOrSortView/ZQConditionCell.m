//
//  ZQConditionCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQConditionCell.h"
@interface ZQConditionCell()
@property(nonatomic,strong)UILabel *titleL;//展示标题的
@property(nonatomic,strong)UIImageView *selectImgV;//选中的图片展示
@property(nonatomic,strong)UIView *leftL;//选中的时候展示
@end
@implementation ZQConditionCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self titleL];
        [self selectImgV];
        [self leftL];
    }
    return self;
}
#pragma mark - 展示标题的
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = HEX(@"4a4c4d", 1);
        _titleL.font = FONT(13);
        [self addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.height.offset = 20;
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _titleL;
}
#pragma mark - 展示选中的图片
-(UIImageView *)selectImgV{
    if (!_selectImgV) {
        _selectImgV = [[UIImageView alloc]init];
        _selectImgV.image = [UIImage imageNamed:@"icon_selected_new"];
        _selectImgV.contentMode = UIViewContentModeScaleAspectFill;
        _selectImgV.clipsToBounds = YES;
        _selectImgV.hidden = YES;
        [self addSubview:_selectImgV];
        [_selectImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -13;
            make.height.offset = 13;
            make.width.offset = 18;
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _selectImgV;
}
-(void)setText:(NSString *)text{
    _text = text;
    _titleL.text = text;
}
-(void)setIsSelector:(BOOL)isSelector{
    _isSelector = isSelector;
    _leftL.hidden = YES;
    if (!_isClass&&!_isArea) {
       _selectImgV.hidden = !isSelector;
    }else{
        _leftL.hidden = !isSelector;
    }
    if (isSelector) {
        _titleL.textColor = THEME_COLOR_Alpha(1);
        if (_isClass || _isArea) {
             self.backgroundColor = [UIColor whiteColor];
        }
    }else{
        _titleL.textColor = HEX(@"4a4c4d", 1);
        if (_isClass || _isArea) {
            self.backgroundColor = HEX(@"f4f4f4", 1);
        }
    }
    
}
-(void)setIsClass:(BOOL)isClass{
    _isClass = isClass;
    if (isClass) {
        self.backgroundColor = HEX(@"f4f4f4", 1);
        [_selectImgV removeFromSuperview];
        _selectImgV = nil;
    }
}
-(void)setIsArea:(BOOL)isArea{
    _isArea = isArea;
    if (isArea) {
        self.backgroundColor = HEX(@"f4f4f4", 1);
        [_selectImgV removeFromSuperview];
        _selectImgV = nil;
    }
}
#pragma mark - 左边选中的时候展示的
-(UIView *)leftL{
    if (!_leftL) {
        _leftL = [[UIView alloc]init];
        _leftL.hidden = YES;
        _leftL.backgroundColor = THEME_COLOR_Alpha(1);
        [self addSubview:_leftL];
        [_leftL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset = 0;
            make.width.offset = 3;
        }];
    }
    return _leftL;
}
@end
