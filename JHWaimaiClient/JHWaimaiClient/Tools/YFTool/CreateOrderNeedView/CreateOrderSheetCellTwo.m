//
//  CreateOrderSheetCellTwo.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "CreateOrderSheetCellTwo.h"

@interface CreateOrderSheetCellTwo()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIButton *selectedBtn;
@property(nonatomic,weak)UIImageView *iconImgView;
@end

@implementation CreateOrderSheetCellTwo

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{

    UIButton *selectedBtn = [UIButton new];
    [self.contentView addSubview:selectedBtn];
    [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset= 10;
        make.centerY.offset=0;
        make.width.offset=20;
        make.height.offset=20;
    }];
    selectedBtn.userInteractionEnabled = NO;
    [selectedBtn setImage:IMAGE(@"index_selector_disable") forState:UIControlStateNormal];
    [selectedBtn setImage:IMAGE(@"index_selector_enable") forState:UIControlStateSelected];
    self.selectedBtn = selectedBtn;
    
    UIImageView *iconImgView = [UIImageView new];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=40;
        make.centerY.offset=0;
        make.width.offset=30;
        make.height.offset=30;
    }];
    self.iconImgView = iconImgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=80;
        make.centerY.offset=0;
        make.right.offset = -40;
        make.height.offset=20;
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = TEXT_COLOR;
    self.titleLab = titleLab;

}

-(void)reloadCellWith:(NSDictionary *)dic{
    
    self.titleLab.text = dic[@"title"];
    self.iconImgView.image = IMAGE(dic[@"icon"]);
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    self.selectedBtn.selected = selected;
}

@end
