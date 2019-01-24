//
//  JHWMPayOrderMoneyCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMPayOrderMoneyCell.h"
#import "SevenSwitch.h"
#import "NSString+Tool.h"

@interface JHWMPayOrderMoneyCell()
@property(nonatomic,weak)UILabel *moneyLab;
@property(nonatomic,weak)SevenSwitch *switchBtn;
@end

@implementation JHWMPayOrderMoneyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIImageView *iconImg = [[UIImageView alloc]init];
    [self addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset = 15;
        make.height.width.offset = 30;
        make.bottom.offset = -15;
    }];
    iconImg.image = IMAGE(@"icon_moneyPay");
    
    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImg.mas_right).offset=10;
        make.top.offset=14;
        make.height.offset=15;
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.text =  NSLocalizedString(@"余额支付", NSStringFromClass([self class]));
    
    UILabel *moneyLab = [UILabel new];
    [self addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImg.mas_right).offset=10;
        make.top.equalTo(titleLab.mas_bottom).offset=1;
        make.height.offset=15;
        make.right.offset = -60;
    }];
    moneyLab.font = FONT(12);
    moneyLab.textColor = HEX(@"999999", 1.0);
    self.moneyLab = moneyLab;
    [self getAttrStrWith:@"0"];
    
    SevenSwitch *switchBtn = [SevenSwitch new];
    [self addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.width.offset=45;
        make.height.offset=25;
    }];
    [switchBtn addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    switchBtn.onTintColor = THEME_COLOR_Alpha(1.0);
    switchBtn.thumbTintColor = [UIColor whiteColor];
    switchBtn.onStr = @"";
    switchBtn.shadowColor = [UIColor clearColor];
    switchBtn.on = YES;
    self.switchBtn = switchBtn;
    
    UIView *lineView=[UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=-0.5;
        make.right.offset=0;
        make.height.offset=1;
    }];
    lineView.tag = 100;
    lineView.backgroundColor=LINE_COLOR;
}

-(void)setIs_hidden_line:(BOOL)is_hidden_line{
    [[self viewWithTag:100] setHidden:is_hidden_line];
}

-(void)relaodCellWith:(NSString *)order_money{
    self.switchBtn.userInteractionEnabled =  [[JHUserModel shareJHUserModel].money floatValue] > 0;
    if ([[JHUserModel shareJHUserModel].money floatValue] <= 0) {
        self.switchBtn.on = NO;
    }
    [self getAttrStrWith:order_money];
}

-(void)changeValue:(SevenSwitch *)switchBtn{
    YF_SAFE_BLOCK(self.changeStatus,switchBtn.isOn);
}

// 文字处理
-(void)getAttrStrWith:(NSString *)amount{
    
    if (self.switchBtn.isOn) {
        if ([[JHUserModel shareJHUserModel].money floatValue] >= [amount floatValue]) {
            amount = @"0";
        }else{
            float discount = [amount floatValue] - [[JHUserModel shareJHUserModel].money floatValue]  ;
            amount = [NSString getStrFromFloatValue:discount bitCount:2];
        }
    }else{
        amount = @"0";
    }
    
    NSString *money =  [NSLocalizedString(@"¥", NSStringFromClass([self class])) stringByAppendingString:[JHUserModel shareJHUserModel].money];
    amount = [NSLocalizedString(@"¥", NSStringFromClass([self class])) stringByAppendingString:amount];
    NSString *str = [NSString stringWithFormat: NSLocalizedString(@"余额: %@  还需支付: %@", NSStringFromClass([self class])),money,amount];
    NSAttributedString *attStr = [NSString getAttributeString:str dealStr:money strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff3300", 1.0)}];
    attStr = [NSString addAttributeString:attStr dealStr:amount strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff3300", 1.0)}];
    self.moneyLab.attributedText = attStr;
    
}

@end
