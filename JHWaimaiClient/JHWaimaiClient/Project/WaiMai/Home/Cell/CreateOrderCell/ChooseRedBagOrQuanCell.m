//
//  ChooseRedBagOrQuanCell.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/11/20.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "ChooseRedBagOrQuanCell.h"
#import "NSString+Tool.h"
#import "YFTypeBtn.h"

@interface ChooseRedBagOrQuanCell ()
@property(nonatomic,weak)UILabel *moneyLab;
@property(nonatomic,weak)UILabel *desLab;           // 满减条件
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *conditionLab;     // 使用条件
@property(nonatomic,weak)YFTypeBtn *cantUseBtn;       // 不可用
@property(nonatomic,weak)UILabel *reasonLab;        // 不可用原因描述
@property(nonatomic,weak)UIView *coverView;         // 蒙层
@property(nonatomic,weak)UIButton *chooseBtn;       // 选中按钮
@property(nonatomic,weak)UILabel *timeLab;
@end

@implementation ChooseRedBagOrQuanCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
        self.contentView.layer.borderColor=HEX(@"999999", 0.5).CGColor;
        self.contentView.layer.borderWidth=0.5;
    }
    return self;
}

-(void)configUI{
    
    UILabel *moneyLab = [UILabel new];
    [self.contentView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(18);
        make.width.offset(108);
        make.height.offset(50);
    }];
    moneyLab.textColor = HEX(@"FF725C", 1.0);
    moneyLab.font = FONT(30);
    moneyLab.textAlignment = NSTextAlignmentCenter;
    self.moneyLab = moneyLab;
    
    UILabel *desLab = [UILabel new];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(moneyLab.mas_bottom);
        make.centerX.equalTo(moneyLab.mas_centerX);
        make.height.offset(20);
    }];
    desLab.textColor = HEX(@"666666", 1.0);
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.font = FONT(12);
    self.desLab = desLab;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(108);
        make.top.offset(22);
        make.right.offset(-60);
    }];
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.font = FONT(16);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.numberOfLines = 2;
    self.titleLab = titleLab;
    
    UILabel *timeLab = [UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(108);
        make.top.equalTo(titleLab.mas_bottom).offset(8);
        make.right.offset(-60);
    }];
    timeLab.textColor = HEX(@"666666", 1.0);
    timeLab.font = FONT(12);
    self.timeLab = timeLab;
    
    UILabel *conditionLab = [UILabel new];
    [self.contentView addSubview:conditionLab];
    [conditionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(108);
        make.top.equalTo(timeLab.mas_bottom).offset(8);
        make.right.offset(-60);
    }];
    conditionLab.textColor = HEX(@"666666", 1.0);
    conditionLab.font = FONT(12);
    conditionLab.lineBreakMode = NSLineBreakByTruncatingTail;
    conditionLab.numberOfLines = 2;
    self.conditionLab = conditionLab;
    
    YFTypeBtn *cantUseBtn = [YFTypeBtn new];
    [self.contentView addSubview:cantUseBtn];
    [cantUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(conditionLab.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    cantUseBtn.btnType = LeftImage;
    cantUseBtn.titleMargin = 5;
    cantUseBtn.titleLabel.font = FONT(12);
    cantUseBtn.userInteractionEnabled = NO;
    [cantUseBtn setTitle: NSLocalizedString(@"不可用原因", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [cantUseBtn setTitleColor:HEX(@"FF725C", 1.0) forState:UIControlStateNormal];
    [cantUseBtn setImage:IMAGE(@"icon_notice") forState:UIControlStateNormal];
    self.cantUseBtn = cantUseBtn;
    
    UILabel *reasonLab = [UILabel new];
    [self.contentView addSubview:reasonLab];
    [reasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(cantUseBtn.mas_bottom).offset(8);
        make.bottom.offset(-8);
    }];
    reasonLab.textColor = HEX(@"666666", 1.0);
    reasonLab.font = FONT(12);
    reasonLab.lineBreakMode = NSLineBreakByTruncatingTail;
    reasonLab.numberOfLines = 0;
    self.reasonLab = reasonLab;
    
    UIButton *chooseBtn = [UIButton new];
    [self.contentView addSubview:chooseBtn];
    [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.offset(0);
        make.width.offset(40);
        make.height.offset(40);
    }];
    chooseBtn.userInteractionEnabled = NO;
    [chooseBtn setImage:IMAGE(@"index_selector_disable") forState:UIControlStateNormal];
    [chooseBtn setImage:IMAGE(@"index_selector_enable") forState:UIControlStateSelected];
    self.chooseBtn = chooseBtn;
    
    UIView *coverView = [UIView new];
    [self.contentView addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    coverView.backgroundColor = HEX(@"ffffff", 0.3);
    coverView.hidden = YES;
    self.coverView = coverView;
    
}

-(void)reloadCellWithModel:(NSDictionary *)dic is_redbag:(BOOL)is_redbag{
    
    NSString *amount = is_redbag ? dic[@"amount"] : dic[@"coupon_amount"];//
    self.moneyLab.attributedText = [NSString getAttributeString:[NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),amount] dealStr: NSLocalizedString(@"¥", NSStringFromClass([self class])) strAttributeDic:@{NSFontAttributeName : FONT(20)}];
    NSString *money = is_redbag ? dic[@"min_amount"] : dic[@"order_amount"];
    self.desLab.text = [NSString stringWithFormat: NSLocalizedString(@"满%@元可用", NSStringFromClass([self class])),money];
    self.titleLab.text = dic[@"title"];
    self.conditionLab.text = dic[@"limit_time_label"];
    self.timeLab.text = [NSString stringWithFormat: NSLocalizedString(@"有效期至: %@", NSStringFromClass([self class])),dic[@"ltime"]];
    BOOL can_use = [dic[@"is_canuse"] boolValue];
    if (can_use) {
        [self.conditionLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-8);
        }];
    }else{
        [self.conditionLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(108);
            make.top.equalTo(self.timeLab.mas_bottom).offset(8);
            make.right.offset(-60);
        }];
    }
    self.cantUseBtn.hidden = can_use;
    self.reasonLab.text = dic[@"reason"];
    self.chooseBtn.hidden = !can_use;
    self.coverView.hidden = can_use;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.chooseBtn.selected = selected;
    
}

@end
