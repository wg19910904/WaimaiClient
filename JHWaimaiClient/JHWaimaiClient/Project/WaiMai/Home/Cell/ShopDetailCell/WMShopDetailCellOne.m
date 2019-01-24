//
//  WMShopDetailCellOne.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopDetailCellOne.h"

@interface WMShopDetailCellOne ()
@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,weak)UILabel *titleLab;
@end

@implementation WMShopDetailCellOne

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
        make.left.offset=10;
        make.centerY.offset=0;
        make.width.offset=16;
        make.height.offset=16;
    }];
    imgView.contentMode = UIViewContentModeCenter;
    self.imgView = imgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset=10;
        make.centerY.offset=0;
        make.right.offset=-10;
        make.height.offset=15;
    }];
    titleLab.textColor = TEXT_COLOR;
    titleLab.font = FONT(14);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLab = titleLab;
    
}

-(void)reloadCellWith:(NSString *)imgName title:(NSString *)title{
    self.imgView.image = IMAGE(imgName);
    self.titleLab.text = title;
}

@end
