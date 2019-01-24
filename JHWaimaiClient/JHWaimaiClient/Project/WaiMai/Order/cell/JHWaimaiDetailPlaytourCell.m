//
//  JHWaimaiDetailPlaytourCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2018/1/3.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHWaimaiDetailPlaytourCell.h"
#import "YFTypeBtn.h"
#import <UIImageView+WebCache.h>
@interface JHWaimaiDetailPlaytourCell()
@property(nonatomic,strong)UIImageView *imgV_header;
@property(nonatomic,strong)UILabel *nameL;
@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)YFTypeBtn *dashangBtn;
@property(nonatomic,strong)YFTypeBtn *connectBtn;
@end
@implementation JHWaimaiDetailPlaytourCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self imgV_header];
        [self nameL];
        [self imgV];
        [self connectBtn];
        [self dashangBtn];
        [self addLine];
    }
    return self;
}
-(UIImageView *)imgV_header{
    if (!_imgV_header) {
        _imgV_header = [[UIImageView alloc]init];
        _imgV_header.layer.cornerRadius = 25;
        _imgV_header.layer.masksToBounds = YES;
        [self addSubview:_imgV_header];
        [_imgV_header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.offset = 15;
            make.width.height.offset = 50;
            make.bottom.offset = -10;
        }];
    }
    return _imgV_header;
}
-(UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = HEX(@"333333", 1);
        _nameL.font = FONT(15);
        [self addSubview:_nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgV_header.mas_right).offset = 15;
            make.height.offset = 20;
            make.top.mas_equalTo(_imgV_header.mas_top);
        }];
    }
    return _nameL;
}
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [UIImageView new];
        _imgV.image = IMAGE(@"ds_pic1");
        [self addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameL.mas_bottom).offset = 7;
            make.height.offset = 18;
            make.width.offset = 55;
            make.left.mas_equalTo(_imgV_header.mas_right).offset = 15;
        }];
    }
    return _imgV;
}
-(YFTypeBtn *)connectBtn{
    if (!_connectBtn) {
        _connectBtn = [[YFTypeBtn alloc]init];
        _connectBtn.btnType = LeftImage;
        _connectBtn.titleMargin = 6;
        [_connectBtn setImage:IMAGE(@"ds_icon2") forState:UIControlStateNormal];
        [_connectBtn setTitle:NSLocalizedString(@"联系",nil) forState:UIControlStateNormal];
        [_connectBtn setTitleColor:HEX(@"555555", 1) forState:UIControlStateNormal];
        [_connectBtn addTarget:self action:@selector(clickPhone) forControlEvents:UIControlEventTouchUpInside];
        _connectBtn.titleLabel.font = FONT(14);
        [self addSubview:_connectBtn];
        [_connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.top.bottom.offset = 0;
            make.width.offset = 60;
        }];
    }
    return _connectBtn;
}
-(void)addLine{
    UIView *view = [UIView new];
    view.backgroundColor = LINE_COLOR;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset = 0.5;
        make.height.offset = 30;
        make.right.mas_equalTo(_connectBtn.mas_left).offset = -15;
    }];
}
-(YFTypeBtn *)dashangBtn{
    if (!_dashangBtn) {
        _dashangBtn = [[YFTypeBtn alloc]init];
        _dashangBtn.btnType = LeftImage;
        _dashangBtn.titleMargin = 6;
        _dashangBtn.titleLabel.font = FONT(14);
        [_dashangBtn setImage:IMAGE(@"ds_icon1") forState:UIControlStateNormal];
        [_dashangBtn setTitle:NSLocalizedString(@"打赏",nil) forState:UIControlStateNormal];
        [_dashangBtn setTitleColor:HEX(@"555555", 1) forState:UIControlStateNormal];
        [self addSubview:_dashangBtn];
        [_dashangBtn addTarget:self action:@selector(clickToLink) forControlEvents:UIControlEventTouchUpInside];
        [_dashangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_connectBtn.mas_left).offset = -30;
            make.top.bottom.offset = 0;
            make.width.offset = 60;
            
        }];
    }
    return _dashangBtn;
}
-(void)setModel:(JHWaimaiOrderDetailModel *)model{
    _model = model;
    [_imgV_header sd_setImageWithURL:[NSURL URLWithString:model.staff[@"face"]] placeholderImage:IMAGE(@"ds_icon8")];
     _nameL.text = model.staff[@"name"];
}
-(void)clickToLink{
    Class class = NSClassFromString(@"JHADWebVC");
    UIViewController *vc = [[class alloc] init];
    [vc setValue:NSLocalizedString(@"打赏",nil) forKey:@"titleStr"];
    [vc setValue:_model.staff[@"link"] forKey:@"url"];
    UIWebView *web = [vc valueForKey:@"web"];
    web.scrollView.scrollEnabled = NO;
    [self.superVC.navigationController pushViewController:vc animated:YES];
}
-(void)clickPhone{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.staff[@"mobile"]]]];
}
@end
