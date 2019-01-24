//
//  WMGoodDetailCellTwo.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/23.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMGoodDetailCellTwo.h"
#import "YFTypeBtn.h"
#import "NSString+Tool.h"

@interface WMGoodDetailCellTwo()
@property(nonatomic,weak)YFTypeBtn *supportBtn;
@property(nonatomic,weak)YFTypeBtn *babBtn;
@property(nonatomic,weak)UILabel *supportLab;
@property(nonatomic,weak)UILabel *evaluateLab;
@end

@implementation WMGoodDetailCellTwo

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *lab = [UILabel new];
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=10;
        make.height.offset=20;
    }];
    lab.font = FONT(14);
    lab.textColor = HEX(@"666666", 1.0);
    lab.text = NSLocalizedString(@"商品评价", @"WMGoodDetailCellTwo");

    
    UILabel *backLab = [UILabel new];
    [self.contentView addSubview:backLab];
    [backLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(lab.mas_bottom).offset= 30;
        make.right.offset=-10;
        make.height.offset=5;
    }];
    backLab.backgroundColor = LINE_COLOR;
    backLab.layer.cornerRadius=2.5;
    backLab.clipsToBounds=YES;
    
    UILabel *supportLab = [UILabel new];
    [self.contentView addSubview:supportLab];
    [supportLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(lab.mas_bottom).offset= 30;
        make.width.lessThanOrEqualTo(@(WIDTH -20));
        make.height.offset=5;
    }];
    supportLab.backgroundColor = HEX(@"ff9900", 1.0);
    supportLab.layer.cornerRadius=2.5;
    supportLab.clipsToBounds=YES;
    self.supportLab = supportLab;
    
    NSArray *arr = @[NSLocalizedString(@"非常差", NSStringFromClass([self class])),NSLocalizedString(@"差", NSStringFromClass([self class])),NSLocalizedString(@"一般", NSStringFromClass([self class])),NSLocalizedString(@"好", NSStringFromClass([self class])),NSLocalizedString(@"非常好", NSStringFromClass([self class]))];
    for (NSInteger i=0; i<arr.count; i++) {
        
        UILabel *lab = [UILabel new];
        [self.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = WIDTH/5 * i;
            make.top.equalTo(supportLab.mas_bottom).offset(5);
            make.width.offset(WIDTH/5);
            make.height.offset(20);
            make.bottom.offset=-5;
        }];
        lab.font = FONT(12);
        lab.text = arr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = HEX(@"999999", 1.0);
    }

    UILabel *evaluateLab = [UILabel new];
    [self.contentView addSubview:evaluateLab];
    [evaluateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backLab.mas_top).offset= -5;
        make.height.offset=20;
    }];
    evaluateLab.textAlignment = NSTextAlignmentCenter;
    evaluateLab.font = FONT(12);
    evaluateLab.textColor = HEX(@"FA4C34", 1.0);
    self.evaluateLab = evaluateLab;
}

-(void)reloadCellWithModel:(WMShopGoodModel *)model{
    
    NSMutableAttributedString *attStr =[[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"好评率", @"WMGoodDetailCellTwo")];
    
    [attStr appendAttributedString:[NSString getAttributeString:model.goodPercent strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff9900", 1.0)}]];
    self.evaluateLab.attributedText = attStr;
    
    [self.supportBtn setTitle:model.good forState:UIControlStateNormal];
    [self.babBtn setTitle:model.bad forState:UIControlStateNormal];
    float count = [model.good floatValue] + [model.bad floatValue];
    float percent = count == 0 ? 0 : [model.good floatValue]/count;
    [self.supportLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset = percent * (WIDTH -20);
    }];
    
    CGFloat left = percent * (WIDTH -20) - 50;
    left = left < 0 ? 10 : percent * (WIDTH -20) - 50;
    [self.evaluateLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset = left;
    }];
}
@end
