//
//  FilterCell.m
//  Lunch
//
//  Created by ios_yangfei on 17/3/21.
//  Copyright © 2017年 jianghu. All rights reserved.
//

#import "FilterCell.h"

@interface FilterCell ()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIImageView *selectedImgView;
@end

@implementation FilterCell

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
        make.height.offset=20;
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"4a4c4d", 1.0);
    self.titleLab = titleLab;
    
    UIImageView *selectedImgView = [UIImageView new];
    [self.contentView addSubview:selectedImgView];
    [selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-15;
        make.centerY.offset=0;
        make.width.offset=12;
        make.height.offset=8;
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
        self.selectedImgView.image = IMAGE(@"icon_selected");
        
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
