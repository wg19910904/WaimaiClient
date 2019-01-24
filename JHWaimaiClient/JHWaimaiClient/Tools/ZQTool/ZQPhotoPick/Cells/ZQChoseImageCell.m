//
//  ZQChoseImageCell.m
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQChoseImageCell.h"
#import "ZQPhotoModelTool.h"
@interface ZQChoseImageCell()
@property(nonatomic,strong)UIImageView *imgV;//显示相册中的图片的
@property(nonatomic,strong)UIButton * selecterBtn;//选中的按钮
@end
@implementation ZQChoseImageCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self imgV];
        [self selecterBtn];
    }
    return self;
}
//显示相册图片的
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.clipsToBounds = YES;
        _imgV.image = [UIImage imageNamed:@"default.png"];
        _imgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgV)];
        [_imgV addGestureRecognizer:tap];
        [self addSubview:_imgV];
    }
    return _imgV;
}
//选中的按钮
-(UIButton *)selecterBtn{
    if (!_selecterBtn) {
        _selecterBtn = [[UIButton alloc]init];
        [_selecterBtn setBackgroundImage:[UIImage imageNamed:@"photo_def"] forState:UIControlStateNormal];
        [_selecterBtn setBackgroundImage:[UIImage imageNamed:@"photo_sel"] forState:UIControlStateSelected];
        [_selecterBtn addTarget:self action:@selector(clickImgV) forControlEvents:UIControlEventTouchUpInside];
        _selecterBtn.frame = CGRectMake(self.frame.size.width - 25, 0, 25, 25);
        [_imgV addSubview:_selecterBtn];
        
    }
    return _selecterBtn;
}
-(void)clickImgV{
    if (!_selecterBtn.selected && ![self getAllImage]) {
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"您最多只能选择%ld张照片", nil),self.maxNum];
        [self showAlert:str];
        return;
    }
    _selecterBtn.selected = !_selecterBtn.selected;
    if (_selecterBtn.selected) {
        __weak typeof(self) weakSelf=self;
        [ZQPhotoModelTool getOriginImageWithAsset:_asset block:^(UIImage *image) {
            if (weakSelf.myBlock) {
                weakSelf.myBlock(YES,image);
            }
        }];
    }else{
        if (self.myBlock) {
            self.myBlock(NO,nil);
        }
    }
    
}
-(void)setModel:(ZQImageModel *)model{
    _model = model;
    _selecterBtn.selected = model.isSelector;
}
-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
    [ZQPhotoModelTool getScaleImageWithAsset:asset block:^(UIImage *image) {
        _imgV.image = image;
    }];
}
#pragma mark - 获取所有选中的图片
-(BOOL)getAllImage{
    NSInteger i = 0;
    for (ZQImageModel *model in _arr) {
        if (model.isSelector) {
            i++;
        }
    }
    return i==self.maxNum?NO:YES;
}
-(void)showAlert:(NSString *)msg{
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil]];
    
    [self.superVC presentViewController:alertControl animated:YES completion:nil];
}
@end
