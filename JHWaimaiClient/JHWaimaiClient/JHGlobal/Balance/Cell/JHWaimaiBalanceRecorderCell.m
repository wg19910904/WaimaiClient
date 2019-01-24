//
//  JHWaimaiBalanceRecorderCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiBalanceRecorderCell.h"
@interface JHWaimaiBalanceRecorderCell()
@property(nonatomic,strong)UIView *bottomLine;//底部的线
@property(nonatomic,strong)UILabel *moneyL;//显示金额的label
@property(nonatomic,strong)UILabel *titleL;//展示标题的
@property(nonatomic,strong)UILabel *dateL;//展示日期的
@end
@implementation JHWaimaiBalanceRecorderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
         [self bottomLine];
         [self moneyL];
         [self titleL];
         [self dateL];
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
#pragma mark - 展示金额的
-(UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.font = FONT(16);
        [self addSubview:_moneyL];
        [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -12;
            make.height.offset = 20;
            make.top.offset = 23;
            make.height.offset = 20;
        }];
    }
    return _moneyL;
}
#pragma mark - 展示标题的
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FONT(15);
        _titleL.textColor = HEX(@"333333", 1);
        _titleL.numberOfLines = 0;
        [self addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.right.offset = -100;
            make.top.offset = 15;
        }];
    }
    return _titleL;
}
#pragma mark - 展示日期的
-(UILabel *)dateL{
    if (!_dateL) {
        _dateL = [[UILabel alloc]init];
        _dateL.font = FONT(13);
        _dateL.textColor = HEX(@"666666", 1);
        [self addSubview:_dateL];
        [_dateL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.top.mas_equalTo(_titleL.mas_bottom).offset = 5;
            make.height.offset = 20;
            make.bottom.offset = - 10;
        }];
    }
    return _dateL;
}
-(void)setModel:(JHWaimaiMyBalaceListDetailModel *)model{
    _model = model;
    _titleL.text = model.intro;
    _dateL.text = model.dateline;
    if ([model.number containsString:@"-"]) {
        _moneyL.text = model.number;
        _moneyL.textColor = HEX(@"ff3333", 1);
    }else{
        _moneyL.text = [@"+" stringByAppendingString:model.number];
        _moneyL.textColor = HEX(@"222222", 1);
    }
}
@end
