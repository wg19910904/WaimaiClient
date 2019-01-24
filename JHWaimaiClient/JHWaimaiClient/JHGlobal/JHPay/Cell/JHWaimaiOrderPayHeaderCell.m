//
//  JHWaimaiOrderPayHeaderCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderPayHeaderCell.h"
@interface JHWaimaiOrderPayHeaderCell()
@property(nonatomic,strong)UILabel *orderCodeL;//展示订单编号的
@property(nonatomic,strong)UIView *centerL;//中间的分割线
@property(nonatomic,strong)UILabel *leftL;//左边的应支付金额
@property(nonatomic,strong)UILabel *priceL;//展示金额的
@end
@implementation JHWaimaiOrderPayHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self orderCodeL];
        [self centerL];
        [self leftL];
        [self priceL];
    }
    return self;
}
#pragma mark - 展示订单编号的
-(UILabel *)orderCodeL{
    if (!_orderCodeL) {
        _orderCodeL = [[UILabel alloc]init];
        _orderCodeL.font = FONT(14);
        _orderCodeL.textColor = HEX(@"666666", 1);
        [self addSubview:_orderCodeL];
        [_orderCodeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.offset = 15;
            make.height.offset = 16;
        }];
    }
    return _orderCodeL;
}
-(void)setOrder_id:(NSString *)order_id{
    _order_id = order_id;
    _orderCodeL.text = [NSString stringWithFormat:NSLocalizedString(@"订单编号:%@", nil),order_id];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:_orderCodeL.text];
    [attribute addAttributes:@{NSForegroundColorAttributeName:HEX(@"000000", 1)} range:[_orderCodeL.text rangeOfString:order_id]];
    _orderCodeL.attributedText = attribute;

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
            make.top.mas_equalTo(_orderCodeL.mas_bottom).offset = 15;
        }];
    }
    return _centerL;
}
#pragma mark - 应支付金额
-(UILabel *)leftL{
    if (!_leftL) {
        _leftL = [[UILabel alloc]init];
        _leftL.text = NSLocalizedString(@"应支付金额", nil);
        _leftL.font = FONT(14);
        _leftL.textColor = HEX(@"666666", 1);
        [self addSubview:_leftL];
        [_leftL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.mas_equalTo(_centerL.mas_bottom).offset = 15;
            make.height.offset = 26;
            make.bottom.offset = -15;
        }];
    }
    return _leftL;
}
#pragma mark - 展示金额的
-(UILabel *)priceL{
    if (!_priceL) {
        _priceL = [[UILabel alloc]init];
        _priceL.textColor = HEX(@"000000", 1);
        _priceL.font = FONT(18);
        [self addSubview:_priceL];
        [_priceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.centerY.mas_equalTo(_leftL.mas_centerY);
            make.height.offset = 20;
        }];
    }
    return _priceL;
}
-(void)setAmount:(NSString *)amount{
    _amount = amount;
    _priceL.text = [NSLocalizedString(@"¥", nil) stringByAppendingString:amount];
}
@end
