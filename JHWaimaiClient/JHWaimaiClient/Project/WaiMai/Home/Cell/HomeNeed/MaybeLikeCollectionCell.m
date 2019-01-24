//
//  MaybeLikeCollectionCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/4/28.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "MaybeLikeCollectionCell.h"
#import <UIImageView+WebCache.h>

@interface MaybeLikeCollectionCell ()
@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UILabel *shopNameLab;
@property(nonatomic,weak)UIButton *addBtn;
@property(nonatomic,weak)UILabel *countLab;
@end

@implementation MaybeLikeCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)configUI{
    
    UIImageView *imgView = [UIImageView new];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=185;
    }];
    self.imgView = imgView;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(imgView.mas_bottom).offset=-1;
        make.right.offset=0;
        make.height.offset=1;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(lineView.mas_bottom).offset=5;
        make.height.offset=20;
    }];
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"222222", 1.0);
    self.titleLab = titleLab;
    
    UILabel *countLab = [UILabel new];
    [self.contentView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset=3;
        make.top.equalTo(lineView.mas_bottom).offset=5;
        make.right.offset=-10;
        make.height.offset=20;
    }];
    countLab.lineBreakMode = NSLineBreakByTruncatingTail;
    countLab.font = FONT(12);
    countLab.textColor = HEX(@"999999", 1.0);
    self.countLab = countLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(titleLab.mas_bottom).offset=5;
        make.right.offset=0;
        make.height.offset=20;
    }];
    priceLab.textColor = HEX(@"ff6600", 1.0);
    priceLab.font = FONT(14);
    self.priceLab = priceLab;
    
    UILabel *shopNameLab = [UILabel new];
    [self.contentView addSubview:shopNameLab];
    [shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(priceLab.mas_bottom).offset=5;
        make.right.offset=-40;
        make.height.offset=20;
    }];
    shopNameLab.textColor = HEX(@"999999", 1.0);
    shopNameLab.font = FONT(12);
    shopNameLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.shopNameLab = shopNameLab;
    
//    UIButton *btn = [UIButton new];
//    [self.contentView addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset=-10;
//        make.bottom.offset=-10;
//        make.width.offset=30;
//        make.height.offset=30;
//    }];
//    [btn setImage:IMAGE(@"btn_add_cart") forState:UIControlStateNormal];
}

-(void)reloadCellWithModel:(MaybeLikeGood *)model showCount:(BOOL)show{
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(model.photo)] placeholderImage:IMAGE(@"product186_default")];
    self.titleLab.text = model.title;
    self.priceLab.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"¥", nil),model.price];
    self.shopNameLab.text = model.shop_title;//@"哈哈玩具店";
    self.countLab.text = [NSString stringWithFormat:NSLocalizedString(@"已售%@", nil),model.sales];
    self.countLab.hidden = !show;
}
@end
