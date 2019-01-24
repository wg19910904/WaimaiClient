//
//  JHWMChooseFirstYouHuiCell.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/9/27.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHWMChooseFirstYouHuiCell.h"


@interface JHWMChooseFirstYouHuiCell ()

@end

@implementation JHWMChooseFirstYouHuiCell

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
    
    UILabel *lab = [UILabel new];
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=10;
        make.height.offset=20;
        make.bottom.offset=-10;
    }];
    lab.font = FONT(14);
    lab.textColor = TEXT_COLOR;
    lab.text = NSLocalizedString(@"首单优惠", @"JHWMCreateOrderVC");
    
    SevenSwitch * youhuiSwitch = [[SevenSwitch alloc] initWithFrame:FRAME(WIDTH-55, 10, 45, 25)];
    youhuiSwitch.tintColor=THEME_COLOR_Alpha(1.0);
    youhuiSwitch.onStr=@"";
    youhuiSwitch.offStr=@"";
    youhuiSwitch.thumbTintColor = HEX(@"fafafa", 1.0);
    [youhuiSwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:youhuiSwitch];
    [youhuiSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-15;
        make.centerY.offset=0;
        make.width.offset=45;
        make.height.offset=25;
    }];
    youhuiSwitch.on = YES;
    self.youhuiSwitch = youhuiSwitch;
}

-(void)swChange:(SevenSwitch *)sw{
    YF_SAFE_BLOCK(self.swChangeValueBlock,sw.on,@"");
}

@end
