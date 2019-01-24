//
//  JHHomeEmptyCellTableViewCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/9/6.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeEmptyFoot.h"

@implementation JHHomeEmptyFoot
{
    UIImageView *_emptyIV;
}
- (instancetype)initWithFrame:(CGRect)frame showEmpty:(BOOL)showEmpty{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        if (showEmpty) {
            [self setupUI];
        }
    }
    return self;
}
- (void)setupUI{
    _emptyIV = [UIImageView new];
    [self addSubview:_emptyIV];
    [_emptyIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset = 0;
        make.width.offset = 242;
        make.height.offset = 150;
    }];
    _emptyIV.image = IMAGE(@"icon_wu");
}

@end
