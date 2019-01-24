//
//  CreateOrderChooseTimeCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "CreateOrderChooseTimeCell.h"

@interface CreateOrderChooseTimeCell()

@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIImageView *selectedImgView;

@end

@implementation CreateOrderChooseTimeCell

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
        make.centerX.offset=0;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    titleLab.font = FONT(12);
    titleLab.textColor = TEXT_COLOR;
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab = titleLab;
    
    UIImageView *selectedImgView = [UIImageView new];
    [self.contentView addSubview:selectedImgView];
    [selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.width.offset=20;
        make.height.offset=20;
    }];
    selectedImgView.hidden = YES;
    self.selectedImgView = selectedImgView;
    
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLab.textColor = THEME_COLOR_Alpha(1.0);
        self.selectedImgView.image = IMAGE(@"index_selector_enable");
        
        if (self.type == 1) {
            self.backgroundColor = [UIColor whiteColor];
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
        
    }else{
        self.titleLab.textColor = HEX(@"4a4c4d", 1.0);
        self.selectedImgView.image = nil;
        
        if (self.type == 1) {
            self.backgroundColor = HEX(@"f4f4f4", 1.0);
            self.contentView.backgroundColor = HEX(@"f4f4f4", 1.0);
        }
    }
}

-(void)setType:(int)type{
    _type = type;
    if (type == 1) {
        self.selectedImgView.hidden = YES;
    }else{
        self.selectedImgView.hidden = NO;
    }
}

@end

