//
//  JHWaimaiOrderEvaluatePeiSCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderEvaluatePeiSCell.h"
#import "YFTypeBtn.h"
@interface JHWaimaiOrderEvaluatePeiSCell()
@property(nonatomic,strong)UIView *lineL;//中间的线
@property(nonatomic,strong)UILabel *dafenL;//显示商品打分的按钮
@property(nonatomic,strong)YFTypeBtn *choseTimeBtn;//点击选择时间的按钮
@end
@implementation JHWaimaiOrderEvaluatePeiSCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self lineL];
        [self dafenL];
        [self creatLab];
        [self choseTimeBtn];
        [self starView];
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
        _dafenL.text = NSLocalizedString(@"配送打分", nil);
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
#pragma mark - 创建标题
-(void)creatLab{
    for (int i = 0; i < 2; i ++) {
        //显示菜品的
        UILabel *lab = [[UILabel alloc]init];
        lab.text = i==0? NSLocalizedString(@"送达时间", nil):NSLocalizedString(@"配送服务", nil);
        lab.textColor = HEX(@"333333", 1);
        lab.font = FONT(14);
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.top.offset = 42+i*(16+22);
            make.height.offset = 16;
            if (i == 1) {
                make.bottom.offset = -10;
            }
        }];
    }
}
#pragma mark - 选择时间的按钮
-(YFTypeBtn *)choseTimeBtn{
    if (!_choseTimeBtn) {
        _choseTimeBtn = [[YFTypeBtn alloc]init];
        _choseTimeBtn.btnType = RightImage;
        _choseTimeBtn.titleMargin = -5;
        _choseTimeBtn.imageMargin = 10;
        [_choseTimeBtn setTitleColor:HEX(@"14aae4", 1) forState:UIControlStateNormal];
        [_choseTimeBtn setImage:IMAGE(@"icon-arrowR_white") forState:UIControlStateNormal];
        _choseTimeBtn.titleLabel.font = FONT(12);
        [self addSubview:_choseTimeBtn];
        [_choseTimeBtn addTarget:self action:@selector(clickToChoseTime) forControlEvents:UIControlEventTouchUpInside];
        [_choseTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -12;
            make.top.offset = 40;
            make.height.offset= 14;
            make.width.offset = 130;
        }];
    }
    return _choseTimeBtn;
}
-(void)setStr:(NSString *)str{
    _str = str;
    [_choseTimeBtn setTitle:str forState:UIControlStateNormal];
}
#pragma mark - 点击的是选择时间的按钮
-(void)clickToChoseTime{
    if (self.myBlock) {
        self.myBlock();
    }
}
#pragma mark - 评价的星星
-(YFStartView *)starView{
    if (!_starView) {
        _starView = [[YFStartView alloc]init];
        _starView.interSpace = 10;
        _starView.starType = YFStarViewFull;
        [self addSubview:_starView];
        [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 26;
            make.width.offset = 140;
            make.right.offset = -10;
            make.top.mas_equalTo(_choseTimeBtn.mas_bottom).offset= 20;;
        }];
    }
    return _starView;
}

@end
