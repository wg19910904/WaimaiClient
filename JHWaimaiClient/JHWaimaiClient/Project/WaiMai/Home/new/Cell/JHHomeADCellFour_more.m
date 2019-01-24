//
//  JHHomeYouhuiCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeADCellFour_more.h"

@implementation JHHomeADCellFour_more
{
    XHImageView *_titleIV;
    NSMutableArray *_ivArr;
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
    CGFloat _titleIV_H = 40*KUI_SCALE;
    [_titleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 40*KUI_SCALE;
    }];
    [_titleIV addTarget:self action:@selector(clickTitleV:)];
    //
    _ivArr = [NSMutableArray arrayWithCapacity:4];
    CGFloat img_height = (WIDTH-32)/2/171*110;
    for (int i = 0; i < 4; i++) {
        XHImageView *iv = [XHImageView new];
        [self.contentView addSubview:iv];
        iv.tag = 100+i;
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = ((i%2) == 0) ? 12 : (WIDTH/2+4);
            make.top.offset = (i<2) ? _titleIV_H : img_height+_titleIV_H+12;
            make.height.offset = img_height;
            make.width.offset = (WIDTH-32)/2;
        }];
        [_ivArr addObject:iv];
        
        if (i == 3) {
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset = 0;
            }];
        }
    }
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
    NSArray *content = dataDic[@"content"];
    NSUInteger count = _ivArr.count;
    for (int i = 0 ; i < count; i++) {
        NSDictionary *contentDic = (NSDictionary *)[content objectAtIndex:i];
        NSString *imgStr = contentDic[@"photo"];
        XHImageView *iv = (XHImageView *)[_ivArr objectAtIndex:i];
        NSURL *img_url = [NSURL URLWithString:imgStr];
        [iv sd_setImageWithURL:img_url];
        [iv addTarget:self action:@selector(clickImgV:)];
    }
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
    [NoticeCenter postNotificationName:KNotification_Home_newLink  object:link];
}

@end


