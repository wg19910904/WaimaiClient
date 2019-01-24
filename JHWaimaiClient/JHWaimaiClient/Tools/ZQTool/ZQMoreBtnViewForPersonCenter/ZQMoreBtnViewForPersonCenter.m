//
//  ZQMoreBtnViewForPersonCenter.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/7/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQMoreBtnViewForPersonCenter.h"
#import "ZQPerSonCenterBtn.h"
@interface ZQMoreBtnViewForPersonCenter()
{
    NSMutableArray *btnArr;
}
@end
@implementation ZQMoreBtnViewForPersonCenter
-(instancetype)init{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}
-(void)config{
    self.backgroundColor = [UIColor whiteColor];
    btnArr = @[].mutableCopy;
}
-(void)setDelegate:(id<ZQMoreBtnViewDelegate>)delegate{
    _delegate = delegate;
    //按钮的个数
    NSInteger num = [_delegate moreBtnViewNumberOfBtn];
    //图片的数组
    NSArray *imgArr = [_delegate moreBtnViewForBtnImage];
    //文字的数组
    NSArray *textArr = [_delegate moreBtnViewForTitle];
    float btn_w = WIDTH/num;
    for (int i = 0; i < num; i++) {
        ZQPerSonCenterBtn *btn = [[ZQPerSonCenterBtn alloc]init];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        [self addSubview:btn];
        btn.imageV.image = [UIImage imageNamed:imgArr[i]];
        btn.textL.text = textArr[i];
        if (_isShowLine&&i!=num-1) {
            btn.isShowLine = YES;
        }
        if ([self.delegate respondsToSelector:@selector(moreBtnViewForBtnValue:)]) {
            btn.num = [_delegate moreBtnViewForBtnValue:i];
        }
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = btn_w*i;
            make.height.mas_equalTo(self.mas_height);
            make.top.bottom.offset = 0;
            make.width.offset = btn_w;
        }];
        [btnArr addObject:btn];
    }
}
-(void)clickBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreBtnViewDidSelector:)]) {
        [self.delegate moreBtnViewDidSelector:sender.tag];
    }
}
//刷新角标数据的(所有一起刷新)
-(void)reloadData{
    for (ZQPerSonCenterBtn *btn in btnArr) {
    if ([self.delegate respondsToSelector:@selector(moreBtnViewForBtnValue:)]) {
        btn.num = [_delegate moreBtnViewForBtnValue:btn.tag];
       }
    }
}
//刷新某一个的数值的
-(void)reloadDataWithIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(moreBtnViewForBtnValue:)]) {
        ZQPerSonCenterBtn *btn = btnArr[index];
        btn.num = [_delegate moreBtnViewForBtnValue:index];
    }
}
//是否展示分割线
-(void)setIsShowLine:(BOOL)isShowLine{
    _isShowLine = isShowLine;
    for (int i = 0; i < btnArr.count; i++) {
        ZQPerSonCenterBtn *btn = btnArr[i];
        if (isShowLine&&i!=btnArr.count - 1) {
            btn.isShowLine = YES;
        }
    }
}

@end
