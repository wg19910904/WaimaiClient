//
//  JHUserAccountChoseSexCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/3.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHUserAccountChoseSexCell.h"
@interface JHUserAccountChoseSexCell()
@property(nonatomic,strong)UILabel *left_label;//左边的字
@property(nonatomic,strong)UIImageView *imgV;//选择的图片
@property(nonatomic,strong)UIView *lineV;//分割线
@end
@implementation JHUserAccountChoseSexCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self left_label];
        [self lineV];
        [self imgV];
    }
    return self;
}
#pragma mark - 这是左边的字
-(UILabel *)left_label{
    if (!_left_label) {
        _left_label = [[UILabel alloc]init];
        _left_label.textColor = HEX(@"333333", 1);
        _left_label.font = FONT(14);
        [self addSubview:_left_label];
        [_left_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.top.offset = 15;
            make.height.offset = 20;
        }];
    }
    return _left_label;
}
-(void)setLeftTitle:(NSString *)leftTitle{
    _leftTitle = leftTitle;
    _left_label.text = leftTitle;
}
#pragma mark - 分割线
-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = HEX(@"e6eaed", 1);
        [self addSubview:_lineV];
        [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.right.offset = -12;
            make.bottom.offset = 0;
            make.height.offset = 0.5;
        }];
    }
    return _lineV;
}
-(void)setIsHid:(BOOL)isHid{
    _isHid = isHid;
    _lineV.hidden = isHid;
}
#pragma mark - 右边的选择图片
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        [self addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.width.height.offset = 20;
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _imgV;
}
-(void)setIsSelector:(BOOL)isSelector{
    _isSelector = isSelector;
    if (isSelector) {
        _imgV.image = IMAGE(@"index_selector_enable");
    }else{
        _imgV.image = IMAGE(@"index_selector_disable");
    }
}
@end
