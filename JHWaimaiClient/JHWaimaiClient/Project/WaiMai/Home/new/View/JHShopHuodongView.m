//
//  JHShopHuodongView.m
//  JHWaimaiClient
//
//  Created by xixixi on 2018/11/9.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHShopHuodongView.h"

#define xh_getStrBounds(str,width,font)  [str boundingRectWithSize:CGSizeMake(width, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size
#define xh_huodong_width WIDTH-134
@implementation JHShopHuodongView
{
    CGFloat available_width; //当前可用宽度
    CGFloat current_y;  //当前按钮的y点
    UIButton *_arrowBtn; //活动二的展开箭头
}
- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)setupUI{
    //
    self.arrowBtn = [UIButton new];
    [self addSubview:_arrowBtn];
    [_arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 40;
        make.height.offset = 30;
        make.top.right.offset = 0;
    }];
    [_arrowBtn setImageEdgeInsets:UIEdgeInsetsMake(6,15.5,18,15.5)];
    [_arrowBtn setImage:IMAGE(@"btn_arrow_down_small") forState:UIControlStateNormal];
    [_arrowBtn setImage:IMAGE(@"btn_arrow_top_small") forState:UIControlStateSelected];
    //
    for (int i = 0; i < 20; i++) {
        UIButton *desLBtn = [UIButton new];
        [self addSubview:desLBtn];
        desLBtn.tag = 100+i;
    }
}

- (void)updateWithTitle:(NSArray *)titleArr showMore:(BOOL)showMore{
    available_width = WIDTH - 132;
    current_y = 0.0;
    //
    NSUInteger count = titleArr.count;
    for (int i = 0; i < count; i++) {
        NSString *title = titleArr[i];
        UIButton *currentBtn = (UIButton *)[self viewWithTag:100+i];
        if (currentBtn == nil) {
            [self addSubview:currentBtn];
            currentBtn.tag = 100+i;
        }
        [currentBtn setTitle:title forState:UIControlStateNormal];
        currentBtn.layer.cornerRadius = 1;
        currentBtn.layer.masksToBounds = YES;
        currentBtn.titleLabel.font = FONT(11);
        currentBtn.layer.borderWidth = 1.0;
        if ([title isEqualToString:NSLocalizedString(@"支持自提", "")] ||
            [title isEqualToString:NSLocalizedString(@"极速退款", "")]) {
            [currentBtn setTitleColor:HEX(@"666666 ", 1.0) forState:(UIControlStateNormal)];
            currentBtn.layer.borderColor = HEX(@"eeeeee", 1.0).CGColor;
        }else{
            [currentBtn setTitleColor:HEX(@"FF4D5B", 1.0) forState:(UIControlStateNormal)];
            currentBtn.layer.borderColor = HEX(@"FCE9E9", 1.0).CGColor;
        }
        currentBtn.frame = [self getBtnFrame:title];
        if (showMore == NO && currentBtn.y > 0) {
            currentBtn.hidden = YES;
        }else{
            currentBtn.hidden = NO;
        } 
    }
    for (int i=count; i<20; i++) {
        UIButton *currentBtn = (UIButton *)[self viewWithTag:100+i];
        currentBtn.hidden = YES;
    }
    //
    _arrowBtn.hidden = (current_y == 0.0);
}

- (CGRect)getBtnFrame:(NSString *)title{
    CGSize size = xh_getStrBounds(title, WIDTH, 11);
    CGFloat btn_width = size.width+10;
    
    CGRect btn_frame = CGRectZero;
    if (btn_width <= available_width) {
        btn_frame = CGRectMake(xh_huodong_width - available_width,current_y, btn_width, 18);
        available_width -= (btn_width+4);
    }else{
        current_y += (18 + 4);
        btn_frame = CGRectMake(0, current_y, btn_width, 18);
        available_width = xh_huodong_width - btn_width;
    }
    return btn_frame;
}
- (CGFloat)totalHeight{
    return current_y+18.0;
}
- (void)hiddenBtns{
    for (UIButton *btn in self.subviews) {
        if (btn.y > 0) {
            btn.hidden = YES;
        }
    }
    self.clipsToBounds = YES;
}
@end
