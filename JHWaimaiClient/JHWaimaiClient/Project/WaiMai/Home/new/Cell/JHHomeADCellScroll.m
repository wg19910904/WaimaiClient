//
//  JHHomeYouhuiCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeADCellScroll.h"

@implementation JHHomeADCellScroll
{
    XHImageView *_titleIV;
    UIScrollView *_scrollV;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        //UI
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
        make.left.offset = 0;
        make.top.right.offset = 0;
        make.height.offset = 40*KUI_SCALE;
    }];
    [_titleIV addTarget:self action:@selector(clickTitleV:)];
    //计算scroll的高度
    _scrollV = [UIScrollView new];
    [self.contentView addSubview:_scrollV];
    [_scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.top.offset = 40*KUI_SCALE;
        make.width.offset = WIDTH;
        make.height.offset = 160;
        make.bottom.offset = -12;
    }];
    _scrollV.showsVerticalScrollIndicator = NO;
    _scrollV.showsHorizontalScrollIndicator = NO;
}
//设置数据
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    //
    NSString *background_color = dataDic[@"background_color"];
    if (background_color.length) {
        self.backgroundColor = HEX(background_color, 1.0);
    }
    //_titleIV
    NSString *photo = dataDic[@"photo"];
    [_titleIV sd_setImageWithURL:[NSURL URLWithString:photo]];
    //移除子视图
    for (__strong UIView *subV in _scrollV.subviews) {
        [subV removeFromSuperview];
        subV = nil;
    }
    //重新布局
    NSArray *content = dataDic[@"content"];
    NSUInteger count = content.count;
    for (int i = 0; i < count; i++) {
        NSDictionary *contentDic = (NSDictionary *)content[i];
        NSString *url = [contentDic valueForKey:@"photo"];
        
        XHImageView *iv = [XHImageView new];
        [_scrollV addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12+(i)*(10+120);
            make.top.offset = 0;
            make.width.offset = 120;
            make.height.offset = 160;
        }];
        iv.layer.cornerRadius = 4;
        iv.clipsToBounds = YES;
        iv.tag = 100+i;
        NSURL *img_url = [NSURL URLWithString:url];
        [iv sd_setImageWithURL:img_url];
        [iv addTarget:self action:@selector(clickImgV:)];
    }
    _scrollV.contentSize = CGSizeMake(MAX(WIDTH, 130*count+2+12), 160);
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


