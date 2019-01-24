//
//  JHWaimaiRechargeMoneyCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiRechargeMoneyCell.h"
@interface JHWaimaiRechargeMoneyCell ()
@property(nonatomic,strong)UILabel *moneyL;//充值的金额
@property(nonatomic,strong)UILabel *sendL;//送的金额的展示
@property(nonatomic,strong)UIButton *choseBtn;//选择的按钮
@end
@implementation JHWaimaiRechargeMoneyCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = BACK_COLOR;
        [self choseBtn];
        [self moneyL];
        [self sendL];
    }
    return self;
}
-(UIButton *)choseBtn{
    if (!_choseBtn) {
        _choseBtn = [[UIButton alloc]init];
        [_choseBtn setBackgroundImage:IMAGE(@"box_default") forState:UIControlStateNormal];
        [_choseBtn setBackgroundImage:IMAGE(@"box_selected") forState:UIControlStateSelected];
        [_choseBtn addTarget:self action:@selector(clickToChose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_choseBtn];
        [_choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset = 0;
        }];
    }
    return _choseBtn;
}
-(void)setModel:(JHWaimaiRechargeMoneyModel *)model{
    _model = model;
    _choseBtn.selected = model.isSelector;
    _moneyL.text = model.chong;
     _sendL.text = model.title;
    
    if (model.title.length == 0) {
        [_moneyL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.offset = 20;
        }];
    }else{
        [_moneyL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 13;
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.offset = 20;
        }];
        NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:_sendL.text];
        [attribute addAttributes:@{NSForegroundColorAttributeName:HEX(@"ff6600", 1)} range:[_sendL.text rangeOfString:model.song]];
        _sendL.attributedText = attribute;
    }
    
}
#pragma mark - 这是点击选择的方法
-(void)clickToChose:(UIButton *)sender{
    sender.selected = YES;
    if (_myBlock) {
        _myBlock();
    }
}
#pragma mark - 金额
-(UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = HEX(@"222222", 1);
        _moneyL.font = FONT(18);
        [self addSubview:_moneyL];
        [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 13;
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.offset = 20;
        }];
    }
    return _moneyL;
}
#pragma mark - 送的金额
-(UILabel *)sendL{
    if (!_sendL) {
        _sendL = [[UILabel alloc]init];
        _sendL.textColor = HEX(@"333333", 1);
        _sendL.font = FONT(14);
        [self addSubview:_sendL];
        [_sendL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_moneyL.mas_bottom).offset = 10;
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.offset = 16;
        }];
    }
    return _sendL;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.choseBtn.selected = selected;
}
@end
