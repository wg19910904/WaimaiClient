//
//  JHHomeTitleCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/27.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeTitleCell.h"

@implementation JHHomeTitleCell
{
    UILabel *_titleL;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //UI
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}
#pragma mark - UI
- (void)setupUI{
    _titleL = [UILabel new];
    [self.contentView addSubview:_titleL];
    _titleL.font = B_FONT(18);
    _titleL.textColor = HEX(@"333333", 1.0);
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.top.offset =10;
        make.height.offset = 24;
        make.bottom.offset = -10;
    }];
    _titleL.text = NSLocalizedString(@"附近商家", nil);
}

@end
