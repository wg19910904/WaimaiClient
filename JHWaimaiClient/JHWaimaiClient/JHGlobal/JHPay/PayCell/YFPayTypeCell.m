//
//  YFPayTypeCell.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFPayTypeCell.h"

@interface YFPayTypeCell ()
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *typeLab;
@property(nonatomic,weak)UIImageView *selecteImgView;

@end

@implementation YFPayTypeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{

    UIImageView *iconImgView = [UIImageView new];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10);
        make.centerY.offset(0);
        make.width.height.offset(40);
        make.bottom.offset(-10);
    }];
    iconImgView.contentMode = UIViewContentModeCenter;
    self.iconImgView = iconImgView;
    
    UILabel *typeLab = [UILabel new];
    [self.contentView addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.centerY.offset(0);
        make.height.offset(20);
    }];
    typeLab.font = FONT(16);
    typeLab.textColor = HEX(@"333333", 1.0);
    self.typeLab = typeLab;
    
    UILabel *moneyLab = [UILabel new];
    [self.contentView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLab.mas_right).offset(5);
        make.centerY.offset(0);
        make.height.offset(20);
    }];
    moneyLab.font = FONT(12);
    moneyLab.textColor = HEX(@"666666", 1.0);
    self.moneyLab = moneyLab;
    
    UIImageView *selecteImgView = [[UIImageView alloc]init];
    [self.contentView addSubview:selecteImgView];
    [selecteImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.centerY.offset=0;
        make.width.height.offset = 40;
    }];
    selecteImgView.contentMode = UIViewContentModeCenter;
    self.selecteImgView = selecteImgView;
    
    UILabel *bankCardNameLab = [UILabel new];
    [self.contentView addSubview:bankCardNameLab];
    [bankCardNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selecteImgView.mas_left).offset=-5;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    bankCardNameLab.textColor = HEX(@"666666", 1.0);
    bankCardNameLab.font = FONT(14);
    bankCardNameLab.textAlignment = NSTextAlignmentRight;
    self.bankCardNameLab = bankCardNameLab;
    
    [self addTopBorderLayer];
}

-(void)reloadCellWithDic:(NSDictionary *)dic payMoney:(NSString *)payMoney is_selected:(BOOL)selected{
    
    self.iconImgView.image = IMAGE(dic[@"img"]);
    self.typeLab.text = dic[@"title"];
    
    BOOL enough = [[JHUserModel shareJHUserModel].money floatValue] >= [payMoney floatValue];
    if (!enough && [dic[@"title"] containsString: NSLocalizedString(@"余额支付", NSStringFromClass([self class]))]) {
        self.selecteImgView.image = selected ? IMAGE(@"btn_fx_checked") : IMAGE(@"btn_fx");
    }else{
        self.selecteImgView.image = selected ? IMAGE(@"btn_dx_checked") : IMAGE(@"btn_dx");
    }
    
}

@end
