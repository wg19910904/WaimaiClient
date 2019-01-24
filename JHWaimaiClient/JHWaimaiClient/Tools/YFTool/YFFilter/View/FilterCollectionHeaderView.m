//
//  FilterCollectionHeaderView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "FilterCollectionHeaderView.h"

@interface FilterCollectionHeaderView ()
@property(nonatomic,weak)UILabel *titleLab;
@end

@implementation FilterCollectionHeaderView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
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
    UILabel *titleLab = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH-60, 40)];
    [self addSubview:titleLab];
    titleLab.textColor = HEX(@"999999", 1.0);
    titleLab.font = FONT(14);
    self.titleLab = titleLab;
    
}

-(void)reloadViewWithTitle:(NSString *)titleStr{
    self.titleLab.text = titleStr;
}

@end
