//
//  JHWaimaiOrderPayBtnCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderPayBtnCell.h"
@interface JHWaimaiOrderPayBtnCell()
@property(nonatomic,strong)UIButton *payBtn;//支付的按钮
@end
@implementation JHWaimaiOrderPayBtnCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BACK_COLOR;
        [self payBtn];
    }
    return self;
}
#pragma mark - 支付的按钮
-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [[UIButton alloc]init];
        _payBtn.backgroundColor = THEME_COLOR_Alpha(1);
        _payBtn.layer.cornerRadius = 4;
        _payBtn.layer.masksToBounds = YES;
        [_payBtn setTitle:NSLocalizedString(@"确认支付", nil) forState:UIControlStateNormal];
        [_payBtn setTitleColor:HEX(@"ffffff", 1) forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];
        _payBtn.titleLabel.font = FONT(16);
        [self addSubview:_payBtn];
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.right.offset = -15;
            make.height.offset = 40;
            make.top.offset = 20;
            make.bottom.offset = 0;
        }];
    }
    return _payBtn;
}
#pragma mark - 点击支付的方法
-(void)clickPay{
    if (self.myBlock) {
        self.myBlock();
    }
}
@end
