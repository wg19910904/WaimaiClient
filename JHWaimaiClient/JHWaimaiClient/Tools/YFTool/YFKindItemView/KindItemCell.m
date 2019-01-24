//
//  KindItemCell.m
//  LayoutTest
//
//  Created by ios_yangfei on 16/12/2.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "KindItemCell.h"
#import <UIImageView+WebCache.h>
#import <MJExtension.h>

@interface KindItemCell ()
@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,weak)UILabel *titleLab;

@end

@implementation KindItemCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    BOOL is_5s_se = (WIDTH < 375.0);
    UIImageView *imgView = [UIImageView new];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.top.offset=12;
        make.width.height.offset= is_5s_se ? 35 : 50;
    }];
    self.imgView = imgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.top.equalTo(imgView.mas_bottom).offset=8;
        make.width.offset=self.width;
        make.height.offset = 15;
    }];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = HEX(@"222222", 1.0);
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab = titleLab;
  
}

-(void)reloadCellWithDic:(NSDictionary *)dic{

    dic = [dic mj_keyValues];
    self.titleLab.text = dic[@"title"];
    if (self.textColor) {
        self.titleLab.textColor = HEX(_textColor, 1.0);
    }
    NSString *str = dic[@"icon"];
    str = str.length == 0 ? dic[@"thumb"] : str;
    NSURL *imgUrl;
    if ([str hasPrefix:@"http"]) {
        imgUrl = [NSURL URLWithString:str];
    }else{
        imgUrl  = [NSURL URLWithString:ImageUrl(str)];
    }
   
    [self.imgView sd_setImageWithURL:imgUrl
                    placeholderImage:IMAGE(@"home_icon_mainnav_default")];

}

@end
