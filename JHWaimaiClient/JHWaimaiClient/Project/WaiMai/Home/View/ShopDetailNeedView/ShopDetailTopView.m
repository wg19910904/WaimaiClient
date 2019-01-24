//
//  ShopDetailTopView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ShopDetailTopView.h"
#import <UIImageView+WebCache.h>
#import "NSString+Tool.h"

@interface ShopDetailTopView ()
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *shopNameLab;
@property(nonatomic,weak)UILabel *statusLab;
@property(nonatomic,weak)UILabel *shopDesLab;
@property(nonatomic,weak)UILabel *noticeLab;
@property(nonatomic,weak)UILabel *oldPeiLab;// 原来的配送费
@end

@implementation ShopDetailTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
 
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *iconImgView =[UIImageView new];
    [self addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=10;
        make.width.offset=70;
        make.height.offset=70;
    }];
    self.iconImgView = iconImgView;
    
    UILabel *shopNameLab = [UILabel new];
    [self addSubview:shopNameLab];
    [shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.top.offset=10;
        make.height.offset=20;
        make.width.lessThanOrEqualTo(@100);
    }];
    shopNameLab.textColor = [UIColor whiteColor];
    shopNameLab.font = FONT(14);
    self.shopNameLab = shopNameLab;
    
    UILabel *statusLab = [UILabel new];
    [self addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopNameLab.mas_right).offset=10;
        make.centerY.equalTo(shopNameLab);
        make.height.offset=14;
        make.width.greaterThanOrEqualTo(@40);
    }];
    statusLab.backgroundColor = THEME_COLOR_Alpha(1.0);
    statusLab.textAlignment = NSTextAlignmentCenter;
    statusLab.textColor = [UIColor whiteColor];
    statusLab.font = FONT(10);
    statusLab.layer.cornerRadius=4;
    statusLab.clipsToBounds=YES;
    self.statusLab = statusLab;
    
    UILabel *noticeLab = [UILabel new];
    [self addSubview:noticeLab];
    [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.centerY.equalTo(iconImgView);
        make.height.offset=20;
        make.right.offset = -10;
    }];
    noticeLab.textColor = [UIColor whiteColor];
    noticeLab.font = FONT(12);
    noticeLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.noticeLab = noticeLab;
    
    UILabel *shopDesLab = [UILabel new];
    [self addSubview:shopDesLab];
    [shopDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.bottom.equalTo(iconImgView.mas_bottom);
        make.height.offset=20;
    }];
    shopDesLab.textColor = [UIColor whiteColor];
    shopDesLab.font = FONT(11);
    self.shopDesLab = shopDesLab;
    
    UILabel *oldPeiLab = [UILabel new];
    [self addSubview:oldPeiLab];
    [oldPeiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopDesLab.mas_right).offset=5;
        make.centerY.equalTo(shopDesLab.mas_centerY);
        make.height.offset=20;
    }];
    oldPeiLab.textColor = HEX(@"999999", 1.0);
    oldPeiLab.font = FONT(10);
    self.oldPeiLab = oldPeiLab;

//    UIImageView *noticeImgView = [UIImageView new];
//    [self addSubview:noticeImgView];
//    [noticeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset=-10;
//        make.centerY.equalTo(shopDesLab.mas_centerY).offset=0;
//    }];
//    noticeImgView.image = IMAGE(@"btn_arrowr_gray");
}

-(void)reloadViewWithModel:(WMShopModel *)model{
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(model.logo)] placeholderImage:IMAGE(@"logo_shop60_default")];
    self.shopNameLab.text = model.title;
    self.statusLab.text = model.status == 1 ? NSLocalizedString(@"营业中", nil) : NSLocalizedString(@"已打烊", nil);
    
    NSString *tipStr = model.tips_label;
    
    if (tipStr.length != 0) {
        self.statusLab.text = tipStr;
        CGFloat width_str = getSize(tipStr, 20, 13).width;
        [self.statusLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset = width_str;
        }];
    }
    self.statusLab.backgroundColor = model.status == 1 ? THEME_COLOR_Alpha(1.0) : HEX(@"aaaaaa", 1.0);
    
    if ([model.freight floatValue] == 0) {
       
        self.shopDesLab.text = [NSString stringWithFormat:@"%@¥%@/%@%@/%@",NSLocalizedString(@"起送", nil),model.min_amount,model.pei_time,NSLocalizedString(@"分钟送达", @"ShopDetailTopView"),NSLocalizedString(@"免配送费", nil)];
    }else{
        
        if (model.is_reduce_pei) {
            
            self.shopDesLab.text = [NSString stringWithFormat: NSLocalizedString(@"起送¥%@/%@分钟送达/配送费¥%@起", NSStringFromClass([self class])),model.min_amount,model.pei_time,model.reduceEd_freight];
            NSString *str = [NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),model.freight];
            self.oldPeiLab.attributedText = [NSString getAttributeString:str strAttributeDic:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle) ,NSStrikethroughColorAttributeName : HEX(@"999999", 1.0)}];
        }else{
            self.shopDesLab.text = [NSString stringWithFormat: NSLocalizedString(@"起送¥%@/%@分钟送达/配送费¥%@起", NSStringFromClass([self class])),model.min_amount,model.pei_time,model.freight];
        }
        
    }
    
    NSString *notice = model.delcare.length == 0 ? NSLocalizedString(@"暂无公告", nil) : model.delcare;
    self.noticeLab.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"公告", @"ShopDetailTopView"),notice];
}

@end
