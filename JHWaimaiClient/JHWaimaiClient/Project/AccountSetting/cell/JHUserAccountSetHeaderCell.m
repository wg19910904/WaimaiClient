//
//  JHUserAccountSetHeaderCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHUserAccountSetHeaderCell.h"
#import <UIImageView+WebCache.h>
#import "JHUserModel.h"
@interface JHUserAccountSetHeaderCell()
@property(nonatomic,strong)UILabel *titleL;//标题
@property(nonatomic,strong)UIImageView *imgV;//显示图片
@end
@implementation JHUserAccountSetHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self titleL];
        [self imgV];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}
#pragma mark - 标题
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = NSLocalizedString(@"头像", nil);
        _titleL.font = FONT(16);
        _titleL.textColor = HEX(@"666666", 1);
        [self addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.offset = 20;
        }];
    }
    return _titleL;
}
#pragma mark - 头像
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        JHUserModel *model = [JHUserModel shareJHUserModel];
        [_imgV sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:model.face]] placeholderImage:IMAGE(@"head36_default")];
        _imgV.layer.cornerRadius = 15;
        _imgV.layer.masksToBounds = YES;
        [self addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -31;
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.width.offset = 30;
        }];
    }
    return _imgV;
}
-(void)setImg:(UIImage *)img{
    _img = img;
    if (_isUpSuccess) {
        _imgV.image = img;
    }
}
@end
