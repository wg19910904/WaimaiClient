//
//  JHWaimaiOrderDetailAddressCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailAddressCell.h"
@interface JHWaimaiOrderDetailAddressCell()
@property(nonatomic,strong)UIView *bottomLine;//底部的线
@property(nonatomic,strong)UILabel *leftLabel;//左边的显示
@property(nonatomic,strong)UILabel *addressL;//显示地址的
@end
@implementation JHWaimaiOrderDetailAddressCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self bottomLine];
        [self leftLabel];
        [self addressL];
    }
    return self;
}
#pragma mark - 底部的线
-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = LINE_COLOR;
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.offset = 0;
            make.height.offset = 0.5;
        }];
    }
    return _bottomLine;
}
#pragma mark - 左边的显示
-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.textColor = HEX(@"666666", 1);
        _leftLabel.font = FONT(12);
        _leftLabel.text = NSLocalizedString(@"收货地址:", nil);
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 13;
            make.height.offset = 15;
            make.top.offset = 13;
            make.width.offset = 55;
        }];
    }
    return _leftLabel;
}
#pragma mark - 显示地址的
-(UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]init];
        _addressL.textColor = HEX(@"666666", 1);
        _addressL.font = FONT(12);
        _addressL.numberOfLines = 0;
        [self addSubview:_addressL];
    }
    return _addressL;
}
-(void)setAddressTitle:(NSString *)addressTitle{
    _addressTitle = addressTitle;
    _addressL.text = addressTitle;
    [_addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftLabel.mas_right).offset = 8;
        make.top.offset = 13;
        make.right.offset = -20;
        make.bottom.offset = -10;
    }];
}
@end
