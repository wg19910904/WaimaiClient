//
//  XHGaodePlacePickerCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2018/8/14.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "XHGaodePlacePickerCell.h"

@interface XHGaodePlacePickerCell(){
    UIImageView *leftImgV;
    UILabel *titleL;
    UILabel *desL;
    UIView *line;
}
@end

@implementation XHGaodePlacePickerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
         self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)creatUI{
    
    leftImgV = [[UIImageView alloc]init];
    [self addSubview:leftImgV];
    [leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 20;
        make.height.offset = 20;
        make.bottom.offset = -20;
        make.left.offset = 15;
        make.width.offset = 15;
    }];
    leftImgV.image = IMAGE(@"XHAddress");
    
    titleL = [[UILabel alloc]init];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 10;
        make.height.offset = 22;
        make.left.equalTo(leftImgV.mas_right).offset = 10;
        make.width.offset = WIDTH- 55;
    }];
    titleL.font = FONT(16);
    
    desL = [[UILabel alloc]init];
    [self addSubview:desL];
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset = 0;
        make.height.offset = 17;
        make.left.equalTo(leftImgV.mas_right).offset = 10;
        make.width.offset = WIDTH- 55;
    }];
    desL.font = FONT(12);
    desL.textColor = HEX(@"999999", 1);
    
    
    line = [[UIView alloc]init];
    line.backgroundColor = LINE_COLOR;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = 0;
        make.left.offset = 40;
        make.right.offset = 0;
        make.height.offset = 0.5;
    }];
}
-(void)reloadModel:(XHLocationInfo *)model showImg:(BOOL)is_show searchWord:(NSString *)str isSearch:(BOOL)is_search
{
    if (!is_search) {
        if (is_show) {
            leftImgV.hidden = NO;
            titleL.textColor = HEX(@"298FFF", 1);
        }else{
            leftImgV.hidden = YES;
            titleL.textColor = HEX(@"333333", 1);
        }
        titleL.text = model.name;
        desL.text = model.street;
    }else{
        leftImgV.hidden = YES;
        [titleL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 10;
            make.height.offset = 22;
            make.left.offset = 12;
            make.width.offset = WIDTH- 24;
        }];
        [desL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleL.mas_bottom).offset = 0;
            make.height.offset = 17;
            make.left.offset = 12;
            make.width.offset = WIDTH- 24;
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = 0;
            make.left.offset = 12;
            make.right.offset = -12;
            make.height.offset = 0.5;
        }];
      
        NSMutableAttributedString * attr =[[NSMutableAttributedString alloc]initWithString:model.name];
        NSRange range = [model.name rangeOfString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:HEX(@"298FFF", 1) range:range];
        titleL.attributedText = attr;
        desL.text = model.street;
    }
  
}
@end
