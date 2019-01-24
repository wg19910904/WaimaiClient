//
//  JHHomeShopCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeShopCell.h"
#import "YFStartView.h"
#import "XHImageView.h"
#import "JHShopHuodongView.h"
#import "UILabel+XHTool.h"

@implementation JHHomeShopCell
{
    XHImageView *_shopIV;           //商家logo
    UILabel *_shopTitleL;           //商家店名
    UILabel *_tipL;                 //提示用户的语句
    UIImageView *_starV;            //星星图
    UILabel *_starL;                //星星数量
    UILabel *_yueShouL;             //月售数量
    UILabel *_songTypeL;            //配送方式
    UILabel *_qi_pei_songL;         //起送和配送价格
    UILabel *_orignalPeiL;          //划掉的配送费标签
    UILabel *_time_distanceL;       //时间和距离
    UIView *_line;
    UIView *_biaoQianV;             //标签view
    UIView *_huodongV1;             //活动样式1----显示时,3个以上活动会出现 x个活动字样及箭头
    JHShopHuodongView *_huodongV2;  //活动样式2
    YFTypeBtn *_huodongCountBtn;    //活动数量
    UIImageView *_is_newImgv;       //是否是新店
    UILabel *_productsNumL;         //购物车内该店铺的商品数量
    UILabel *_restL;                //是否打烊
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self setupUI];
    }
    return self;
}

#pragma mark - 布局
- (void)setupUI{
    _shopIV = [XHImageView new];
    [self.contentView addSubview:_shopIV];
    [_shopIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.top.offset = 16;
        make.width.height.offset = 80;
    }];
    _shopIV.layer.cornerRadius = 4;
    _shopIV.clipsToBounds = YES;
    //
    _productsNumL = [UILabel new];
    [self.contentView addSubview:_productsNumL];
    [_productsNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_shopIV.mas_right);
        make.top.offset = 6;
        make.width.height.offset = 20;
    }];
    _productsNumL.layer.cornerRadius = 10;
    _productsNumL.layer.masksToBounds = YES;
    _productsNumL.backgroundColor = HEX(@"FF4D5B", 1.0);
    _productsNumL.font = FONT(14);
    _productsNumL.textColor = HEX(@"ffffff", 1.0);
    _productsNumL.textAlignment = NSTextAlignmentCenter;
    _productsNumL.hidden = YES;
    //
    _is_newImgv = [UIImageView new];
    [_shopIV addSubview:_is_newImgv];
    [_is_newImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset = 0;
        make.width.height.offset = 32;
    }];
    //
    _restL = [UILabel new];
    [_shopIV addSubview:_restL];
    [_restL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset = 0;
        make.height.offset = 18;
    }];
    _restL.font = FONT(14);
    _restL.text = NSLocalizedString(@"已打烊", nil);
    _restL.textAlignment = NSTextAlignmentCenter;
    _restL.backgroundColor = HEX(@"000000", 0.5);
    _restL.textColor = UIColor.whiteColor;
    _restL.hidden = YES;
    //
    _shopTitleL = [UILabel new];
    [self.contentView addSubview:_shopTitleL];
    [_shopTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 104;
        make.right.offset = -12;
        make.top.offset = 15;
        make.height.offset = 20;
    }];
    _shopTitleL.font = B_FONT(16.5);
    _shopTitleL.textColor = HEX(@"222222", 1.0);
    //
    _tipL = [UILabel new];
    [self.contentView addSubview:_tipL];
    [_tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shopTitleL.mas_left);
        make.top.equalTo(_shopTitleL.mas_bottom).offset(10);
        make.height.offset = 0;
        make.width.mas_lessThanOrEqualTo(WIDTH-130);
    }];
    _tipL.backgroundColor = HEX(@"4DBD4D", 1.0);
    _tipL.layer.cornerRadius = 2;
    _tipL.layer.masksToBounds = YES;
    _tipL.font = FONT(11);
    _tipL.textColor = HEX(@"ffffff", 1.0);
    _tipL.textAlignment = NSTextAlignmentCenter;
    
    //
    _starV = [UIImageView new];
    [self.contentView addSubview:_starV];
    [_starV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_shopIV.mas_right).offset=12;
        make.top.equalTo(self->_shopTitleL.mas_bottom).offset=12;
        make.height.width.offset = 12;
    }];
    _starV.image = IMAGE(@"Star-red");
    //
    _starL = [UILabel new];
    [self.contentView addSubview:_starL];
    [_starL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_starV.mas_right).offset = 4;
        make.height.offset = 18;
        make.width.offset = 24;
        make.centerY.equalTo(_starV.mas_centerY);
    }];
    _starL.font = FONT(14);
    _starL.textColor = HEX(@"FF4D5B", 1.0);
    //
    _yueShouL = [UILabel new];
    [self.contentView addSubview:_yueShouL];
    [_yueShouL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_starL.mas_right).offset = 13;
        make.centerY.equalTo(_starV.mas_centerY);
        make.height.offset = 16;
        make.width.offset = 100;
    }];
    _yueShouL.font = FONT(14);
    _yueShouL.textColor = HEX(@"333333", 1.0);
    //
    _time_distanceL = [UILabel new];
    [self.contentView addSubview:_time_distanceL];
    [_time_distanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -12;
        make.centerY.equalTo(_yueShouL);
        make.height.offset = 18;
    }];
    _time_distanceL.font = FONT(14);
    _time_distanceL.textColor = HEX(@"666666", 1.0);
    //
    _qi_pei_songL = [UILabel new];
    [self.contentView addSubview:_qi_pei_songL];
    [_qi_pei_songL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_shopTitleL.mas_left);
        make.top.equalTo(_starV.mas_bottom).offset = 10;
        make.height.offset = 18;
