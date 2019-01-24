//
//  WMGoodSizeCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/23.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMGoodSizeCell.h"

@interface WMGoodSizeCell ()
@property(nonatomic,weak)UILabel *sizeLab;
@end

@implementation WMGoodSizeCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
  
    UILabel *sizeLab = [UILabel new];
    [self.contentView addSubview:sizeLab];
    [sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=5;
        make.top.offset=5;
        make.right.offset=-5;
        make.bottom.offset=-5;
    }];
    sizeLab.layer.cornerRadius=4;
    sizeLab.clipsToBounds=YES;
    sizeLab.layer.borderColor = LINE_COLOR.CGColor;
    sizeLab.layer.borderWidth=0.5;
    sizeLab.font = FONT(12);
    sizeLab.textColor = TEXT_COLOR;
    sizeLab.textAlignment = NSTextAlignmentCenter;
    sizeLab.backgroundColor = [UIColor whiteColor];
    self.sizeLab = sizeLab;
    
}

-(void)reloadCellWith:(NSString *)sizeStr is_selected:(BOOL)selected{
    self.sizeLab.text = sizeStr;
    if (self.is_property) {
        if (selected) {
            self.sizeLab.layer.borderColor = THEME_COLOR_Alpha(1.0).CGColor;
            self.sizeLab.textColor = THEME_COLOR_Alpha(1.0);
            self.sizeLab.backgroundColor = THEME_COLOR_Alpha(0.2);
        }else{
            self.sizeLab.layer.borderColor = LINE_COLOR.CGColor;
            self.sizeLab.textColor = TEXT_COLOR;
            self.sizeLab.backgroundColor = [UIColor whiteColor];
        }

    }
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (!self.is_property) {
        if (selected) {
            self.sizeLab.layer.borderColor = THEME_COLOR_Alpha(1.0).CGColor;
            self.sizeLab.textColor = THEME_COLOR_Alpha(1.0);
            self.sizeLab.backgroundColor = THEME_COLOR_Alpha(0.2);
        }else{
            self.sizeLab.layer.borderColor = LINE_COLOR.CGColor;
            self.sizeLab.textColor = TEXT_COLOR;
            self.sizeLab.backgroundColor = [UIColor whiteColor];
        }
    }
}

@end
