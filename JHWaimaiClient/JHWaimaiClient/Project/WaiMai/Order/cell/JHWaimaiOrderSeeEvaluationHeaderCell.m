//
//  JHWaimaiOrderSeeEvaluationHeaderCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderSeeEvaluationHeaderCell.h"
#import <UIImageView+WebCache.h>
#import "YFStartView.h"
#import "YFDisplayImagesVC.h"
@interface JHWaimaiOrderSeeEvaluationHeaderCell()<PresentAnimationTransitionShowImgDelegate>{
    UIImageView * lastImgV;//指向最后一张图片
    NSInteger selectIndex;//选中的索引
}
@property(nonatomic,strong)UIImageView *shopImgV;//这是商家的图标
@property(nonatomic,strong)UILabel *shopNameL;//商家的名字
@property(nonatomic,strong)UIView *lineL;//中间的线
@property(nonatomic,strong)UILabel *dafenL;//显示商家打分的按钮
@property(nonatomic,strong)YFStartView *starView;//可以用来评价的星星
@property(nonatomic,strong)UILabel *evaluateL;//评价的内容
@property(nonatomic,strong)UIView *replyView;//承载商家回复的View
@property(nonatomic,strong)UILabel *replyLable;//商家回复的内容
@property(nonatomic,strong)NSMutableArray *imgArr;
@end
@implementation JHWaimaiOrderSeeEvaluationHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imgArr = @[].mutableCopy;
        [self shopImgV];
        [self shopNameL];
        [self lineL];
        [self dafenL];
        [self starView];
        [self evaluateL];
        [self replyView];
        [self replyLable];
    }
    return self;
}
#pragma mark - 这是商家的图标
-(UIImageView *)shopImgV{
    if (!_shopImgV) {
        _shopImgV = [[UIImageView alloc]init];
        _shopImgV.layer.cornerRadius = 30;
        _shopImgV.layer.masksToBounds = YES;
        [self addSubview:_shopImgV];
        [_shopImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.offset = 20;
            make.height.width.offset = 60;
        }];
    }
    return _shopImgV;
}
#pragma mark - 这是商家的名字
-(UILabel *)shopNameL{
    if (!_shopNameL) {
        _shopNameL = [[UILabel alloc]init];
        _shopNameL.textColor = HEX(@"333333", 1);
        _shopNameL.font = FONT(14);
        [self addSubview:_shopNameL];
        [_shopNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_shopImgV.mas_bottom).offset = 10;
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.offset = 16;
        }];
    }
    return _shopNameL;
}
#pragma mark - 中间的线
-(UIView *)lineL{
    if (!_lineL) {
        _lineL = [UIView new];
        _lineL.backgroundColor = HEX(@"eae6ed", 1);
        [self addSubview:_lineL];
        [_lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 50;
            make.right.offset = -50;
            make.height.offset = 0.5;
            make.top.mas_equalTo(_shopNameL.mas_bottom).offset = 20;
        }];
    }
    return _lineL;
}
#pragma mark - 这是显示商家打分的
-(UILabel *)dafenL{
    if (!_dafenL) {
        _dafenL = [[UILabel alloc]init];
        _dafenL.backgroundColor = [UIColor whiteColor];
        _dafenL.text = NSLocalizedString(@"商家打分", nil);
        _dafenL.textColor = HEX(@"999999", 1);
        _dafenL.font = FONT(12);
        _dafenL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dafenL];
        [_dafenL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(_lineL.mas_centerY);
            make.height.offset = 14;
            make.width.offset = 60;
        }];
    }
    return _dafenL;
}
#pragma mark - 这是评价的星星
-(YFStartView *)starView{
    if (!_starView) {
        _starView = [[YFStartView alloc]init];
        _starView.starType = YFStarViewFloat;
        _starView.interSpace = 10;
        _starView.userInteractionEnabled = NO;
        [self addSubview:_starView];
   }
    return _starView;
}
#pragma mark - 显示评价内容的
-(UILabel *)evaluateL{
    if (!_evaluateL) {
        _evaluateL = [[UILabel alloc]init];
        _evaluateL.textColor = HEX(@"333333", 1);
        _evaluateL.font = FONT(14);
        _evaluateL.numberOfLines = 0;
        [self addSubview:_evaluateL];
    }
    return _evaluateL;
}
#pragma mark - 商家回复
-(UIView *)replyView{
    if (!_replyView) {
        _replyView = [[UIView alloc]init];
        _replyView.backgroundColor = BACK_COLOR;
        _replyView.layer.cornerRadius = 6;
        _replyView.layer.masksToBounds = YES;
        [self addSubview:_replyView];
        _replyLable = [[UILabel alloc]init];
        _replyLable.textColor = HEX(@"333333", 1);
        _replyLable.font = FONT(14);
        _replyLable.numberOfLines = 0;
        [_replyView addSubview:_replyLable];
    }
    return _replyView;
}
//数据模型
-(void)setModel:(JHWaimaiOrderSeeEvaliationModel *)model{
    _model = model;
    if (!model) {
        return;
    }
    [_shopImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.shop_logo]] placeholderImage:IMAGE(@"logo_shop60_default")];
    _shopNameL.text = model.shop_title;
    [self makeStarViewLocation];
    [self makeEvaluateLocation];
    [self creatEvaluateImgV];
    [self makeReplyLacation];
    
}
#pragma mark - 处理星星的位置的
-(void)makeStarViewLocation{
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_dafenL.mas_bottom).offset = 15;
        make.height.offset = 26;
        make.width.offset = 140;
        if (_model.content.length == 0 && _model.reply.length == 0 && _model.photos.count == 0) {
            make.bottom.offset = -10;
        }
        
    }];
    _starView.currentStarScore = [_model.score floatValue];
}
#pragma mark - 处理评价的内容的位置的
-(void)makeEvaluateLocation{
    _evaluateL.text = _model.content;
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:_evaluateL.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:4];
    [attribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, _evaluateL.text.length)];
    _evaluateL.attributedText = attribute;
    
    [_evaluateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.top.mas_equalTo(_starView.mas_bottom).offset = 15;
        make.right.offset = -12;
        if (_model.photos.count == 0 && _model.reply.length == 0) {
            make.bottom.offset = -10;
        }
    }];

}
#pragma mark - 这是处理有评价图片时的操作
-(void)creatEvaluateImgV{
    CGFloat w = (WIDTH - 60)/5;
    for (UIImageView *imgV in _imgArr) {
        [imgV removeFromSuperview];
    }
    [_imgArr removeAllObjects];
    for (int i = 0; i < _model.photos.count;i++) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,_model.photos[i][@"photo"]];
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        imgV.tag = i;
        [imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:IMAGE(@"membercard70_default")];
        [self addSubview:imgV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgv:)];
        imgV.userInteractionEnabled = YES;
        [imgV addGestureRecognizer:tap];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10+(w+10)*i;
            make.top.mas_equalTo(_evaluateL.mas_bottom).offset = 10;
            make.height.width.offset = w;
            if (_model.reply.length == 0 && i == _model.photos.count - 1) {
                make.bottom.offset = -10;
            }
        }];
        if (i == _model.photos.count - 1) {
             lastImgV = imgV;
        }
        [_imgArr addObject:imgV];
    }
}
#pragma makr - 点击图片
-(void)clickImgv:(UITapGestureRecognizer *)tap{
    selectIndex = tap.view.tag;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in _model.photos) {
        [arr addObject:dic[@"photo"]];
    }
    YFDisplayImagesVC *displayerVC = [YFDisplayImagesVC new];
    displayerVC.imgsArr = arr.copy;
    displayerVC.index = tap.view.tag;
    displayerVC.presentAnimation.delegate = self;
    displayerVC.clickDismiss = ^(NSInteger index){
        selectIndex = index;
    };
    [self.superVC presentViewController:displayerVC animated:YES completion:nil];

}
#pragma mark ======PresentAnimationTransitionShowImgDelegate=======
-(UIImage *)presentAnimationTransitionWillNeedView{
    UIImageView *imgView = _imgArr[selectIndex];
    return imgView.image;
}

-(CGRect)presentAnimationTransitionViewFrame{
    UIImageView *imgView = _imgArr[selectIndex];
    return [self convertRect:imgView.frame toView:self.superVC.view];
}
#pragma mark - 处理回复内容的位置的
-(void)makeReplyLacation{
    if (_model.reply.length == 0) {
        _replyView.hidden = YES;
        return;
    }
    NSString *str = [NSLocalizedString(@"商家回复: ", nil)stringByAppendingString:_model.reply];
    _replyLable.text = str;
    CGFloat height = [str boundingRectWithSize:CGSizeMake(WIDTH - 48, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    [_replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.right.offset = -12;
        make.height.offset = height + 30;
        if (lastImgV) {
             make.top.mas_equalTo(lastImgV.mas_bottom).offset = 10;
        }else{
             make.top.mas_equalTo(_evaluateL.mas_bottom).offset = 10;
        }
        make.bottom.offset = -10;
    }];
    [_replyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.right.offset = -12;
        make.top.offset = 15;
    }];
}
@end
