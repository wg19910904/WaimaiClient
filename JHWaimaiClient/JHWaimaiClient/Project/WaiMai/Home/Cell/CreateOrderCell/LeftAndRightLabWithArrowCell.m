//
//  LeftAndRightLabWithArrowCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "LeftAndRightLabWithArrowCell.h"

@interface LeftAndRightLabWithArrowCell()
@property(nonatomic,weak)UILabel *leftLab;
@property(nonatomic,weak)UILabel *rightLab;

@end

@implementation LeftAndRightLabWithArrowCell

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
    
    UILabel *leftLab = [UILabel new];
    [self.contentView addSubview:leftLab];
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    leftLab.font = FONT(14);
    leftLab.textColor = TEXT_COLOR;
    self.leftLab = leftLab;
    
    UIImageView *arrowImgView = [UIImageView new];
    [self.contentView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.width.offset=7;
        make.height.offset=12;
    }];
    arrowImgView.image = IMAGE(@"btn_arrowr_gray");
    self.arrowImgView = arrowImgView;
    
    UILabel *rightLab = [UILabel new];
    [self.contentView addSubview:rightLab];
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImgView.mas_left).offset= -5;
        make.top.offset=10;
        make.width.lessThanOrEqualTo(@170);
        make.height.offset=20;
        make.bottom.offset=-10;
    }];
    rightLab.lineBreakMode = NSLineBreakByTruncatingTail;
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.font = FONT(14);
    rightLab.textColor = TEXT_COLOR;
    self.rightLab = rightLab;
    
}

-(void)reloadCell:(NSString *)leftStr rightStr:(NSString *)rightStr rightColor:(UIColor *)color is_money:(BOOL)is_money{
    
    self.leftLab.text = leftStr;
    if ([rightStr floatValue] == 0) {
         self.rightLab.text = rightStr;
    }else{
         self.rightLab.text = is_money ? [NSString stringWithFormat:@"- %@%@",NSLocalizedString(@"¥", nil),rightStr]: rightStr;
    }
    self.rightLab.textColor = color;
}

@end
