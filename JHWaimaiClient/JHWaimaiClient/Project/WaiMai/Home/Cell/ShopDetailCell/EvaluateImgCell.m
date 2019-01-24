//
//  EvaluateImgCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "EvaluateImgCell.h"
#import <UIImageView+WebCache.h>

@implementation EvaluateImgCell

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
        make.edges.offset = 0;
    }];
    imgView.layer.borderColor=HEX(@"dae1e6", 1.0).CGColor;
    imgView.layer.borderWidth=0.5;
//    imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView = imgView;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    
}

-(void)setImgUrl:(NSString *)imgUrl{
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(imgUrl)] placeholderImage:IMAGE(@"cate_img_default")];
    
}

@end
