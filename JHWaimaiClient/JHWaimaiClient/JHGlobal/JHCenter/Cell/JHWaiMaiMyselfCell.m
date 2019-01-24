//
//  JHWaiMaiMyselfCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiMyselfCell.h"

@implementation JHWaiMaiMyselfCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self addSubview:self.leftIV];
    [self addSubview:self.rightL];
    [self addSubview:self.titleL];
    [self.layer addSublayer:self.line]; 
}

- (UIImageView *)leftIV{

    if (_leftIV == nil) {
        _leftIV = [[UIImageView alloc] initWithFrame:FRAME(12, 13, 20, 18)];
        _leftIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftIV;
}

- (UILabel *)titleL{
    if (_titleL == nil) {
        _titleL = [[UILabel alloc] initWithFrame:FRAME(44, 0,WIDTH - 88, 44)];
        _titleL.font = FONT(14);
        _titleL.textColor = HEX(@"333333", 1.0);
    }
    return _titleL;
}
- (UILabel *)rightL{
    if (_rightL == nil) {
        _rightL = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 120, 0,100, 44)];
        _rightL.font = FONT(12);
        _rightL.textColor = HEX(@"666666", 1.0);
    }
    return _rightL;
}
- (CALayer *)line{
    if (_line == nil) {
        _line = [CALayer layer];
        _line.frame = FRAME(12, 43.5, WIDTH-24, 0.5);
        _line.backgroundColor = HEX(@"e6eaed", 1.0).CGColor;
    }
    return _line;
}

@end
