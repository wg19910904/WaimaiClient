//
//  JHHomeHeaderView.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeHeaderViewTwo.h"
#import "NSMutableArray+SUM.h"
#import "XHLabel.h"
#import "XHImageView.h"
@implementation JHHomeHeaderViewTwo
{
    XHImageView *_bgIV;        //整个view的背景图
    UIView *_locatonV;         //整个地址view
    UIImageView *_addrLeftIV; //地址左侧图片
    XHLabel *_addrL;          //地址
    UIImageView *_addrRightIV;//地址右侧图片
    UITextField *_searchF;    //搜索框
    UIScrollView *_recommendV;   //搜索框下的推荐词
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
    _addrLeftIV.image = IMAGE(@"icon_location_gray");
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
    _addrRightIV.image = IMAGE(@"to_btn_arrowd_gray");
    //
    _searchF = [UITextField new];
    [self addSubview:_searchF];
    [_searchF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 112;
        make.top.offset = STATUS_HEIGHT+6;
        make.right.offset = -12;
        make.height.offset = 32;
    }];
    _searchF.font = FONT(14);
    _searchF.textColor = HEX(@"999999", 1.0);
    _searchF.placeholder = NSLocalizedString(@"搜索", nil);
    _searchF.backgroundColor = HEX(@"ededed", 1.0);
    _searchF.layer.cornerRadius = 16;
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
        make.top.offset = NAVI_HEIGHT;
        make.height.offset = 30;
    }];
}

- (void)addrL_addTarget:(id)target action:(SEL)action{
    [_addrL addTarget:target action:action];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _searchF) {
        [self clickToSearch];
        return NO;
    }
    return YES;
}

- (void)changeStatusWithOffset_y:(CGFloat)offset_y{
    

}

//设置数据
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
    [_addrLeftIV sd_setImageWithURL:[NSURL URLWithString:leftImg]];
    NSString *rightImg = dataDic[@"icon_down"];
    [_addrRightIV sd_setImageWithURL:[NSURL URLWithString:rightImg]];
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
            [_recommendV addSubview:textBtn];
            //
            CGFloat width = getSize(text, 30, 15).width;
            [widthArr addObject:@(width)];
            textBtn.tag = 100+i;
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
        }
    }else{
        [_recommendV removeFromSuperview];
        _recommendV = nil;
    }
}
- (void)clickToSearch{
    NSLog(@"点击了商品搜索");
    [NoticeCenter postNotificationName:KNotification_Home_gotoSearch object:nil];
}

- (void)clickRecommendTextBtn:(UIButton *)textBtn{
    NSUInteger index = textBtn.tag - 100;
    NSArray *titleArr = _dataDic[@"searchBox"][@"keywords"];
    NSString *searchStr = titleArr[index];
    [NoticeCenter postNotificationName:KNotification_Home_gotoSearch object:searchStr];
}

#pragma mark - 位置更新
- (void)chooseNewAddr:(NSNotification *)noti{
    NSString *locationName = [JHConfigurationTool shareJHConfigurationTool].lastCommunity;
    _addrL.text = locationName;
    [_locatonV setNeedsDisplay];
}

@end
