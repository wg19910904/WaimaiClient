//
//  ZQPhotoAlbumCell.m
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQPhotoAlbumCell.h"
#import "ZQPhotoModelTool.h"
@interface ZQPhotoAlbumCell()
// 屏幕宽高
#define The_WIDTH [UIScreen mainScreen].bounds.size.width
#define The_Hex(x,y) [ZQPhotoModelTool colorWithHex:x alpha:y]
@property(nonatomic,strong)CALayer *line;//底部的分割线
@property(nonatomic,strong)UILabel *countL;//显示的相册中包含的个数
@property(nonatomic,strong)UIImageView *imgV;//显示相册中的最后一张图片的
@property(nonatomic,strong)UILabel *name;//显示图片的名字的
@end
@implementation ZQPhotoAlbumCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self line];
        [self countL];
        [self imgV];
        [self name];
    }
    return self;
}
//底部的分割线
-(CALayer *)line{
    if (!_line) {
        _line = [[CALayer alloc]init];
        _line.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2].CGColor;
        _line.frame = CGRectMake(0, 79.5, The_WIDTH, 0.5);
        [self.layer addSublayer:_line];
    }
    return _line;
}
//显示的相册中包含的个数
-(UILabel *)countL{
    if (!_countL) {
        _countL = [[UILabel alloc]init];
        _countL.textColor = The_Hex(@"333333", 1);
        _countL.font = [UIFont systemFontOfSize:16];
        _countL.textAlignment = NSTextAlignmentRight;
        _countL.frame = CGRectMake(The_WIDTH - 90, 30, 60, 20);
        [self addSubview:_countL];
    }
    return _countL;
}
//显示相册中的最后一张图片的
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.frame = CGRectMake(12, 10, 60, 60);
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.clipsToBounds = YES;
        _imgV.image = [UIImage imageNamed:@"default.png"];
        [self addSubview:_imgV];
    }
    return _imgV;
}
//显示名字的
-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = The_Hex(@"333333", 1);
        _name.font = [UIFont systemFontOfSize:15];
        _name.frame = CGRectMake(87, 30, The_WIDTH/2, 20);
        [self addSubview:_name];
    }
    return _name;
}
-(void)setModel:(ZQAlbumModel *)model{
    _model = model;
    _countL.text = @(model.count).stringValue;
    _name.text = model.name;
    [ZQPhotoModelTool getScaleImageWithAsset:model.result.lastObject block:^(UIImage *image) {
        _imgV.image = image;
    }];
}
@end
