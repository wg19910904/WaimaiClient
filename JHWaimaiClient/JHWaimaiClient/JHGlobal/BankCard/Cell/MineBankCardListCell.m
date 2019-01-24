//
//  MineBankCardListCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "MineBankCardListCell.h"

@interface MineBankCardListCell ()
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *accountNumLab;
@property(nonatomic,weak)UIImageView *backImgView;
@property(nonatomic,assign)BOOL is_choose;
@end

@implementation MineBankCardListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
        self.backgroundColor = BACK_COLOR;
    }
    return self;
}

-(void)configUI{
    
    UIImageView *backImgView = [UIImageView new];
    [self addSubview:backImgView];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=0;
        make.right.offset=-10;
        make.bottom.offset=0;
    }];
    backImgView.image = IMAGE(@"pay_bg");
    self.backImgView = backImgView;
    
    UIImageView *iconImgView = [UIImageView new];
    [backImgView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset = 15;
        make.width.offset=40;
        make.height.offset=40;
        make.bottom.offset = -15;
    }];
    self.iconImgView = iconImgView;
    
    UILabel *titleLab = [UILabel new];
    [backImgView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.centerY.offset=-12;
        make.right.offset=-10;
        make.height.offset=20;
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"333333", 1.0);
    self.titleLab = titleLab;
    
    UILabel *accountNumLab = [UILabel new];
    [backImgView addSubview:accountNumLab];
    [accountNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.centerY.offset=12;
        make.right.offset=-10;
        make.height.offset=20;
    }];
    accountNumLab.font = FONT(20);
    accountNumLab.textColor = HEX(@"333333", 1.0);
    self.accountNumLab = accountNumLab;
    
}

-(void)reloadCellWithModel:(MineBankModel *)model is_choose:(BOOL)is_choose{

    self.iconImgView.image = IMAGE(model.card_img);
    self.titleLab.text = model.card_name;
    self.accountNumLab.text = model.card_label;
    self.is_choose = is_choose;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if (self.is_choose) {
        self.backImgView.image = selected ? IMAGE(@"pay_bg_selected") : IMAGE(@"pay_bg");
    }
    
}

@end
