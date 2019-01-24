//
//  JHWaiMaiOrderListCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/23.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiOrderListCell.h"
#import <UIImageView+WebCache.h>
@interface JHWaiMaiOrderListCell()

@property(nonatomic,strong)UIImageView *headerImgV;//头像
@property(nonatomic,strong)UILabel *labelStatus;//当前的状态
@property(nonatomic,strong)UILabel *nameL;//团购的商家的名字
@property(nonatomic,strong)UIImageView *jianTouImgV;//显示点击可进入商家的箭头
@property(nonatomic,strong)UILabel *timeL;//下单时间
@property(nonatomic,strong)UIView *line_l;//分割线1
@property(nonatomic,strong)UILabel *numL;//显示数量的
@property(nonatomic,strong)UILabel *priceL;//显示总价的
@property(nonatomic,strong)UIView *line_2;//分割线2
@property(nonatomic,strong)UIButton *gotoShopBtn;//点击进入商家详情的按钮

@end
@implementation JHWaiMaiOrderListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self headerImgV];
        [self labelStatus];
        [self nameL];
        [self jianTouImgV];
        [self timeL];
        [self gotoShopBtn];
        [self line_l];
        [self priceL];
        [self numL];
        [self line_2];
        
        UIButton *btn = [UIButton new];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(0);
            make.right.offset(0);
            make.height.offset(77);
        }];
        [btn addTarget:self action:@selector(clickToShopDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
#pragma mark - 头像
-(UIImageView *)headerImgV{
    if (!_headerImgV) {
        _headerImgV = [[UIImageView alloc]init];
        [self addSubview:_headerImgV];
//        _headerImgV.layer.cornerRadius = 15;
        _headerImgV.layer.masksToBounds = YES;
        [_headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.offset = 15;
            make.width.height.offset = 52;
        }];
    }
    return _headerImgV;
}
#pragma mark - 当前的状态
-(UILabel *)labelStatus{
    if (!_labelStatus) {
        _labelStatus = [[UILabel alloc]init];
        _labelStatus.font = FONT(14);
        _labelStatus.textColor = HEX(@"333333", 1);
        [self addSubview:_labelStatus];
        [_labelStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 18;
            make.right.offset = -16;
            make.height.offset = 20;
        }];
    }
    return _labelStatus;
}
#pragma make - 团购的商家的名字
-(UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.font = FONT(16);
        _nameL.textColor = HEX(@"333333", 1);
        [self addSubview:_nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerImgV.mas_right).offset = 10;
            make.top.offset =20;
            make.height.offset = 20;
        }];
        
    }
    return _nameL;
}
#pragma mark - 显示箭头的imgView
-(UIImageView *)jianTouImgV{
    if (!_jianTouImgV) {
        _jianTouImgV = [[UIImageView alloc]init];
        _jianTouImgV.image = IMAGE(@"arrow-r");
        [self addSubview:_jianTouImgV];
        [_jianTouImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameL.mas_right).offset = 13;
            make.width.offset = 7;
            make.height.offset = 12;
            make.centerY.mas_equalTo(_nameL.mas_centerY);
        }];
    }
    return _jianTouImgV;
}
#pragma mark - 显示下单的时间的
-(UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.font = FONT(14);
        _timeL.textColor = HEX(@"999999", 1);
        [self addSubview:_timeL];
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerImgV.mas_right).offset = 10;
            make.top.mas_equalTo(_nameL.mas_bottom).offset = 5;
            make.height.offset = 20;
        }];
    }
    return _timeL;
}
#pragma mark - 点击进入商家详情的按钮
-(UIButton *)gotoShopBtn{
    if (!_gotoShopBtn) {
        _gotoShopBtn = [[UIButton alloc]init];
        _gotoShopBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_gotoShopBtn];
        [_gotoShopBtn addTarget:self action:@selector(clickToShopDetail) forControlEvents:UIControlEventTouchUpInside];
        [_gotoShopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerImgV.mas_right).offset = 5;
            make.top.offset = 10;
            make.height.offset = 35;
            make.right.mas_equalTo(_jianTouImgV.mas_right);
        }];
        _gotoShopBtn.userInteractionEnabled = NO;
    }
    return _gotoShopBtn;
}

#pragma mark - 分割线1
-(UIView *)line_l{
    if (!_line_l) {
        _line_l = [UIView new];
        _line_l.backgroundColor = HEX(@"f5f5f5", 1);
        [self addSubview:_line_l];
        [_line_l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 16;
            make.right.offset = -16;
            make.height.offset =1;
            make.top.mas_equalTo(_headerImgV.mas_bottom).offset = 15;
        }];
    }
    return _line_l;
}
#pragma mark - 数量
-(UILabel *)numL{
    if (!_numL) {
        _numL = [[UILabel alloc]init];
        _numL.textColor = HEX(@"999999", 1);
        _numL.font = FONT(14);
        [self addSubview:_numL];
        [_numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_l.mas_bottom).offset = 14;
            make.left.offset = 16;
            make.height.offset = 20;
            make.right.offset = -80;
        }];
    }
    return _numL;
}
#pragma mark - 价格
-(UILabel *)priceL{
    if (!_priceL) {
        _priceL = [[UILabel alloc]init];
        _priceL.textColor = HEX(@"333333", 1);
        _priceL.font = FONT(16);
        [self addSubview:_priceL];
        [_priceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_l.mas_bottom).offset = 14;
            make.right.offset = -15;
            make.height.offset = 22;
            make.bottom.offset = -10;
        }];
    }
    return _priceL;
}
#pragma mark - 分割线2
-(UIView *)line_2{
    if (!_line_2) {
        _line_2 = [UIView new];
        _line_2.backgroundColor = LINE_COLOR;
        _line_2.hidden = YES;
        [self addSubview:_line_2];
        [_line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset = 0;
            make.height.offset = 0.5;
            make.top.mas_equalTo(_line_l.mas_bottom).offset = 49.5;
        }];
    }
    return _line_2;
}

#pragma mark - 处理数据的模型
-(void)setModel:(JHWaiMaiOrderListModel *)model{
    _model = model;
    [_headerImgV sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:model.shop_logo]] placeholderImage:IMAGE(@"logo_shop60_default")];
    _labelStatus.text = model.order_status_label;
    _nameL.text = model.shop_title;
    _timeL.text  = model.dateline;
    _priceL.text = [NSString stringWithFormat:@"¥%@",model.amount];
    _numL.text = model.product_title;
}

#pragma mark - 点击进入到商家详情的方法
-(void)clickToShopDetail{
    NSLog(@"点击进入到商家详情的方法");
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickToShopDetail:)]) {
        [self.delegate clickToShopDetail:_index];
    }
}

@end
