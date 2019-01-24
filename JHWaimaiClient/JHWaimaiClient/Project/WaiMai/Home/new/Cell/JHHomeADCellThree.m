//
//  JHHomeYouhuiCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeADCellThree.h"

@implementation JHHomeADCellThree
{
    XHImageView *_titleIV;
    XHImageView *_adIV1; //广告
    XHImageView *_adIV2; //广告
    XHImageView *_adIV3; //广告
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //UI
        self.backgroundColor = UIColor.clearColor;
        [self setupUI];
    }
    return self;
}
#pragma mark - UI
- (void)setupUI{
    _titleIV = [XHImageView new];
    _titleIV.tag = 200;
    [self.contentView addSubview:_titleIV];
    [_titleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 40*KUI_SCALE;
    }];
    [_titleIV addTarget:self action:@selector(clickTitleV:)];
    //
    _adIV1 = [XHImageView new];
    [self.contentView addSubview:_adIV1];
    [_adIV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.top.offset = 40*KUI_SCALE;
        make.right.equalTo(self.mas_centerX).offset = -2;
        make.height.offset = (WIDTH-27)/2/174*228;
        make.bottom.offset = -12;
    }];
    _adIV1.tag = 100;
    //
    _adIV2 = [XHImageView new];
    [self.contentView addSubview:_adIV2];
    [_adIV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_adIV1.mas_right).offset = 3;
        make.top.offset = 40*KUI_SCALE;
        make.width.offset = (WIDTH-27)/2;
        make.height.offset = (WIDTH-27)/2/174*112;
    }];
    _adIV2.tag = 101;
    //
    _adIV3 = [XHImageView new];
    [self.contentView addSubview:_adIV3];
    [_adIV3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_adIV1.mas_right).offset = 3;
        make.width.offset = (WIDTH-27)/2;
        make.height.offset = (WIDTH-27)/2/174*112;
        make.bottom.offset = -12;
    }];
    _adIV3.tag = 102;
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    //背景色
    NSString *background_color = dataDic[@"background_color"];
    if (background_color.length) {
        self.backgroundColor = HEX(background_color, 1.0);
    }
    //
    NSString *photo = dataDic[@"photo"];
    [_titleIV sd_setImageWithURL:[NSURL URLWithString:photo]];
    [_titleIV addTarget:self action:@selector(clickTitleV:)];
    //
    NSString *img1 = [dataDic[@"content"][0] valueForKey:@"photo"];
    NSURL *img_url = [NSURL URLWithString:img1];
    [_adIV1 sd_setImageWithURL:img_url];
    [_adIV1 addTarget:self action:@selector(clickImgV:)];
    
    NSString *img2 = [dataDic[@"content"][1] valueForKey:@"photo"];
    NSURL *img_url2 = [NSURL URLWithString:img2];
    [_adIV2 sd_setImageWithURL:img_url2];
    [_adIV2 addTarget:self action:@selector(clickImgV:)];
    
    NSString *img3= [dataDic[@"content"][2] valueForKey:@"photo"];
    NSURL *img_url3= [NSURL URLWithString:img3];
    [_adIV3 sd_setImageWithURL:img_url3];
    [_adIV3 addTarget:self action:@selector(clickImgV:)];
}

//点击了标题
- (void)clickTitleV:(UITapGestureRecognizer *)ges{
    NSString *link = _dataDic[@"link"];
    [NoticeCenter postNotificationName:KNotification_Home_newLink object:link];
}

- (void)clickImgV:(UITapGestureRecognizer *)ges{
    UIView *imgV = ges.view;
    NSUInteger index = imgV.tag - 100;
    NSDictionary *clickDic = (NSDictionary *)_dataDic[@"content"][index];
    NSString *link = clickDic[@"link"];
    [NoticeCenter postNotificationName:KNotification_Home_newLink object:link];
}
@end


