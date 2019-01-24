//
//  JHWMHuanGouGoodCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/28.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHWMHuanGouGoodCell.h"
#import <UIImageView+WebCache.h>
#import "YFSteper.h"
#import "NSString+Tool.h"

@interface JHWMHuanGouGoodCell ()<YFSteperDelegate>
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *priceLab;
//@property(nonatomic,weak)YFTypeBtn *desBtn;
@property(nonatomic,weak)YFSteper *steper;
@property(nonatomic,strong)WMShopGoodModel *goodModel;
@property(nonatomic,weak)UIButton *hgBtn;
@end

@implementation JHWMHuanGouGoodCell

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
        make.left.offset(10);
        make.top.offset(8);
        make.width.offset(52);
        make.height.offset(52);
        make.bottom.offset(-8);
    }];
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.clipsToBounds = YES;
    self.iconImgView = iconImgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.top.equalTo(iconImgView.mas_top).offset(4);
        make.right.offset(-10);
        make.height.offset(20);
    }];
    titleLab.font = FONT(16);
    titleLab.textColor = HEX(@"333333", 1.0);
    self.titleLab = titleLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.bottom.equalTo(iconImgView.mas_bottom).offset(-4);
        make.height.offset(20);
    }];
    priceLab.font = FONT(18);
    priceLab.textColor = HEX(@"fa4c34", 1.0);
    self.priceLab = priceLab;
    
    UIView *lineView=[UIView new];
    [priceLab addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset=1;
        make.right.offset=0;
        make.height.offset=1;
        make.width.offset=40;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    YFSteper *steper = [YFSteper new];
    [self.contentView addSubview:steper];
    [steper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.bottom.offset=-8;
        make.width.offset=80;
        make.height.offset=30;
    }];
    steper.minCount = 0;
    steper.currentCount = 0;
    steper.delegate = self;
    steper.subBtnImg = @"btn-num_subtraction";
    steper.addBtnImg = @"btn-num_addCart";
    steper.hidden = YES;
    self.steper = steper;
    
    UIButton *hgBtn = [UIButton new];
    [self.contentView addSubview:hgBtn];
    [hgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(steper.mas_centerX);
        make.centerY.equalTo(steper.mas_centerY);
        make.width.offset(64);
        make.height.offset(30);
    }];
    hgBtn.layer.cornerRadius=4;
    hgBtn.clipsToBounds=YES;
    hgBtn.backgroundColor = HEX(@"4A92F6", 1.0);
    hgBtn.titleLabel.font = FONT(16);
    [hgBtn setTitle: NSLocalizedString(@"换购", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [hgBtn addTarget:self action:@selector(addCount) forControlEvents:UIControlEventTouchUpInside];
    self.hgBtn = hgBtn;
}

-(void)reloadCellWithModel:(WMShopGoodModel *)model{
    _goodModel = model;
    self.titleLab.text = model.title;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(model.photo)] placeholderImage:IMAGE(@"product60_default")];
    NSString *str = [NSString stringWithFormat: NSLocalizedString(@"¥ %@  ¥%@", NSStringFromClass([self class])),model.price,model.oldprice];
    NSAttributedString *attStr = [NSString getAttributeString:str dealStr: NSLocalizedString(@"¥", NSStringFromClass([self class])) strAttributeDic:@{NSFontAttributeName : FONT(14)}];
    attStr = [NSString addAttributeString:attStr dealStr:[NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),model.oldprice] strAttributeDic: @{NSForegroundColorAttributeName : LINE_COLOR,NSFontAttributeName : FONT(14)}];
   
    self.priceLab.attributedText = attStr;
    self.steper.currentCount = model.current_shopcart_choosedCount;
    self.steper.maxCount = model.quota == 0 ? model.sale_sku : MIN(model.quota, model.sale_sku);
    self.hgBtn.hidden = model.current_shopcart_choosedCount > 0;
    self.steper.hidden = model.current_shopcart_choosedCount == 0;
}

#pragma mark ======YFSteperDelegate=======
-(void)addCount{
    if (self.chooseGoodReloadBlock) {
        self.goodModel.current_shopcart_choosedCount += 1;
        self.chooseGoodReloadBlock(self.goodModel, nil);
    }
}

-(void)subCount:(int)count{
    if (self.chooseGoodReloadBlock) {
        self.goodModel.current_shopcart_choosedCount -= 1;
        if (self.goodModel.current_shopcart_choosedCount < 0) {
            self.goodModel.current_shopcart_choosedCount  = 0;
        }
        self.chooseGoodReloadBlock(self.goodModel, nil);
    }
}

@end
