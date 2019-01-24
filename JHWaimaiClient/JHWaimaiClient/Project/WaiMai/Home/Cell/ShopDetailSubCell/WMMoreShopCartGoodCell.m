//
//  WMMoreShopCartGoodCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/18.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "WMMoreShopCartGoodCell.h"

@interface WMMoreShopCartGoodCell()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *guiLab;
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)UILabel *priceLab;
@end

@implementation WMMoreShopCartGoodCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(200);
        make.height.offset(18);
    }];
    titleLab.font = FONT(13);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.textColor = HEX(@"666666", 1.0);
    self.titleLab = titleLab;
    
    UILabel *guiLab = [UILabel new];
    [self.contentView addSubview:guiLab];
    [guiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(titleLab.mas_bottom).offset(0);
        make.width.offset(200);
        make.height.offset(18);
    }];
    guiLab.font = FONT(11);
    guiLab.lineBreakMode = NSLineBreakByTruncatingTail;
    guiLab.textColor = HEX(@"999999", 1.0);
    self.guiLab = guiLab;
  
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
        make.height.offset(18);
    }];
    priceLab.font = FONT(12);
    priceLab.textColor = HEX(@"666666", 1.0);
    self.priceLab = priceLab;
    
    UILabel *countLab = [UILabel new];
    [self.contentView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-80);
        make.centerY.offset(0);
        make.height.offset(18);
    }];
    countLab.font = FONT(11);
    countLab.textColor = HEX(@"bbbbbb", 1.0);
    self.countLab = countLab;
    
}

-(void)reloadCellWithModel:(WMShopGoodModel *)model{
    self.titleLab.text = model.title;
    self.guiLab.text = model.choosedSize_Name;
    int count = model.current_shopcart_choosedCount == 0 ? model.good_choosedCount : model.current_shopcart_choosedCount;
    self.countLab.text = [NSString stringWithFormat:@"x%d",count];
    self.priceLab.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"¥", NSStringFromClass([self class])),model.price];
    if (model.choosedSize_Name.length == 0) {
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
        }];
    }else{
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(-11);
        }];
    }
}


@end
