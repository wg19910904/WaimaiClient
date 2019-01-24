//
//  JHWaimaiOrderDetailDefaultCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailDefaultCell.h"
@interface JHWaimaiOrderDetailDefaultCell()
@property(nonatomic,strong)UIView *bottomLine;//底部的线
@end
@implementation JHWaimaiOrderDetailDefaultCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self bottomLine];
        [self leftLabel];
        [self rightLabel];
    }
    return self;
}
#pragma mark - 底部的线
-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = LINE_COLOR;
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.offset = 0;
            make.height.offset = 0.5;
        }];
    }
    return _bottomLine;
    
}
-(void)setIsHidden:(BOOL)isHidden{
    _isHidden = isHidden;
    _bottomLine.hidden = isHidden;
}
#pragma mark - 左边的显示
-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.textColor = HEX(@"666666", 1);
        _leftLabel.font = FONT(12);
        _leftLabel.numberOfLines = 0;
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 13;
            //make.height.offset = 15;
            make.top.offset = 13;
            make.right.offset = -30;
            make.bottom.offset = -13;
        }];
    }
    return _leftLabel;
}
#pragma mark - 右边的显示
-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.textColor = HEX(@"333333", 1);
        _rightLabel.font = FONT(12);
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -13;
            //make.height.offset = 15;
            make.top.offset = 13;
            make.bottom.offset = -13;
        }];
    }
    return _rightLabel;
}
-(void)setLeftTitle:(NSString *)leftTitle{
    _leftTitle = leftTitle;
    _leftLabel.text = leftTitle;
}
-(void)setRightTitle:(NSString *)rightTitle{
    _rightTitle = rightTitle;
    _rightLabel.text = rightTitle;
}
@end
