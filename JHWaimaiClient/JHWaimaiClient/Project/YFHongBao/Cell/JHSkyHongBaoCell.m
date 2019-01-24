//
//  JHSkyHongBaoCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHSkyHongBaoCell.h"
#import "NSString+Tool.h"

@interface JHSkyHongBaoCell()
@property(nonatomic,weak)UILabel *moneyLab;
@property(nonatomic,weak)UILabel *min_moneyLab;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *titleLab;
@end

@implementation JHSkyHongBaoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self configUI];
    }
    return self;
}

-(void)configUI{
 
    UIImageView *imgView = [UIImageView new];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=0;
        make.right.offset=-10;
        make.bottom.offset=0;
    }];
    imgView.image = IMAGE(@"hongbaocell_bg");
    
    UILabel *moneyLab = [UILabel new];
    [self.contentView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.width.equalTo(imgView.mas_width).multipliedBy(0.27);
        make.height.offset=40;
    }];
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.font = FONT(14);
    moneyLab.textColor = HEX(@"e13337", 1.0);
    self.moneyLab = moneyLab;
    
    UILabel *lab = [UILabel new];
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLab.mas_right).offset=15;
        make.top.offset=10;
        make.right.offset = -10;
        make.height.offset=20;
    }];
    lab.textColor = HEX(@"e13337", 1.0);
    lab.font = FONT(14);
    self.titleLab = lab;
    
    UILabel *min_moneyLab = [UILabel new];
    [self.contentView addSubview:min_moneyLab];
    [min_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLab.mas_right).offset=15;
        make.top.equalTo(lab.mas_bottom).offset=0;
        make.right.offset = -10;
        make.height.offset=20;
    }];
    min_moneyLab.textColor = HEX(@"333333", 1.0);
    min_moneyLab.font = FONT(12);
    self.min_moneyLab = min_moneyLab;
    
    UILabel *timeLab = [UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLab.mas_right).offset=15;
        make.top.equalTo(min_moneyLab.mas_bottom).offset=0;
        make.right.offset = -10;
        make.height.offset=20;
    }];
    timeLab.textColor = HEX(@"666666", 1.0);
    timeLab.font = FONT(10);
    self.timeLab = timeLab;
}

-(void)reloadCellWithModel:(JHSkyHongBaoModel *)model{
    
    self.titleLab.text = model.title;
    self.timeLab.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"有限期至", @"JHSkyHongBaoCell"),[NSString formateDate:@"yyyy-MM-dd" dateline:model.dateline]];
    
    self.min_moneyLab.text = [NSString stringWithFormat:@"%@%@%@%@",NSLocalizedString(@"满",@"JHSkyHongBaoCell"),
                              model.min_amount,NSLocalizedString(@"元", nil),NSLocalizedString(@"可用", nil)];
    self.moneyLab.attributedText = [NSString priceLabText:model.amount attributeFont:28];
}

@end
