//
//  SingleAdCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/4/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "SingleAdCell.h"
#import <UIImageView+WebCache.h>

@interface SingleAdCell()
@property(nonatomic,weak)UIImageView *adImgView;
@end

@implementation SingleAdCell

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
        make.edges.offset = 0;
        make.height.offset = WIDTH*0.3;
    }];
    self.adImgView = imgView;
    imgView.userInteractionEnabled = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAdView)];
    [imgView addGestureRecognizer:tap];
    
}

-(void)reloadCellWithImgUrl:(NSString *)url{
    [self.adImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(url)] placeholderImage:IMAGE(@"index_hengfu_default")];
}

-(void)clickAdView{
    if (self.clickAd) {
        self.clickAd();
    }
}

@end