//        make.right.lessThanOrEqualTo(self->_time_distanceL.mas_left);
    }];
    _qi_pei_songL.textColor = HEX(@"666666", 1.0);
    _qi_pei_songL.font = FONT(14);
    //
    _orignalPeiL = [UILabel new];
    [self.contentView addSubview:_orignalPeiL];
    [_orignalPeiL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_qi_pei_songL.mas_right).offset = 5;
        make.centerY.equalTo(_qi_pei_songL.mas_centerY);
        make.height.offset = 18;
        make.width.greaterThanOrEqualTo(@(15));
    }];
    _orignalPeiL.font = FONT(12);
    _orignalPeiL.textColor = HEX(@"cccccc", 1.0);
    _orignalPeiL.textAlignment = NSTextAlignmentCenter;
    
    UIView *peiLine = [UIView new];
    [_orignalPeiL addSubview:peiLine];
    [peiLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.centerY.offset = 0;
        make.height.offset = 0.7;
    }];
    peiLine.backgroundColor = HEX(@"cccccc", 1.0);
    
    //
    _songTypeL = [UILabel new];
    _songTypeL.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_songTypeL];
    [_songTypeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -12;
        make.width.offset = 48;
        make.height.offset = 18;
        make.centerY.equalTo(_qi_pei_songL);
    }];
    _songTypeL.frame = FRAME(WIDTH-12-48, 43, 48, 18);
    _songTypeL.font = FONT(10);
    _songTypeL.textAlignment = NSTextAlignmentCenter;
    //添加分割线
    _line = [UIView new];
    [self.contentView addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -12;
        make.height.offset = 1;
        make.left.equalTo(self->_shopTitleL.mas_left);
        make.top.equalTo(self->_qi_pei_songL.mas_bottom).offset = 10;
    }];
    _line.backgroundColor = HEX(@"f6f6f6", 1.0);
    //
    _biaoQianV = [UIView new];
    [self.contentView addSubview:_biaoQianV];
    [_biaoQianV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_shopTitleL.mas_left);
        make.top.equalTo(_line.mas_bottom).offset = 11;
        make.height.offset = 18;
        make.right.offset = 0;
    }];
    for (int i = 0 ;i<2;i++) {
        UILabel *biaoqianL = [UILabel new];
        [_biaoQianV addSubview:biaoqianL];
        [biaoqianL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = (54+4)*i;
            make.width.offset = 54;
            make.top.bottom.offset = 0;
        }];
        biaoqianL.layer.cornerRadius = 2;
        biaoqianL.clipsToBounds = YES;
        biaoqianL.font = FONT(12);
        biaoqianL.textAlignment = NSTextAlignmentCenter;
        biaoqianL.textColor = HEX(@"20ad20", 1.0);
        biaoqianL.layer.borderColor = HEX(@"20ad20", 1.0).CGColor;
        biaoqianL.layer.borderWidth = 0.5;
        biaoqianL.tag = 100+i;
    }
    //添加活动样式1
    _huodongV1 = [UIView new];
    [self.contentView addSubview:_huodongV1];
    [_huodongV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_shopTitleL.mas_left);
        make.right.offset = -12;
        make.bottom.offset = 0;
        make.top.equalTo(self->_biaoQianV.mas_bottom).offset = 12;
        make.height.offset = 24 * 3; //默认3行
    }];
    
    for(int i = 0 ; i < 10 ; i ++) {
        UILabel *typeL = [UILabel new];
        [_huodongV1 addSubview:typeL];
        [typeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.top.offset = 24*i;
            make.width.height.offset = 16;
        }];
        typeL.textColor = HEX(@"ffffff", 1.0);
        typeL.font = FONT(13);
        typeL.textAlignment = NSTextAlignmentCenter;
        typeL.layer.cornerRadius = 2;
        typeL.clipsToBounds = YES;
        typeL.tag = 100+i;
        
        UILabel *desL = [UILabel new];
        [_huodongV1 addSubview:desL];
        [desL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(typeL.mas_right).offset = 8;
            make.top.offset = 24*i;
            make.height.offset = 16;
            make.right.offset = -70;
        }];
        desL.font = FONT(12);
        desL.textColor = HEX(@"666666", 1.0);
        desL.tag = 300+i;
    }
    //添加更多活动按钮
    _huodongCountBtn = [YFTypeBtn new];
    _huodongCountBtn.btnType = RightImage;
    [_huodongV1 addSubview:_huodongCountBtn];
    [_huodongCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.top.offset = 0;
        make.height.offset = 16;
        make.width.offset = 65;
    }];
    [_huodongCountBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%d个活动      ", nil),@"4"]
                      forState:0];
    [_huodongCountBtn setTitleColor:HEX(@"999999", 1.0) forState:0];
    _huodongCountBtn.titleLabel.font = FONT(12);
    _huodongCountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_huodongCountBtn setImage:IMAGE(@"btn_arrow_down_small") forState:(UIControlStateNormal)];
    [_huodongCountBtn setImage:IMAGE(@"btn_arrow_top_small") forState:(UIControlStateSelected)];
    _huodongCountBtn.hidden = YES;
    _huodongV1.clipsToBounds = YES;
    
    //添加活动样式2
    _huodongV2 = [JHShopHuodongView new];
    [self.contentView addSubview:_huodongV2];
    [_huodongV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_shopTitleL.mas_left);
        make.right.offset = 0;
        make.bottom.offset = -16;
        make.height.offset  = 0;
        make.top.equalTo(_line.mas_bottom).offset = 10;
    }];
    [_huodongV2.arrowBtn addTarget:self action:@selector(clickHuodongV2Btn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDataModel:(JHWaimaiHomeShopModel *)dataModel{
    _dataModel = dataModel;
    //设置图标
    NSString *shopImgStr = dataModel.logo;
    [_shopIV sd_setImageWithURL:[NSURL URLWithString:shopImgStr] placeholderImage:nil options:(SDWebImageScaleDownLargeImages)];
    _is_newImgv.image = IMAGE(@"");
    if (dataModel.is_new.integerValue == 1) {
        //新店
        _is_newImgv.image = IMAGE(@"label_new");
    }
    //
    _shopTitleL.text = dataModel.title;
    //
    NSString *tips_label = dataModel.tips_label;
    if (tips_label.length) {
        _tipL.text = tips_label;
        CGFloat width_str = getSize(_tipL.text, 18, 13).width;
        [_tipL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 18;
            make.width.offset = width_str;
            
        }];
        [_starV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shopTitleL.mas_bottom).offset = 38;
        }];
        
    }else{
        _tipL.text = @"";
        [_tipL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
        }];
        [_starV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shopTitleL.mas_bottom).offset = 10;
        }];
    }
    //
    _starL.text = [NSString stringWithFormat:@"%.1f",[_dataModel.avg_score floatValue]];
    //
    _yueShouL.text = [NSString stringWithFormat:NSLocalizedString(@"月售%l@", nil),dataModel.orders];
    //设置配送方式边线样式,颜色
    NSDictionary *peiType = dataModel.peiType;
    NSString *pei_str = peiType[@"label"];
    NSString *pei_color = peiType[@"color"];
    NSString *pei_line_color = peiType[@"line_color"];
    
    _songTypeL.text = pei_str;
    _songTypeL.textColor = HEX(pei_color, 1.0);
    _songTypeL.bounds = FRAME(0, 0, 48, 18);
    [_songTypeL roundedCorners:(UIRectCorner)UIRectCornerTopLeft|UIRectCornerBottomRight
                  cornerRadius:4
                        colcor:HEX(pei_line_color, 1.0)];
    //起配送
    if (dataModel.is_reduce_pei.integerValue == 1) {
        //有配送费减免活动
        _orignalPeiL.hidden = NO;
        _qi_pei_songL.text = [NSString stringWithFormat:NSLocalizedString(@"起送¥%g  配送¥%g起", nil),dataModel.min_amount.doubleValue,dataModel.reduceEd_freight.doubleValue];
        _orignalPeiL.text = [NSString stringWithFormat:@"%@%g",NSLocalizedString(@"¥", nil),dataModel.freight.doubleValue];
        
    }else{
        //无配送费减免活动
        if (dataModel.freight.doubleValue > 0.0) {
            _qi_pei_songL.text = [NSString stringWithFormat:NSLocalizedString(@"起送¥%g  配送¥%g", nil),dataModel.min_amount.doubleValue,dataModel.freight.doubleValue];
        }else{
            _qi_pei_songL.text = [NSString stringWithFormat:NSLocalizedString(@"起送¥%g  免配送费", nil),dataModel.min_amount.doubleValue];
        }_orignalPeiL.hidden = YES;
        
    }
    //送达时间和距离
    _time_distanceL.text = [NSString stringWithFormat:NSLocalizedString(@"%@分钟 | %@", nil),dataModel.pei_time,dataModel.juli_label];
    [_time_distanceL setColor:HEX(@"e6e6e6", 1.0) string:[NSString stringWithFormat:@"|"]];
    //修改标签
    for (int i = 0; i<2; i++) {
        UILabel *biaoqianL = [_biaoQianV viewWithTag:100 + i];
        if (i >= dataModel.default_titleArr.count) {
            biaoqianL.hidden = YES;
        }else{
            biaoqianL.hidden = NO;
            biaoqianL.text = dataModel.default_titleArr[i];
        }
    }
    NSString *is_ziti = dataModel.is_ziti;
    UILabel *_zitiL = [_biaoQianV viewWithTag:101];
    _zitiL.hidden = (is_ziti.integerValue != 1);
    
    //活动---样式1
    if ([JHUserModel.shareJHUserModel.shopHuodongType isEqualToString:@"1"]) {
        _biaoQianV.hidden = NO;
        _huodongV1.hidden = NO;
        _huodongV2.hidden = YES;
        [_huodongV2 mas_remakeConstraints:^(MASConstraintMaker *make) {}];
        //
        //活动
        NSArray *huodongArr = dataModel.huodong;
        //重设活动view,判断是否展示更多活动
        NSUInteger show_line = dataModel.showMoreHuodong ? huodongArr.count : MIN(huodongArr.count, 3);
        [_huodongV1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_shopTitleL.mas_left);
            make.right.offset = -12;
            make.bottom.offset = 0;
            make.top.equalTo(self->_biaoQianV.mas_bottom).offset = 12;
            make.height.offset = 24*show_line;
        }];
        NSUInteger huodongCout = huodongArr.count;
        for(int i=0;i<huodongCout;i++){
            NSDictionary *huodongDic = huodongArr[i];
            //
            UILabel *typeL = [_huodongV1 viewWithTag:100+i];
            typeL.text = huodongDic[@"word"];
            typeL.backgroundColor = HEX(huodongDic[@"color"], 1.0);
            //
            UILabel *desL = [_huodongV1 viewWithTag:300+i];
            desL.text = huodongDic[@"title"];
        }
        //设置是否为选中
        _huodongCountBtn.hidden = (huodongCout < 4);
        _huodongCountBtn.selected = dataModel.showMoreHuodong;
        [_huodongCountBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%d个活动      ", nil),huodongCout] forState:0];
    }else{
        //样式二
        _biaoQianV.hidden = YES;
        _huodongV1.hidden = YES;
        _huodongV2.hidden = NO;
        [_huodongV1 mas_remakeConstraints:^(MASConstraintMaker *make) {}];
        //
        [_huodongV2 updateWithTitle:_dataModel.huodongTitleArr showMore:dataModel.showMoreHuodong];
        //
        _huodongV2.arrowBtn.selected = dataModel.showMoreHuodong;
        //
        CGFloat huodong_height = dataModel.showMoreHuodong ? _huodongV2.totalHeight : 18;
        [_huodongV2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_shopTitleL.mas_left);
            make.right.offset = 0;
            make.bottom.offset = -16;
            make.top.equalTo(_line.mas_bottom).offset = 10;
            make.height.offset  = huodong_height;
        }];
    }
    //是否是打烊状态
    _restL.hidden = dataModel.yyst.integerValue == 1;
    //获取选择的商品总量
    [[WMShopDBModel shareWMShopDBModel] getShopChoosedCountFromDB:dataModel.shop_id block:^(int count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (count > 0) {
                _productsNumL.text = @(count).description;
                _productsNumL.hidden = NO;
            }else{
                _productsNumL.hidden = YES;
            }
        });
    }];
}
- (void)clickHuodongV2Btn:(UIButton *)sender{
    sender.selected = !sender.selected;
    UITableView *table = (UITableView *)self.superview;
    NSIndexPath *indexPath = [table indexPathForCell:self];
    _dataModel.showMoreHuodong = sender.selected;
#warning 此处需要先隐藏掉多于的活动标签,没有找到需要预先的原因
    if (_dataModel.showMoreHuodong == NO) {
        [_huodongV2 hiddenBtns];
    }
    [table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
@end
