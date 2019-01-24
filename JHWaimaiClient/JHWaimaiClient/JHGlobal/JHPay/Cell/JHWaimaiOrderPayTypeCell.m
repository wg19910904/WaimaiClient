//
//  JHWaimaiOrderPayTypeCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderPayTypeCell.h"
@interface JHWaimaiOrderPayTypeCell()
@property(nonatomic,strong)UIImageView *imgV;//显示左边的图片
@property(nonatomic,strong)UIView *centerL;//中间的分割线
@property(nonatomic,strong)UILabel *titleL;//这是展示支付类型的
@property(nonatomic,strong)UIImageView *rightImgV;//右边的图片展示
@property(nonatomic,weak)UILabel *bankCardNameLab;
@end
@implementation JHWaimaiOrderPayTypeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self imgV];
        [self centerL];
        [self titleL];
        [self rightImgV];
        UILabel *bankCardNameLab = [UILabel new];
        [self addSubview:bankCardNameLab];
        [bankCardNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightImgV.mas_left).offset=-5;
            make.centerY.offset=0;
            make.left.equalTo(self.titleL.mas_right).offset = 5;
            make.height.offset=20;
        }];
        bankCardNameLab.textColor = HEX(@"666666", 1.0);
        bankCardNameLab.font = FONT(14);
        bankCardNameLab.textAlignment = NSTextAlignmentRight;
        self.bankCardNameLab = bankCardNameLab;
    }
    return self;
}
#pragma mark - 显示左边的图片
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        [self addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset = 15;
            make.height.width.offset = 30;
            make.bottom.offset = -15;
        }];
    }
    return _imgV;
}
#pragma mark - 中间的分割线
-(UIView *)centerL{
    if (!_centerL) {
        _centerL = [[UIView alloc]init];
        _centerL.backgroundColor = HEX(@"e6eaed", 1);
        [self addSubview:_centerL];
        [_centerL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.right.offset = -15;
            make.height.offset = 0.5;
            make.bottom.offset = 0;
        }];
    }
    return _centerL;
}
#pragma mark - 展示支付类型的
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = HEX(@"333333", 1);
        _titleL.font = FONT(14);
        [self addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgV.mas_right).offset = 10;
            make.centerY.mas_equalTo(_imgV.mas_centerY);
            make.height.offset = 20;
        }];
    }
    return _titleL;
}
#pragma mark - 右边的图片的展示
-(UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        [self addSubview:_rightImgV];
        [_rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.centerY.mas_equalTo(_imgV.mas_centerY);
            make.width.height.offset = 20;
        }];
    }
    return _rightImgV;
}
-(void)setTypeImg:(NSString *)typeImg{
    _typeImg = typeImg;
    _imgV.image = IMAGE(_typeImg);
}
-(void)setIsHid:(BOOL)isHid{
    _isHid =  isHid;
    _centerL.hidden = isHid;
}
-(void)setTitle:(NSString *)title{
    _title = title;
    _titleL.text = title;
}

-(void)setRightImg:(NSString *)rightImg{
    _rightImg = rightImg;
    _rightImgV.image = IMAGE(rightImg);
}

-(void)setBankCardName:(NSString *)bankCardName{
    self.bankCardNameLab.hidden = bankCardName.length == 0;
    self.bankCardNameLab.text = bankCardName;
}
@end
