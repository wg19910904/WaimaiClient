//
//  WaiMaiSpecialAdCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/4.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WaiMaiSpecialAdCell.h"
#import <UIImageView+WebCache.h>

#define img_tag 200

@interface WaiMaiSpecialAdCell ()

@end

@implementation WaiMaiSpecialAdCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    self.contentView.backgroundColor = BACK_COLOR;
    for (NSInteger i=0; i<3; i++) {
        
        UIImageView *imgView = [UIImageView new];
        [self.contentView addSubview:imgView];
        imgView.tag = img_tag + i;
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImg:)];
        [imgView addGestureRecognizer:tap];
        
        if (i == 0) {
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=0;
                make.top.offset=0;
                make.width.offset=WIDTH * 0.45;
                make.height.offset=WIDTH * 0.5;
                make.bottom.offset = 0;
            }];
        }else{
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset=0;
                make.top.offset= (i - 1) * WIDTH * 0.25;
                make.width.offset=WIDTH * 0.55;
                make.height.offset=WIDTH * 0.25;
            }];
        }
        imgView.layer.cornerRadius=4;
        imgView.clipsToBounds=YES;
        
    }
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=0;
        make.top.offset=  WIDTH * 0.25 - 0.5;
        make.width.offset=WIDTH * 0.55;
        make.height.offset=1;
    }];
    lineView.backgroundColor=BACK_COLOR;
    
    UIView *vLineView=[UIView new];
    [self.contentView addSubview:vLineView];
    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=WIDTH * 0.45 - 0.5;
        make.top.offset=0;
        make.width.offset=1;
        make.bottom.offset = 0;
    }];
    vLineView.backgroundColor=BACK_COLOR;
    
}

-(void)reloadCellWithArr:(NSArray *)ads{
    
    for (NSInteger i=0; i<3; i++) {
        
        UIImageView *imgView = [self.contentView viewWithTag:img_tag+i];
        NSString *url = ImageUrl(ads[i]);
        NSString *placeHolder = @"toutiao70_default";
        if (i != 0) {
            placeHolder= @"index_hengfu_default";
        }
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(placeHolder)];
        
    }
}

#pragma mark ====== 点击广告 =======
-(void)clickImg:(UITapGestureRecognizer *)tap{
    
    if (self.clickAd) {
        NSInteger index = tap.view.tag - img_tag;
        self.clickAd(index);
    }
    
}

@end
