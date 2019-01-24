//
//  WaiMaiGoodCollectionCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WaiMaiGoodCollectionCell.h"
#import <UIImageView+WebCache.h>

@interface WaiMaiGoodCollectionCell()
@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,weak)UILabel *priceLab;
@end

@implementation WaiMaiGoodCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIImageView *imgView = [UIImageView new];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.width.offset = self.width;
        make.height.offset = self.width;
    }];
    imgView.layer.borderColor=HEX(@"dae1e6", 1.0).CGColor;
    imgView.layer.borderWidth=0.5;
    self.imgView = imgView;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    
    UIImageView *hotImgView = [UIImageView new];
    [imgView addSubview:hotImgView];
    [hotImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.width.offset=28;
        make.height.offset=14;
    }];
    hotImgView.image = IMAGE(@"index_label_hot");
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(imgView.mas_bottom).offset=5;
        make.right.offset = 0;
        make.height.offset=20;
        make.bottom.offset = 0;
    }];
    priceLab.font = FONT(12);
    priceLab.textAlignment = NSTextAlignmentCenter;
    priceLab.textColor = HEX(@"ff6600", 1.0);
    self.priceLab = priceLab;
    
}

-(void)reloadCellWithModel:(WMHomeShopProducts *)model{
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(model.photo)] placeholderImage:IMAGE(@"product80_default")];
    self.priceLab.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"¥", nil),model.price];
    
}

@end
