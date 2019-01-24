//
//  JHMyaddressCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/28.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHMyaddressCell.h"
@interface JHMyaddressCell()
@property(nonatomic,strong)UILabel *nameL;
@property(nonatomic,strong)UILabel *addL;
@end
@implementation JHMyaddressCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatlineV];
        [self nameL];
        [self addL];
    }
    return self;
}
-(void)creatlineV{
    
    UIView *line = [[UIView alloc] initWithFrame:FRAME(32, 59, WIDTH-44, 1)];
    line.backgroundColor = HEX(@"f5f5f5", 1);
    [self addSubview:line];
}
#pragma mark - 姓名
-(UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = HEX(@"999999", 1);
        _nameL.font = FONT(12);
        [self addSubview:_nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 32;
            make.top.offset = 33;
            make.height.offset = 17;
        }];
    }
    return _nameL;
}
-(void)setName:(NSString *)name{
    _name = name;
    _nameL.text = name;
}
#pragma mark - 地址
-(UILabel *)addL{
    if (!_addL) {
        _addL = [[UILabel alloc]init];
        _addL.textColor = HEX(@"333333", 1);
        _addL.font = FONT(16);
        [self addSubview:_addL];
        [_addL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 32;
            make.top.offset = 10;
            make.height.offset = 22;
            make.right.offset = -10;
        }];
    }
    return _addL;
}
-(void)setAdd:(NSString *)add{
    _add = add;
    _addL.text = add;
}
@end
