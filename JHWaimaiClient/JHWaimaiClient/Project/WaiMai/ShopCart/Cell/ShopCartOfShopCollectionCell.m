//
//  ShopCartOfShopCollectionCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ShopCartOfShopCollectionCell.h"
#import <UIImageView+WebCache.h>

@interface ShopCartOfShopCollectionCell()
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *priceLab;
@end

@implementation ShopCartOfShopCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIImageView *iconImgView = [UIImageView new];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset = self.width;
    }];
    self.iconImgView = iconImgView;
    self.iconImgView.layer.borderColor= LINE_COLOR.CGColor;
    self.iconImgView.layer.borderWidth=0.5;
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.clipsToBounds = YES;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(iconImgView.mas_bottom).offset=5;
        make.right.offset=0;
        make.height.offset=20;
        make.bottom.offset = 0;
    }];
    priceLab.font = FONT(12);
    priceLab.textColor = HEX(@"ff3300", 1.0);
    priceLab.textAlignment = NSTextAlignmentCenter;
    self.priceLab = priceLab;
}

-(void)reloadCellWithModel:(WMShopGoodModel *)model{
    NSString *photo = model.photo;
    
    if (model.is_spec) {
        photo = model.choosedSize_photo;
        photo = photo.length == 0 ? model.photo : photo;
        self.priceLab.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"¥", nil),model.choosedSize_price];
    }else{
        self.priceLab.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"¥", nil),model.price];
    }
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(photo)] placeholderImage:IMAGE(@"product60_default")];
    
    
}
@end
