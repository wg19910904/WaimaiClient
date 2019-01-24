//
//  LeftAndRightLabCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "LeftAndRightLabCell.h"

@interface LeftAndRightLabCell()
@property(nonatomic,weak)UILabel *leftLab;
@property(nonatomic,weak)UILabel *rightLab;
@property(nonatomic,weak)UIImageView *arrowImgView;
@property(nonatomic,weak)UILabel *typeLab;
@property(nonatomic,weak)UIView *lineView;
@property(nonatomic,weak)UIButton *question_btn;
@end

@implementation LeftAndRightLabCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    self.lineView = lineView;
    
    UILabel *typeLab = [UILabel new];
    [self.contentView addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=14;
        make.width.offset = 14;
    }];
    typeLab.font = FONT(10);
    typeLab.textColor = [UIColor whiteColor];
    typeLab.backgroundColor = HEX(@"ff4d5b", 1.0);
    typeLab.layer.cornerRadius=4;
    typeLab.clipsToBounds=YES;
    typeLab.textAlignment = NSTextAlignmentCenter;
    self.typeLab = typeLab;
    
    UILabel *leftLab = [UILabel new];
    [self.contentView addSubview:leftLab];
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLab.mas_right).offset=5;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    leftLab.font = FONT(14);
    leftLab.textColor = TEXT_COLOR;
    self.leftLab = leftLab;
    
    UIButton *btn = [UIButton new];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLab.mas_right).offset(10);
        make.centerY.equalTo(leftLab.mas_centerY).offset(0);
        make.width.offset(40);
        make.height.offset(40);
    }];
    [btn setImage:IMAGE(@"icon_ques") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickShowReason) forControlEvents:UIControlEventTouchUpInside];
    self.question_btn = btn;
    
    UILabel *rightLab = [UILabel new];
    [self.contentView addSubview:rightLab];
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.height.offset=20;
        make.top.offset=10;
        make.bottom.offset=-10;
    }];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.font = FONT(14);
    rightLab.textColor = TEXT_COLOR;
    self.rightLab = rightLab;
    
}

-(void)setTextColor:(UIColor *)textColor{
   
    self.lineView.hidden = textColor == [UIColor whiteColor];
    
    self.leftLab.textColor = textColor;
    self.typeLab.textColor = textColor;
    self.rightLab.textColor = textColor;
}

-(void)reloadCell:(NSString *)leftStr rightStr:(NSString *)rightStr{
    self.question_btn.hidden = YES;
    self.leftLab.text = leftStr;
    if ([rightStr floatValue] == 0) {
        
        self.rightLab.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"免", @"LeftAndRightLabCell"),leftStr];
    }else{
        self.rightLab.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"¥",nil),rightStr];
    }
    
    [self.typeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset= 5;
        make.width.offset=0;
    }];

}

-(void)reloadCellWithYouHuiDic:(NSDictionary *)dic{
    
    self.question_btn.hidden = YES;
    if ([dic[@"type"] isEqualToString:@"reduceFreight"] && [dic[@"amount"] floatValue] == 0) {
        self.question_btn.hidden = NO;
    }
    
    self.leftLab.text = dic[@"title"];
    self.rightLab.text = [NSString stringWithFormat:@"-%@ %@",NSLocalizedString(@"¥", nil),dic[@"amount"]];
    self.typeLab.text = dic[@"word"];
    self.typeLab.backgroundColor = HEX(dic[@"color"], 1.0);
    [self.typeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.width.offset=14;
    }];
    self.rightLab.textColor = HEX(@"ff6600", 1.0);
}

-(void)clickShowReason{
    YF_SAFE_BLOCK(self.clickQuestionBlock,NO,@"");
}

@end
