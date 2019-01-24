//
//  JHHomeADCell_singleImg.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeADCell_MarginImg.h"

@implementation JHHomeADCell_MarginImg
{
    XHImageView *_iv;
    UIView *_line1;
    UIView *_line2;
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
- (void)setupUI{
    _line1 = [UIView new];
    [self.contentView addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset = 0;
        make.height.offset = 8;
    }];
    _line1.backgroundColor = HEX(@"f6f6f6", 1.0);
    //
    _iv = [XHImageView new];
    [self.contentView addSubview:_iv];
    [_iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.right.offset = -12;
        make.top.offset = 16;
        make.height.offset = (WIDTH-24)/351*88;
    }];
    [_iv addTarget:self action:@selector(clickImagV:)];
    //
    _line2 = [UIView new];
    [self.contentView addSubview:_line2];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 8;
        make.top.equalTo(_iv.mas_bottom).offset = 8;
        make.bottom.offset = 0;
    }];
    _line2.backgroundColor = HEX(@"f6f6f6", 1.0);
}
//点击了标题
- (void)clickImagV:(UITapGestureRecognizer *)ges{
    NSString *link = _dataDic[@"link"];
    [NoticeCenter postNotificationName:KNotification_Home_newLink object:link];
}
//设置数据
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    //背景色
    NSString *background_color = dataDic[@"background_color"];
    if (background_color.length) {
        self.backgroundColor = HEX(background_color, 1.0);
    }else{
//        _line1.ba
    }
    //
    NSString *imgStr = dataDic[@"photo"];
    [_iv sd_setImageWithURL:[NSURL URLWithString:imgStr]];
}
@end
