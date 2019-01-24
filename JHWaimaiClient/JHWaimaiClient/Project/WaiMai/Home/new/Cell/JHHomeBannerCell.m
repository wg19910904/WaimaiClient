//
//  JHHomeBannerCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeBannerCell.h"
#import "YFBannerPlayer.h"
#import "XHImageView.h"
@implementation JHHomeBannerCell
{
    XHImageView *bgIV;
    YFBannerPlayer *scrollBanner;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}
#pragma mark - 布局控件
- (void)setupUI{
    bgIV = [XHImageView new];
    [self.contentView addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
        make.height.offset = 160*KUI_SCALE;
    }];
    [bgIV addTarget:self action:@selector(clickBgImgV:)];
}
//设置数据
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    //设置背景
    NSString *background_color = dataDic[@"background_color"];
    if (background_color.length) {
        bgIV.backgroundColor = HEX(background_color, 1.0);
    }
    //设置轮播
    NSArray *content = dataDic[@"content"];
    NSString *type = dataDic[@"type"];
    [scrollBanner removeFromSuperview];
    scrollBanner = nil;
    if(content.count && type.integerValue == 1){
        NSMutableArray *urlArr = @[].mutableCopy;
        for(NSDictionary *contentDic in content){
            NSString *photo = contentDic[@"photo"];
            [urlArr addObject:photo];
        }
        scrollBanner = [YFBannerPlayer initWithUrlArray:urlArr withFrame:FRAME(12, 12, WIDTH-24, 136*KUI_SCALE) withTimeInterval:2.0];
        scrollBanner.placeHolderImage = @"home_banner_default";
        scrollBanner.clickAD = ^(NSInteger index){
            // 点击广告
            NSDictionary *clickDic = dataDic[@"content"][index];
            NSString *link = clickDic[@"link"];
            [NoticeCenter postNotificationName:KNotification_Home_newLink object:link];
        };
        [self.contentView addSubview:scrollBanner];
    }
}

- (void)clickBgImgV:(UITapGestureRecognizer *)ges{
    NSString *link = _dataDic[@"link"];
    [NoticeCenter postNotificationName:KNotification_Home_newLink object:link];
}
@end
