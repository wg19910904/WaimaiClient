//
//  JHHomeYouhuiCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeADCateCell_more.h"
#import <UIButton+WebCache.h>
@implementation JHHomeADCateCell_more
{
    XHImageView *_titleIV;
    UIScrollView *_scrollV;
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
    //计算scroll的高度
    _scrollV = [UIScrollView new];
    [self.contentView addSubview:_scrollV];
    [_scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.top.offset = 40*KUI_SCALE;
        make.width.offset = WIDTH;
        make.height.offset = 184*KUI_SCALE;
        make.bottom.offset = 0;
    }];
    _scrollV.showsVerticalScrollIndicator = NO;
    _scrollV.showsHorizontalScrollIndicator = NO;
    _scrollV.scrollEnabled = NO;
    _scrollV.backgroundColor = UIColor.clearColor;
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
    //移除子视图
    for (__strong UIView *subV in _scrollV.subviews) {
        [subV removeFromSuperview];
        subV = nil;
    }
    //重新布局
    NSArray *content = dataDic[@"content"];
    for (int i = 0; i < content.count; i++) {
        NSDictionary *contentDic = (NSDictionary *) content[i];
        
        XHButton *btn = [XHButton new];
        btn.tag = 100+i;
        [_scrollV addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = WIDTH/3*(i%3);
            make.top.offset = 92*KUI_SCALE*(i/3);
            make.width.offset = WIDTH/3;
            make.height.offset = 92*KUI_SCALE;
        }];
        NSString *imgStr = contentDic[@"photo"];
        NSURL *img_url = [NSURL URLWithString:imgStr];
        [btn.imgV sd_setImageWithURL:img_url];
//        btn.title.text = contentDic[@"title"];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

//点击了标题
- (void)clickTitleV:(UITapGestureRecognizer *)ges{
    NSString *link = _dataDic[@"link"];
    [NoticeCenter postNotificationName:KNotification_Home_newLink object:link];
}

- (void)clickBtn:(XHButton *)sender{
    NSUInteger index = sender.tag - 100;
    NSDictionary *clickDic = (NSDictionary *)_dataDic[@"content"][index];
    NSString *link = clickDic[@"link"];
    [NoticeCenter postNotificationName:KNotification_Home_newLink  object:link];
}
@end



@implementation XHButton


- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _imgV = [UIImageView new];
    [self addSubview:_imgV];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset = 68;
        make.centerY.offset = 0;
        make.centerX.offset = 0;
    }];
    
    _title = [UILabel new];
    [self addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset = 30;
        make.bottom.offset = 0;
        make.centerX.offset = 0;
    }];
    _title.font = FONT(15);
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = HEX(@"222222", 1.0);
}


@end


