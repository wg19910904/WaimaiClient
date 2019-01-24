//
//  OrderAddressCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "OrderAddressCell.h"
#import "ImgFillView.h"

@interface OrderAddressCell()
@property(nonatomic,weak)UILabel *nameLab;
@property(nonatomic,weak)UILabel *addressLab;
@property(nonatomic,weak)UILabel *chooseAddrLab;

@end

@implementation OrderAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;

    UILabel *nameLab = [UILabel new];
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=15;
        make.right.offset=-10;
        make.height.offset=20;
    }];
    nameLab.font = FONT(14);
    nameLab.textColor = TEXT_COLOR;
    nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.nameLab = nameLab;
    
    UILabel *addressLab = [UILabel new];
    [self.contentView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(nameLab.mas_bottom).offset=15;
        make.right.offset=-30;
        make.height.offset(45);
        make.bottom.offset(-10);
    }];
    addressLab.numberOfLines = 2;
    addressLab.font = FONT(12);
    addressLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.addressLab = addressLab;
    
    UIImageView *arrowImgView = [UIImageView new];
    [self.contentView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.width.offset=7;
        make.height.offset=12;
    }];
    arrowImgView.image = IMAGE(@"btn_arrowr_gray");
    
//    ImgFillView *lineImgView = [ImgFillView new];
//    [self.contentView addSubview:lineImgView];
//    [lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset=0;
//        make.bottom.offset=0;
//        make.right.offset=0;
//        make.height.offset=3;
//    }];
//    lineImgView.imgName = @"line";
    
    UILabel *chooseAddrLab = [UILabel new];
    [self.contentView addSubview:chooseAddrLab];
    [chooseAddrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    chooseAddrLab.textColor = THEME_COLOR_Alpha(1.0);
    chooseAddrLab.text = NSLocalizedString(@"请选择收货地址", nil);
    chooseAddrLab.textAlignment = NSTextAlignmentCenter;
    self.chooseAddrLab = chooseAddrLab;
    chooseAddrLab.hidden = YES;
}

-(void)reloadCell:(NSString *)name addrStr:(NSString *)addrStr{
    if (name.length == 0) {
        self.nameLab.text = @"";
        self.addressLab.text = @"";
        self.chooseAddrLab.hidden = NO;
    }else{
        self.chooseAddrLab.hidden = YES;
        self.nameLab.text = name;
        self.addressLab.text = addrStr;
    }
}
@end
