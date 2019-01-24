//
//  JHWaiMaiAddAddressTagCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiAddAddressTagCell.h"
@interface JHWaiMaiAddAddressTagCell (){
    NSMutableArray * btnArr;
}
@end
@implementation JHWaiMaiAddAddressTagCell

- (instancetype)init{
    if (self = [super init]) {
        btnArr = @[].mutableCopy;
        [self setupView];
        self.backgroundColor = HEX(@"ffffff", 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;

}
- (void)setupView{
    self.titleL = [[UILabel alloc] initWithFrame:FRAME(12, 0, 62, 50)];
    self.titleL.font = FONT(14);
    self.titleL.textColor = HEX(@"333333", 1.0);
    [self addSubview:self.titleL];
    
    NSArray *titleArr = @[NSLocalizedString(@"家", nil),
                          NSLocalizedString(@"公司", nil),
                          NSLocalizedString(@"学校", nil),
                          NSLocalizedString(@"其他", nil)];
    //循环创建按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:FRAME(74*SCALE+70*SCALE*i,10, 60*SCALE, 30*SCALE)];
        [btn setTitle:titleArr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:HEX(@"222222", 1.0) forState:UIControlStateNormal];
        [btn setTitleColor:THEME_COLOR_Alpha(1.0) forState:UIControlStateSelected];
        btn.titleLabel.font = FONT(14);
        btn.layer.cornerRadius = 2;
        btn.layer.borderWidth = 0.7;
        btn.layer.borderColor = HEX(@"e6eaed", 1.0).CGColor;
        btn.clipsToBounds = YES;
        btn.tag = i+1;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        [btnArr addObject:btn];
    }
}
-(void)setIndex:(NSInteger)index{
    _index = index;
    for (UIButton *btn in btnArr) {
        if (btn.tag == index) {
            btn.selected = YES;
            btn.layer.borderColor = THEME_COLOR_Alpha(1.0).CGColor;
            self.selectedBtn = btn;
        }
    }
}
- (void)clickBtn:(UIButton *)sender{
    self.selectedBtn.selected = NO;
    self.selectedBtn.layer.borderColor = HEX(@"e6eaed", 1.0).CGColor;
    sender.selected = YES;
    sender.layer.borderColor = THEME_COLOR_Alpha(1.0).CGColor;
    self.selectedBtn = sender;
    if (self.myBlock) {
        self.myBlock(sender.tag);
    }
}
@end

