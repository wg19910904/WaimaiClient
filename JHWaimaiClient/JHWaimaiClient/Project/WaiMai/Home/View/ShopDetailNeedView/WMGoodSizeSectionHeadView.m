//
//  WMGoodSizeSectionHeadView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/23.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMGoodSizeSectionHeadView.h"

@interface WMGoodSizeSectionHeadView ()
@property(nonatomic,weak)UILabel *titleLab;
@end

@implementation WMGoodSizeSectionHeadView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{

    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    titleLab.textColor = TEXT_COLOR;
    titleLab.font = FONT(14);
    self.titleLab = titleLab;
    
}

-(void)reloadViewWith:(NSString *)titleStr{
    self.titleLab.text = titleStr;
}

@end
