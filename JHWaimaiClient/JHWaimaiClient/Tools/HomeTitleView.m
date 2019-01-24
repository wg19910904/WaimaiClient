//
//  HomeTitleView.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/25.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "HomeTitleView.h"
#import "MarqueeLabel.h"
@interface HomeTitleView()
@property(nonatomic,strong)UIImageView *leftImgV;//左边的图片
@property(nonatomic,strong)UIImageView *rightImgV;//右边的图片
@property(nonatomic,strong)MarqueeLabel *addressLabel;//显示地址
@end
@implementation HomeTitleView

/**
 展示标题的view
 
 @param title 需要展示的标题
 @param frame 位置大小
 @param view  承载的View
 */
+(HomeTitleView *)showViewWithTitle:(NSString *)title
                   frame:(CGRect )frame
                withView:(UINavigationItem *)view{
    
    HomeTitleView *currentView = [[HomeTitleView alloc]init];
    currentView.frame = frame;
    currentView.layer.cornerRadius = frame.size.height/2;
    currentView.layer.masksToBounds = YES;
    currentView.backgroundColor = HEX(@"000000", 0.4);
    //左边的图片
    [currentView leftImgV];
    //右边的图片
    [currentView rightImgV];
    //显示地址
    currentView.addressLabel.text = title;
    currentView.addressLabel.textAlignment = NSTextAlignmentCenter;
    currentView.intrinsicContentSize = frame.size;
    view.titleView = currentView;
    return currentView;
}
//左边的图片
-(UIImageView *)leftImgV{
    if (!_leftImgV) {
        _leftImgV = [[UIImageView alloc]init];
        _leftImgV.image = IMAGE(@"index_btn_location_white");
        [self addSubview:_leftImgV];
        [_leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset =  10;
            make.centerY.offset = 0;
            make.width.offset = 20;
        }];
        _leftImgV.contentMode = UIViewContentModeCenter;
    }
    return _leftImgV;
}
//右边的图片
-(UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        _rightImgV.image = IMAGE(@"index_arrow_down_white");
        [self addSubview:_rightImgV];
        [_rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.right.offset = -10;
            make.width.offset = 20;
        }];
        _rightImgV.contentMode = UIViewContentModeCenter;
    }
    return _rightImgV;
}
//显示地址
-(MarqueeLabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[MarqueeLabel alloc]init];
        _addressLabel.scrollDuration = 9;
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.textColor = [UIColor whiteColor];
        _addressLabel.font = FONT(14);
        [self addSubview:_addressLabel];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_leftImgV.mas_right).offset = 5;
            make.right.equalTo(_rightImgV.mas_left).offset = -5;
            make.top.offset = 4;
            make.height.offset = 20;
        }];
    }
    return _addressLabel;
}
-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    _addressLabel.text = titleText;
}

-(void)setBackViewAlpha:(float)backViewAlpha{
    float alpha =  0.4 * backViewAlpha;
    self.backgroundColor = HEX(@"000000",alpha);
}
@end
