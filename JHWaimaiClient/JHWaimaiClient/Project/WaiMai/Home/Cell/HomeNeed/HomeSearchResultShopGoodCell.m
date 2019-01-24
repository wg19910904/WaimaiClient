//
//  HomeSearchResultShopCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/26.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "HomeSearchResultShopGoodCell.h"
#import "NSString+Tool.h"
#import <UIImageView+WebCache.h>

@interface HomeSearchResultShopGoodCell()
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UILabel *tipLab;
@property(nonatomic,weak)UILabel *desLab;
@end

@implementation HomeSearchResultShopGoodCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    self.contentView.backgroundColor = HEX(@"ffffff", 1.0);
    UIImageView *iconImgView = [UIImageView new];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(64);
        make.top.offset(0);
        make.width.height.offset(72);
        make.bottom.offset(-8);
    }];
    iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    iconImgView.clipsToBounds = YES;
    self.iconImgView = iconImgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(8);
        make.top.offset(0);
        make.right.offset(-10);
        make.height.offset(22);
    }];
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.font = FONT(16);
    titleLab.textColor = HEX(@"333333", 1.0);
    self.titleLab = titleLab;

    UILabel *desLab = [UILabel new];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(8);
        make.centerY.equalTo(iconImgView.mas_centerY).offset(0);
        make.right.offset(-10);
        make.height.offset(22);
    }];
    desLab.lineBreakMode = NSLineBreakByTruncatingTail;
    desLab.font = FONT(12);
    desLab.textColor = HEX(@"999999", 1.0);
    self.desLab = desLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(8);
        make.bottom.equalTo(iconImgView.mas_bottom).offset(0);
        make.right.offset(-10);
        make.height.offset(22);
    }];
    priceLab.lineBreakMode = NSLineBreakByTruncatingTail;
    priceLab.font = FONT(14);
    priceLab.textColor = HEX(@"fa4c34", 1.0);
    self.priceLab = priceLab;
    
}

-(void)reloadCellWithModel:(WMShopGoodModel *)model withStr:(NSString *)str withColor:(NSString *)colorStr{
    
    self.titleLab.text = model.title;
    NSRange range = [model.title rangeOfString:str];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.title];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEX(colorStr, 1) range:range];
    self.titleLab.attributedText = attStr;
    
    
    self.desLab.text = [NSString stringWithFormat:NSLocalizedString(@"月售%@  赞%@", nil),model.sales,model.good];
    self.priceLab.attributedText = [NSString priceLabText:[NSString stringWithFormat:@"%@",model.price] attributeFont:18];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(model.photo)] placeholderImage:IMAGE(@"logo_shop60_default")];
    
}

@end
