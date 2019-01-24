//
//  JHShopCartGoodCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/8/16.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHShopCartGoodCell.h"
#import <UIImageView+WebCache.h>

@interface JHShopCartGoodCell()
@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)UILabel *priceLab;
@end

@implementation JHShopCartGoodCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIImageView *imgView = [UIImageView new];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.width.height.offset(48);
        make.bottom.offset(-10);
    }];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    self.imgView = imgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(8);
        make.centerY.offset(0);
        make.height.offset(20);
        make.width.lessThanOrEqualTo(@100);
    }];
    titleLab.font = FONT(16);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.textColor = HEX(@"333333", 1.0);
    self.titleLab = titleLab;
    
    UILabel *countLab = [UILabel new];
    [self.contentView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-90);
        make.centerY.offset(0);
        make.height.offset(20);
    }];
    countLab.font = FONT(14);
    countLab.textColor = HEX(@"333333", 1.0);
    self.countLab = countLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.offset(0);
        make.height.offset(20);
    }];
    priceLab.font = FONT(16);
    priceLab.textAlignment = NSTextAlignmentRight;
    priceLab.textColor = HEX(@"333333", 1.0);
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
    self.countLab.text = [NSString stringWithFormat:@"x%d",model.good_choosedCount];
    self.titleLab.text = model.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(model.photo)] placeholderImage:IMAGE(@"product60_default")];
    
}

@end
