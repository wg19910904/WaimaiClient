//
//  JHHomeHeaderView.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeHeaderViewOne.h"
#import "NSMutableArray+SUM.h"
#import "XHLabel.h"
#import "XHImageView.h"
@implementation JHHomeHeaderViewOne
{
    XHImageView *_bgIV;        //整个view的背景图
    UIView *_locatonV;         //整个地址view
    UIImageView *_addrLeftIV; //地址左侧图片
    XHLabel *_addrL;          //地址
    UIImageView *_addrRightIV;//地址右侧图片
    UITextField *_searchF;    //搜索框
    UIScrollView *_recommendV;      //搜索框下的推荐词
    UIView *_weatherV;        //天气
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(chooseNewAddr:)
                                                     name:ChooseNewAddress_Notification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(chooseNewAddr:)
                                                     name:ChooseNewAddress_only_show
                                                   object:nil];
    }
    return self;
}
#pragma mark - 添加控件
- (void)setupUI{
    _bgIV = [XHImageView new];
    [self addSubview:_bgIV];
    [_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //
    _locatonV = [UIView new];
    _locatonV.userInteractionEnabled = YES;
    [self addSubview:_locatonV];
    [_locatonV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.height.offset = 44;
        make.top.offset = STATUS_HEIGHT;
        make.width.offset = WIDTH/2;
    }];
    //
    _addrLeftIV = [UIImageView new];
    [_locatonV addSubview:_addrLeftIV];
    [_addrLeftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.top.offset = 13;
        make.width.offset = 14;
        make.height.offset = 18;
    }];
    //
    _addrL = [XHLabel new];
    [_locatonV addSubview:_addrL];
    [_addrL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addrLeftIV.mas_right).offset = 8;
        make.top.offset = 0;
        make.height.offset = 44;
        make.width.lessThanOrEqualTo(@(WIDTH/2-25));
    }];
    _addrL.font = FONT(18);
    _addrL.textColor = HEX(@"333333", 1.0);
    _addrL.text = NSLocalizedString(@"定位中...", nil);
    //
    _addrRightIV = [UIImageView new];
    [_locatonV addSubview:_addrRightIV];
    [_addrRightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addrL.mas_right).offset = 7;
        make.centerY.equalTo(_addrL.mas_centerY);
        make.width.offset = 10;
        make.height.offset = 7.3;
    }];
    //
    _searchF = [UITextField new];
    [self addSubview:_searchF];
    [_searchF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.top.offset = NAVI_HEIGHT;
        make.right.offset = -12;
        make.height.offset = 32;
    }];
    _searchF.font = FONT(14);
    _searchF.textColor = HEX(@"999999", 1.0);
    _searchF.placeholder = NSLocalizedString(@"输入商家,商品名称", nil);
    _searchF.backgroundColor = HEX(@"ededed", 1.0);
    _searchF.layer.cornerRadius = 4;
    _searchF.clipsToBounds = YES;
    _searchF.delegate = self;
    //添加搜索框左侧的图片
    UIButton *_searchLeftBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0,36, 32)];
    [_searchLeftBtn setImage:IMAGE(@"icon_search") forState:(UIControlStateNormal)];
    _searchLeftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 16, 10, 8);
    _searchLeftBtn.userInteractionEnabled = NO;
    _searchF.leftViewMode = UITextFieldViewModeAlways;
    _searchF.leftView = _searchLeftBtn;
    //推荐词
    _recommendV = [UIScrollView new];
    [self addSubview:_recommendV];
    [_recommendV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.offset = NAVI_HEIGHT+36;
        make.height.offset = 35;
    }];
    
    //天气
    _weatherV = [UIView new];
    [self addSubview:_weatherV];
    [_weatherV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -12;
        make.top.offset = STATUS_HEIGHT+8;
        make.height.offset = 28;
        make.width.offset = 108;
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    //设置背景图,背景色
    NSString *bgColor = dataDic[@"background_color"];
    if (bgColor.length) {
        _bgIV.backgroundColor = HEX(bgColor, 1.0);
    }
    //设置地址文字的颜色
    NSString *textColor = dataDic[@"color"];
    if (textColor.length) _addrL.textColor = HEX(textColor, 1.0);
    //设置地址左右侧图片
    NSString *leftImg = dataDic[@"icon_location"];
    [_addrLeftIV sd_setImageWithURL:[NSURL URLWithString:leftImg]
                   placeholderImage:IMAGE(@"icon_location_gray")];
    NSString *rightImg = dataDic[@"icon_down"];
    [_addrRightIV sd_setImageWithURL:[NSURL URLWithString:rightImg]
                    placeholderImage:IMAGE(@"to_btn_arrowd_gray")];
    //设置搜索词
    NSMutableArray <UIButton *> *btnArr = @[].mutableCopy;
    NSArray *titleArr = dataDic[@"searchBox"][@"keywords"];
    if (titleArr.count >= 6) {
        titleArr = [titleArr subarrayWithRange:NSMakeRange(0, 6)];
    }
    NSMutableArray *widthArr = @[].mutableCopy;
    //
    for (__strong UIView *subV in _recommendV.subviews) {
        [subV removeFromSuperview];
        subV = nil;
    }
    NSUInteger count = titleArr.count;
    NSString *recommendOpen = dataDic[@"searchBox"][@"open"];
    NSString *recommendTextColor = dataDic[@"searchBox"][@"color"];
    if(recommendOpen.integerValue == 1 && count > 0){
        //当有关键词并且开启了关键词重新布局展示
        for (int i = 0; i < count; i++) {
            NSString *text = titleArr[i];
            UIButton *textBtn = [UIButton new];
            [textBtn setTitle:text forState:0];
            [textBtn setTitleColor:HEX(recommendTextColor, 1.0) forState:0];
            textBtn.titleLabel.font = FONT(14);
            [btnArr addObject:textBtn];
            [textBtn addTarget:self action:@selector(clickRecommendTextBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            textBtn.tag = 100+i;
            [_recommendV addSubview:textBtn];
            //
            CGFloat width = getSize(text, 30, 15).width;
            [widthArr addObject:@(width)];
        }
        //重新布局
        CGFloat total_width = [widthArr SUM:count-1];
        if (total_width >= (WIDTH-30)) {
            [widthArr removeLastObject];
            total_width = [widthArr SUM:count-2];
            count = widthArr.count;
        }
        CGFloat interval = (WIDTH-30-total_width)/(count-1);
        CGFloat interval_fix = titleArr.count >= 5 ? MAX(0, interval) : 20;
        for (int i = 0; i<count; i++) {
            UIButton *textBtn = [btnArr objectAtIndex:i];
            //计算当前需要的偏移
            CGFloat left = interval_fix*i+[widthArr SUM:i-1];
            if (isnan(left)) {
                left = 0;
            }
            [textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset = 0;
                make.left.offset = left;
                make.width.offset = [widthArr[i] doubleValue];
                make.height.offset = 30;
            }];
            textBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
    }else{
        [_recommendV removeFromSuperview];
        _recommendV = nil;
    }

    //设置天气
    for (__strong UIView *subV in _weatherV.subviews) {
        [subV removeFromSuperview];
        subV = nil;
    }
    NSString *type = (NSString *)dataDic[@"type"];
    
    /*
     type的类型为3时,展示天气信息
     */
    if(type.integerValue != 3) return;
    //
    NSDictionary *weatherDic = dataDic[@"weather"];
    UIImageView *_weatherImg = [UIImageView new];
    [_weatherV addSubview:_weatherImg];
    [_weatherImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 8;
        make.top.offset = 1;
        make.width.height.offset = 26;
    }];
    _weatherV.layer.cornerRadius =14;
    _weatherV.clipsToBounds = YES;
    _weatherV.backgroundColor = HEX(@"ffffff", 0.7);
    
    NSString *weather_icon = dataDic[@"weather"][@"icon"];
    [_weatherImg sd_setImageWithURL:[NSURL URLWithString:weather_icon]];
    
    //
    UILabel *_temperatureL = [UILabel new];
    [_weatherV addSubview:_temperatureL];
    [_temperatureL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weatherImg.mas_right).offset = 8;
        make.top.bottom.offset = 0;
    }];
    _temperatureL.font = FONT(18);
    _temperatureL.textColor = HEX(@"666666", 1.0);
    _temperatureL.text = weatherDic[@"temperature"];
    _temperatureL.textAlignment = NSTextAlignmentLeft;
    //
    UILabel *_PM2_5_L = [UILabel new];
    [_weatherV addSubview:_PM2_5_L];
    [_PM2_5_L mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_temperatureL.mas_right).offset = 8;
        make.top.offset = 0;
        make.height.offset = 13;
        make.width.offset = 35;
    }];
    _PM2_5_L.font = FONT(9);
    _PM2_5_L.textColor = HEX(@"666666", 1.0);
    _PM2_5_L.text = weatherDic[@"indicator"];
    _PM2_5_L.textAlignment = NSTextAlignmentLeft;
    //
    UILabel *_weatherL = [UILabel new];
    [_weatherV addSubview:_weatherL];
    [_weatherL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_temperatureL.mas_right).offset = 8;
        make.height.offset = 13;
        make.top.equalTo(_PM2_5_L.mas_bottom);
    }];
    _weatherL.font = FONT(9);
    _weatherL.textColor = HEX(@"666666", 1.0);
    _weatherL.text = weatherDic[@"title"];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _searchF) {
        [self clickToSearch];
        return NO;
    }
    return YES;
}
- (void)clickToSearch{
    NSLog(@"点击了商品搜索");
    [NoticeCenter postNotificationName:KNotification_Home_shaixuanDisappear object:nil];
    [NoticeCenter postNotificationName:KNotification_Home_gotoSearch object:nil];
}
- (void)clickRecommendTextBtn:(UIButton *)textBtn{
    NSUInteger index = textBtn.tag - 100;
    NSArray *titleArr = _dataDic[@"searchBox"][@"keywords"];
    NSString *searchStr = titleArr[index];
    [NoticeCenter postNotificationName:KNotification_Home_gotoSearch object:searchStr];
}
- (void)addrL_addTarget:(id)target action:(SEL)action{
    [_addrL addTarget:target action:action];
}
- (void)changeStatusWithOffset_y:(CGFloat)offset_y{
    //当向上滑动38点时,位置完全隐藏
    CGFloat location_alpha = 1.0-(offset_y/38.0);
    _locatonV.alpha = location_alpha;
    _bgIV.alpha =  location_alpha;
    //当滑动超到38点时,推荐词开始变淡,到58时透明度为0
    CGFloat recommendV_alpha = 1.0-(offset_y-38)/20.0;
    _recommendV.alpha = recommendV_alpha;
}

#pragma mark - 位置更新
- (void)chooseNewAddr:(NSNotification *)noti{
    NSString *locationName = [JHConfigurationTool shareJHConfigurationTool].lastCommunity;
    _addrL.text = locationName;
    [_locatonV setNeedsDisplay];  
}

@end
