//
//  JHXuanTingView.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/27.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHXuanTingView.h"
#import "JHHomeShaiXuanView.h"
#import "XHLabel.h"

@implementation JHXuanTingView
{
    UITextField *_searchF;    //搜索框
    JHHomeShaiXuanView *_shaiXuanV;
    //第二种悬停样式,需要用到的额外的控件
    UIView *_locatonV;         //整个地址view
    UIImageView *_addrLeftIV; //地址左侧图片
    XHLabel *_addrL;          //地址
    UIImageView *_addrRightIV;//地址右侧图片
    //
    CALayer *line;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        //选择新的地址
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(chooseNewAddr:)
                                                     name:ChooseNewAddress_Notification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(chooseNewAddr:)
                                                     name:ChooseNewAddress_only_show
                                                   object:nil];
        //筛选提交发生改变
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(shaixuanChanged:)
                                                     name:KNotification_Home_shaixuanChanged
                                                   object:nil];
    }
    return self;
}
- (void)setXuan_ting_type:(E_XUANTING_TYPE)xuan_ting_type{
    _xuan_ting_type = xuan_ting_type;
    //
    _searchF = [UITextField new];
    [self addSubview:_searchF];
    _searchF.font = FONT(14);
    _searchF.textColor = HEX(@"999999", 1.0);
    _searchF.delegate = self;
    //添加搜索框左侧的图片
    UIButton *_searchLeftBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0,36, 32)];
    [_searchLeftBtn setImage:IMAGE(@"icon_search") forState:(UIControlStateNormal)];
    _searchLeftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 16, 10, 8);
    _searchLeftBtn.userInteractionEnabled = NO;
    _searchF.leftViewMode = UITextFieldViewModeAlways;
    _searchF.leftView = _searchLeftBtn;
    //
    if (self.xuan_ting_type == E_XUANTING_TYPE_ONE) {
        self.hidden = YES;
        //第一种悬停
        [_searchF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.top.offset = STATUS_HEIGHT+6;
            make.right.offset = -12;
            make.height.offset = 32;
        }];
        _searchF.layer.cornerRadius = 4;
        _searchF.clipsToBounds = YES;
        _searchF.placeholder = NSLocalizedString(@"输入商家,商品名称", nil);
        _searchF.backgroundColor = HEX(@"ffffff", 1.0);
    }else{
        self.hidden = NO;
        self.frame = FRAME(0, 0, WIDTH, NAVI_HEIGHT);
        //第二种悬停
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
        [self bringSubviewToFront:_searchF];
        [_searchF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 112;
            make.top.offset = STATUS_HEIGHT+6;
            make.right.offset = -12;
            make.height.offset = 32;
        }];
        _searchF.layer.cornerRadius = 16;
        _searchF.clipsToBounds = YES;
        _searchF.placeholder = NSLocalizedString(@"搜索", nil);
        _searchF.backgroundColor = HEX(@"ededed", 1.0);
    }
    //
    _shaiXuanV = [JHHomeShaiXuanView new];
    _shaiXuanV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_shaiXuanV];
    [_shaiXuanV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = NAVI_HEIGHT;
        make.left.right.offset = 0;
        make.height.offset = 44;
        make.bottom.offset = 0;
    }];
    _shaiXuanV.titleArr = @[NSLocalizedString(@"全部分类   ",nil),
                            NSLocalizedString(@"排序   ",nil),
                            NSLocalizedString(@"筛选   ",nil)];
    //添加线
    line = [CALayer layer];
    line.frame = FRAME(0,43.5+NAVI_HEIGHT, WIDTH, 0.5);
    line.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:line];
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
    [_shaiXuanV.filterView filterTableHidden];
    [NoticeCenter postNotificationName:KNotification_Home_gotoSearch object:nil];
}
- (void)addrL_addTarget:(id)target action:(SEL)action{
    if (_addrL) {
        [_addrL addTarget:target action:action];
    }
}
- (void)changeStatusWithOffset_y:(CGFloat)offset_y showFenLei:(BOOL)show{
    if (self.xuan_ting_type == E_XUANTING_TYPE_ONE) {
        //当向上滚动38点时展示搜索
        self.hidden = offset_y < 38;
    }else{
        //更改搜索框的frame
        CGFloat add_width = (WIDTH-24)-112;
        [_searchF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 112 + MAX(0, add_width * MIN(1, offset_y/150));
        }];
        //是否显示或者隐藏
        _locatonV.alpha = 1 - offset_y/150;
        self.hidden = offset_y <= 0;
    }
    self.frame = FRAME(0, 0, WIDTH, NAVI_HEIGHT + (show ? 44 : 0));
}

//设置数据
- (void)setDataDic:(NSDictionary *)dataDic{
//    //设置地址文字的颜色
//    NSString *textColor = dataDic[@"color"];
//    _addrL.textColor = HEX(textColor, 1.0);
    //设置地址左右侧图片
    NSString *leftImg = dataDic[@"icon_location"];
    [_addrLeftIV sd_setImageWithURL:[NSURL URLWithString:leftImg]
                   placeholderImage:IMAGE(@"icon_location_gray")];
    NSString *rightImg = dataDic[@"icon_down"];
    [_addrRightIV sd_setImageWithURL:[NSURL URLWithString:rightImg]
                    placeholderImage:IMAGE(@"to_btn_arrowd_gray")];
}
#pragma mark - 位置更新
- (void)chooseNewAddr:(NSNotification *)noti{
    NSString *locationName = [JHConfigurationTool shareJHConfigurationTool].lastCommunity;
    _addrL.text = locationName;
    [_locatonV setNeedsDisplay];
}
#pragma mark - 筛选条件发生改变,更新title
- (void)shaixuanChanged:(NSNotification *)noti{
    NSDictionary *filterDic = (NSDictionary *)noti.object;
    _shaiXuanV.titleArr = @[filterDic[@"title1"],
                            filterDic[@"title2"],
                            NSLocalizedString(@"筛选   ",nil)];
}
@end
