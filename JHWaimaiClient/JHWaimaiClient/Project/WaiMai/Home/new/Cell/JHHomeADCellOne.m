//
//  JHHomeYouhuiCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeADCellOne.h"

@implementation JHHomeADCellOne
{
    XHImageView *_titleIV;
    XHImageView *_adIV; //广告
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
        make.left.right.offset = 0;
        make.top.offset = 0;
        make.height.offset = 40*KUI_SCALE;
    }];
    [_titleIV addTarget:self action:@selector(clickTitleV:)];
    //
    _adIV = [XHImageView new];
    _adIV.contentMode = UIViewContentModeScaleAspectFill;
    _adIV.clipsToBounds = YES;
    [self.contentView addSubview:_adIV];
    [_adIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.top.offset = 40*KUI_SCALE;
        make.right.offset = -12;
        make.height.offset = (WIDTH-24)/350*110;
        make.bottom.offset = -12;
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    //背景色
    NSString *background_color = dataDic[@"background_color"];
    if (background_color.length) {
        self.backgroundColor = HEX(background_color, 1.0);
    }
    //_titleIV
    NSString *photo = dataDic[@"photo"];
    [_titleIV sd_setImageWithURL:[NSURL URLWithString:photo]];
    //
    NSString *imgStr = [dataDic[@"content"][0] valueForKey:@"photo"];
    NSURL *img_url = [NSURL URLWithString:imgStr];
    [_adIV sd_setImageWithURL:img_url];
    [_adIV addTarget:self action:@selector(clickImgV:)];
}
//点击了标题
- (void)clickTitleV:(UITapGestureRecognizer *)ges{
    NSString *link = _dataDic[@"link"];
    [NoticeCenter postNotificationName:KNotification_Home_newLink object:link];
}

- (void)clickImgV:(UITapGestureRecognizer *)ges{
    NSString *link = [_dataDic[@"content"][0] valueForKey:@"link"];
    [NoticeCenter postNotificationName:KNotification_Home_newLink object:link];
    
}
@end


