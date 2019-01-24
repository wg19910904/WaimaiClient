//
//  FilterCollectionCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "FilterCollectionCell.h"

@interface FilterCollectionCell ()
@property(nonatomic,weak)UIButton *titleBtn;
@end

@implementation FilterCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{

    UIButton *titleBtn = [UIButton new];
    [self.contentView addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.centerY.offset=0;
        make.right.offset=0;
        make.height.offset=40;
    }];
    [titleBtn setTitleColor:THEME_COLOR_Alpha(1.0) forState:UIControlStateSelected];
    [titleBtn setTitleColor:HEX(@"4a4c4d", 1.0) forState:UIControlStateNormal];
    [titleBtn setBackgroundColor:HEX(@"f8f8f8", 1.0) forState:UIControlStateNormal];
    [titleBtn setBackgroundColor:HEX(@"e8f6e8", 1.0) forState:UIControlStateSelected];
    titleBtn.titleLabel.font = FONT(14);
    self.titleBtn = titleBtn;
    titleBtn.userInteractionEnabled = NO;
}

-(void)reloadCellWithTitle:(NSString *)titleStr{
    [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.titleBtn.selected = selected;
}

@end
