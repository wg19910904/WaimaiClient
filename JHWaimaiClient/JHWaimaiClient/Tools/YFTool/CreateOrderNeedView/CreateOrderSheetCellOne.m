//
//  CretateOrderSheetCellOne.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "CreateOrderSheetCellOne.h"
#import "NSString+Tool.h"

@interface CreateOrderSheetCellOne()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIButton *selectedBtn;
@end

@implementation CreateOrderSheetCellOne

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.right.offset = -40;
        make.height.offset=20;
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = TEXT_COLOR;
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLab = titleLab;
    
    UIButton *selectedBtn = [UIButton new];
    [self.contentView addSubview:selectedBtn];
    [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.width.offset=20;
        make.height.offset=20;
    }];
    selectedBtn.userInteractionEnabled = NO;
    [selectedBtn setImage:IMAGE(@"index_selector_disable") forState:UIControlStateNormal];
    [selectedBtn setImage:IMAGE(@"index_selector_enable") forState:UIControlStateSelected];
    self.selectedBtn = selectedBtn;
    
}

-(void)reloadCellWith:(NSString *)title hidden_btn:(BOOL)is_hidden{
    
    self.selectedBtn.hidden = is_hidden;
    self.userInteractionEnabled = !is_hidden;
    
    if (is_hidden) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attStr appendAttributedString:[NSString getAttributeString:[NSString stringWithFormat:@"(该商家不支持%@)",title] strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"999999", 1.0)}]];
        self.titleLab.attributedText = attStr;
    }else{
        self.titleLab.text = title;
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    self.selectedBtn.selected = selected;
}

@end
