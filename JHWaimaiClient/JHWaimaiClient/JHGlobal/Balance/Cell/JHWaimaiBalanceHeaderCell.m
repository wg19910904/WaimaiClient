//
//  JHWaimaiBalanceHeaderCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiBalanceHeaderCell.h"
@interface JHWaimaiBalanceHeaderCell()
@property(nonatomic,strong)UIImageView *imgV;//图标
@property(nonatomic,strong)UILabel *balanceL;//余额
@property(nonatomic,strong)UIButton *rechargeMoneyBtn;//充值的按钮
@end
@implementation JHWaimaiBalanceHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self imgV];
        [self balanceL];
        [self rechargeMoneyBtn];
    }
    return self;
}
#pragma mark - 图标
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.image = IMAGE(@"yue");
        [self addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.top.offset = 15;
            make.width.height.offset = 30;
            make.bottom.offset = -15;
        }];
    }
    return _imgV;
}
#pragma mark - 显示余额的
-(UILabel *)balanceL{
    if (!_balanceL) {
        _balanceL = [[UILabel alloc]init];
        _balanceL.textColor = HEX(@"ff6600", 1);
        _balanceL.font = FONT(20);
        [self addSubview:_balanceL];
        [_balanceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgV.mas_right).offset = 12;
            make.centerY.mas_equalTo(_imgV.mas_centerY);
            make.height.offset = 30;
        }];
    }
    return _balanceL;
}
#pragma mark - 显示充值的按钮
-(UIButton *)rechargeMoneyBtn{
    if (!_rechargeMoneyBtn) {
        _rechargeMoneyBtn = [[UIButton alloc]init];
        _rechargeMoneyBtn.backgroundColor = HEX(@"ff6600", 1);
        _rechargeMoneyBtn.layer.cornerRadius = 20;
        _rechargeMoneyBtn.layer.masksToBounds = YES;
        [_rechargeMoneyBtn setTitle:NSLocalizedString(@"充值", nil) forState:UIControlStateNormal];
        [_rechargeMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rechargeMoneyBtn.titleLabel.font = FONT(16);
        [_rechargeMoneyBtn addTarget:self action:@selector(clickToRecharge) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rechargeMoneyBtn];
        [_rechargeMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -12;
            make.centerY.mas_equalTo(_imgV.mas_centerY);
            make.height.offset = 40;
            make.width.offset = 100;
        }];
    }
    return _rechargeMoneyBtn;
}
-(void)setMoney:(NSString *)money{
    _money = money;
     _balanceL.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"¥", nil),money];
}
#pragma mark - 点击去充值的方法
-(void)clickToRecharge{
    NSLog(@"点击去充值");
    if (_myBlock) {
        _myBlock();
    }
}
@end
