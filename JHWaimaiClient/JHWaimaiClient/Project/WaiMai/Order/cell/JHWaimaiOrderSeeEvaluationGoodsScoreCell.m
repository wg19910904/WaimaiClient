//
//  JHWaimaiOrderSeeEvaluationGoodsScoreCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderSeeEvaluationGoodsScoreCell.h"
@interface JHWaimaiOrderSeeEvaluationGoodsScoreCell()
@property(nonatomic,strong)UIView *lineL;//中间的线
@property(nonatomic,strong)UILabel *dafenL;//显示商品打分的按钮
@end
@implementation JHWaimaiOrderSeeEvaluationGoodsScoreCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self lineL];
        [self dafenL];
    }
    return self;
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
            make.top.offset = 20;
        }];
    }
    return _lineL;
}
#pragma mark - 这是显示商家打分的
-(UILabel *)dafenL{
    if (!_dafenL) {
        _dafenL = [[UILabel alloc]init];
        _dafenL.text = NSLocalizedString(@"商品打分", nil);
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
-(void)setArr:(NSArray *)arr{
    _arr = arr;
    [self creatShop];
}
#pragma mark - 创建商品的列表
-(void)creatShop{
    for (int i = 0; i < _arr.count; i ++) {
        //显示菜品的
        UILabel *lab = [[UILabel alloc]init];
        lab.text = _arr[i][@"product_name"];
        lab.textColor = HEX(@"666666", 1);
        lab.font = FONT(12);
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.top.offset = 49+i*(16+22);
            make.height.offset = 16;
            if (i == _arr.count - 1) {
                make.bottom.offset = -20;
            }
        }];
        //点bad的方法
        UIButton *badBtn = [[UIButton alloc]init];
        badBtn.tag = i;
        if ([_arr[i][@"pingjia"] integerValue]== 0) {
            badBtn.selected = YES;
        }
        [badBtn setBackgroundImage:IMAGE(@"icon-bad") forState:UIControlStateNormal];
        [badBtn setBackgroundImage:IMAGE(@"icon-bad-current") forState:UIControlStateSelected];
        [self addSubview:badBtn];
        [badBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -12;
            make.top.offset = 42+i*38;
            make.height.offset = 28;
            make.width.offset= 40;
        }];
        //点击赞的按钮
        UIButton * zanBtn = [[UIButton alloc]init];
        zanBtn.tag = i;
        if ([_arr[i][@"pingjia"] integerValue]== 1) {
            zanBtn.selected = YES;
        }
        [zanBtn setBackgroundImage:IMAGE(@"icon-good-deafult") forState:UIControlStateNormal];
        [zanBtn setBackgroundImage:IMAGE(@"icon-good") forState:UIControlStateSelected];
        [self addSubview:zanBtn];
        [zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -64;
            make.top.offset = 42+i*38;
            make.height.offset = 28;
            make.width.offset= 40;
        }];
    }
}

@end
