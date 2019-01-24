//
//  JHOrderBackMoneyPhoneCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/31.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderBackMoneyPhoneCell.h"
#import "JHShowAlert.h"
@interface JHWaimaiOrderBackMoneyPhoneCell()
@property(nonatomic,strong)UILabel *tittleL;//展示标题的
@property(nonatomic,strong)UIButton *imgV;//电话号码
@property(nonatomic,strong)UIView *bgView;//背景view
@end
@implementation JHWaimaiOrderBackMoneyPhoneCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BACK_COLOR;
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self bgView];
        [self tittleL];
        [self phoneLabel];
        [self imgV];
        [self bgView];
    }
    return self;
}
#pragma mark - 背景view
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset = 0;
            make.top.offset = 15;
            make.height.offset = 40;
        }];
    }
    return _bgView;
}
#pragma mark - 展示联系商家的title
-(UILabel *)tittleL{
    if (!_tittleL) {
        _tittleL = [[UILabel alloc]init];
        _tittleL.text = NSLocalizedString(@"联系卖家", nil);
        _tittleL.font = FONT(14);
        _tittleL.textColor = HEX(@"333333", 1);
        [_bgView addSubview:_tittleL];
        [_tittleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.offset = 10;
            make.height.offset = 20;
        }];
    }
    return _tittleL;
}
#pragma mark - 展示电话号码的label
-(UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.textColor = HEX(@"14aae4", 1);
        _phoneLabel.font = FONT(14);
        [_bgView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_tittleL.mas_right).offset = 20;
            make.height.offset = 20;
            make.top.offset = 10;
        }];
    }
    return _phoneLabel;
}
#pragma mark - 展示图片的
-(UIButton *)imgV{
    if (!_imgV) {
        _imgV = [[UIButton alloc]init];
        [_imgV setBackgroundImage:IMAGE(@"btn_call_green") forState:UIControlStateNormal];
        [_imgV addTarget:self action:@selector(clickPhoneBtn) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -20;
            make.width.height.offset = 20;
            make.top.offset = 10;
        }];
    }
    return _imgV;
}
#pragma mark - 点击电话按钮的方法
-(void)clickPhoneBtn{
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneLabel.text]]];
}
@end
