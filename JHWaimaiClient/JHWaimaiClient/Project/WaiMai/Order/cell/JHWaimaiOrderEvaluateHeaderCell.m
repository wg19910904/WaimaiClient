//
//  JHWaimaiOrderEvaluateHeaderCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderEvaluateHeaderCell.h"
#import <UIImageView+WebCache.h>
@interface JHWaimaiOrderEvaluateHeaderCell()
@property(nonatomic,strong)UIImageView *shopImgV;//这是商家的图标
@property(nonatomic,strong)UILabel *shopNameL;//商家的名字
@property(nonatomic,strong)UIView *lineL;//中间的线
@property(nonatomic,strong)UILabel *dafenL;//显示商家打分的按钮

@end
@implementation JHWaimaiOrderEvaluateHeaderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self shopImgV];
        [self shopNameL];
        [self lineL];
        [self dafenL];
        [self starView];
        [self textView];
    }
    return self;
}
#pragma mark - 这是商家的图标
-(UIImageView *)shopImgV{
    if (!_shopImgV) {
        _shopImgV = [[UIImageView alloc]init];
        _shopImgV.layer.cornerRadius = 30;
        _shopImgV.layer.masksToBounds = YES;
        [self addSubview:_shopImgV];
        [_shopImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.offset = 20;
            make.height.width.offset = 60;
        }];
    }
    return _shopImgV;
}
-(void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    [_shopImgV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:IMAGE(@"logo_shop60_default")];
    
}
#pragma mark - 这是商家的名字
-(UILabel *)shopNameL{
    if (!_shopNameL) {
        _shopNameL = [[UILabel alloc]init];
        _shopNameL.textColor = HEX(@"333333", 1);
        _shopNameL.font = FONT(14);
        [self addSubview:_shopNameL];
        [_shopNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_shopImgV.mas_bottom).offset = 10;
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.offset = 16;
        }];
    }
    return _shopNameL;
}
-(void)setShopName:(NSString *)shopName{
    _shopName = shopName;
    _shopNameL.text = shopName;
}
#pragma mark - 中间的线
-(UIView *)lineL{
    if (!_lineL) {
        _lineL = [UIView new];
        _lineL.backgroundColor = HEX(@"eae6ed", 1);
        [self addSubview:_lineL];
        [_lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 50;
            make.right.offset = -50;
            make.height.offset = 0.5;
            make.top.mas_equalTo(_shopNameL.mas_bottom).offset = 20;
        }];
    }
    return _lineL;
}
#pragma mark - 这是显示商家打分的
-(UILabel *)dafenL{
    if (!_dafenL) {
        _dafenL = [[UILabel alloc]init];
        _dafenL.text = NSLocalizedString(@"商家打分", nil);
        _dafenL.backgroundColor = [UIColor whiteColor];
        _dafenL.textColor = HEX(@"999999", 1);
        _dafenL.font = FONT(12);
        _dafenL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dafenL];
        [_dafenL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(_lineL.mas_centerY);
            make.height.offset = 14;
            make.width.offset = 60;
        }];
    }
    return _dafenL;
}
#pragma mark - 这是评价的星星
-(YFStartView *)starView{
    if (!_starView) {
        _starView = [[YFStartView alloc]init];
        _starView.interSpace = 10;
        _starView.starType = YFStarViewFull;
        [self addSubview:_starView];
        [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_dafenL.mas_bottom).offset = 15;
            make.height.offset = 26;
            make.width.offset = 140;
        }];
    }
    return _starView;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = BACK_COLOR;
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.textColor = HEX(@"666666", 1);
        _textView.font = FONT(12);
        _textView.textContainerInset = UIEdgeInsetsMake(10, 12, 0, 12);
        _textView.text = NSLocalizedString(@"写下您对商家的建议吧~", nil);
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.right.offset = -12;
            make.top.mas_equalTo(_starView.mas_bottom).offset = 10;
            make.bottom.offset = -12;
            make.height.offset  = 100;
        }];
    }
    return _textView;
}
@end
