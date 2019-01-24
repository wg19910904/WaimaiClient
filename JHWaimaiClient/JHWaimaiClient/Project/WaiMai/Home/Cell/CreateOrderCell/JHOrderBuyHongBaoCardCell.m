//
//  JHOrderBuyHongBaoCardCell.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHOrderBuyHongBaoCardCell.h"
#import "YFTypeBtn.h"

@interface JHOrderBuyHongBaoCardCell()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)UILabel *moneyLab;
@property(nonatomic,weak)YFTypeBtn *chooseBtn;
@end

@implementation JHOrderBuyHongBaoCardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *backView = [UIView new];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(5);
        make.right.offset(-10);
        make.height.offset(80);
        make.bottom.offset(-5);
    }];
    backView.backgroundColor = HEX(@"f5f5f5", 1.0);
    backView.layer.cornerRadius=4;
    backView.clipsToBounds=YES;
    
    UILabel *titleLab = [UILabel new];
    [backView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(5);
        make.height.offset(40);
    }];
    titleLab.font = FONT(16);
    titleLab.textColor = HEX(@"333333", 1.0);
    self.titleLab = titleLab;
    
    UILabel *desLab = [UILabel new];
    [backView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(-10);
        make.height.offset(20);
    }];
    desLab.font = FONT(12);
    desLab.textColor = HEX(@"999999", 1.0);
    self.desLab = desLab;
    
    YFTypeBtn *chooseBtn = [YFTypeBtn new];
    [backView addSubview:chooseBtn];
    [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.offset(2);
        make.height.offset(40);
    }];
    chooseBtn.btnType = RightImage;
    chooseBtn.titleMargin = -10;
    chooseBtn.imageMargin = 10;
    chooseBtn.titleLabel.font = FONT(16);
    [chooseBtn setImage:IMAGE(@"icon_radio") forState:UIControlStateNormal];
    [chooseBtn setImage:IMAGE(@"icon_radio_selected_new") forState:UIControlStateSelected];
    [chooseBtn setTitleColor:HEX(@"FA4C34", 1.0) forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(clickChooesed:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseBtn = chooseBtn;
    
    
}

-(void)reloadCellWithInfo:(NSDictionary *)redPackageInfo selected:(BOOL)is_select{
    
    self.titleLab.text = [NSString stringWithFormat: NSLocalizedString(@"购红包套餐，每单立减¥%@", NSStringFromClass([self class])),redPackageInfo[@"hongbao"][@"amount"]];
    self.desLab.text = [NSString stringWithFormat: NSLocalizedString(@"立得%@张¥%@大红包", NSStringFromClass([self class])),redPackageInfo[@"limit"],redPackageInfo[@"hongbao"][@"amount"]];
    NSString *str = [NSString stringWithFormat: NSLocalizedString(@"¥ %@", NSStringFromClass([self class])),redPackageInfo[@"amount"]];
    [self.chooseBtn setTitle:str forState:UIControlStateNormal];
    self.chooseBtn.selected = is_select;
}

-(void)clickChooesed:(UIButton *)btn{
    YF_SAFE_BLOCK(self.chooesedBlock,!btn.selected,@"");
}

@end
