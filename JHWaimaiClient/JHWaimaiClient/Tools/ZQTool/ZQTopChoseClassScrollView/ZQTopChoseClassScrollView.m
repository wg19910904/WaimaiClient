//
//  ZQTopChoseClassScrollView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/6.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQTopChoseClassScrollView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define titleWidth 70
#define titleHeight 40
@interface ZQTopChoseClassScrollView()<UIScrollViewDelegate>{
     UIButton *selectButton;
     UIView *selecterLine;
     CGFloat lineW;
}
@property(nonatomic,retain)UIScrollView *scroll;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@end
@implementation ZQTopChoseClassScrollView
-(instancetype)init{
    self = [super init];
    if (self) {
        _buttonArray = @[].mutableCopy;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       _buttonArray = @[].mutableCopy;
    }
    return self;
}
-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self initWithTitleButton];
}
-(void)setIsBtnW_line:(BOOL)isBtnW_line{
    _isBtnW_line = isBtnW_line;
    if (selecterLine) {
        selecterLine.frame = FRAME(0, 39, lineW, 1);
    }
}
- (void)initWithTitleButton
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    if (titleWidth*_titleArray.count > SCREEN_WIDTH) {
        scroll.contentSize = CGSizeMake(titleWidth*_titleArray.count, 40);
    }else{
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH, 40);
    }
    scroll.bounces = YES;
    scroll.scrollEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    [scroll flashScrollIndicators];
    scroll.backgroundColor = [UIColor whiteColor];
    [self addSubview:scroll];
    _scroll = scroll;
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (titleWidth*_titleArray.count > SCREEN_WIDTH) {
            titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
        }else{
            CGFloat w = SCREEN_WIDTH/_titleArray.count;
            titleButton.frame = CGRectMake(w*i, 0, w, titleHeight);
        }
        [titleButton setTitle:_titleArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:THEME_COLOR_Alpha(1) forState:UIControlStateSelected];
        titleButton.backgroundColor = [UIColor whiteColor];
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.titleLabel.font = _titleFont?_titleFont: [UIFont systemFontOfSize:16];
        [scroll addSubview:titleButton];
        if (i == self.index) {
            titleButton.selected = YES;
            selectButton = titleButton;
        }
        [_buttonArray addObject:titleButton];
    }
    CGFloat w = titleWidth;
    if (titleWidth*_titleArray.count < SCREEN_WIDTH) {
       w = SCREEN_WIDTH/_titleArray.count;
    }
     lineW = w;
    NSString *title = _titleArray[0];
    CGFloat l = title.length*16+20;
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    bottomLine.frame = FRAME(0, 39.5,SCREEN_WIDTH, 0.5);
    [self addSubview:bottomLine];
    selecterLine = [[UIView alloc]init];
    selecterLine.backgroundColor = THEME_COLOR_Alpha(1);
    selecterLine.frame = FRAME(0, 38.5, self.isBtnW_line?lineW:l, 1.5);
    selecterLine.center = CGPointMake(selectButton.center.x, selecterLine.center.y);
    [scroll addSubview:selecterLine];
}
-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    if (_buttonArray.count > 0) {
        for (UIButton *btn in _buttonArray) {
            btn.titleLabel.font = titleFont;
        }
    }
}
- (void)scrollViewSelectToIndex:(UIButton *)button
{
    _index = button.tag-100;
    selectButton.selected = NO;
    button.selected = !button.selected;
    selectButton = button;
    if (self.clickBlock) {
        self.clickBlock(button.tag-100);
    }
    [UIView animateWithDuration:0.25 animations:^{
        selecterLine.center = CGPointMake(selectButton.center.x, selecterLine.center.y);
    }];
    if (titleWidth*_titleArray.count > SCREEN_WIDTH) {
        [self selectButton:button.tag-100];
    }
}
//选择某个标题
- (void)selectButton:(NSInteger)index
{
    CGRect rect = [selectButton.superview convertRect:selectButton.frame toView:self];
    CGPoint contentOffset = _scroll.contentOffset;
    [UIView animateWithDuration:0.25 animations:^{
        if (contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2)<=0) {
            [_scroll setContentOffset:CGPointMake(0, contentOffset.y) animated:NO];
        } else if (contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2)+SCREEN_WIDTH>=_titleArray.count*titleWidth) {
            [_scroll setContentOffset:CGPointMake(_titleArray.count*titleWidth-SCREEN_WIDTH, contentOffset.y) animated:NO];
        } else {
            [_scroll setContentOffset:CGPointMake(contentOffset.x - (SCREEN_WIDTH/2-rect.origin.x-titleWidth/2),contentOffset.y) animated:NO];
        }
    }];
}
-(void)setIndex:(NSInteger)index{
    _index = index;
    if (_titleArray.count > 0) {
        [self scrollViewSelectToIndex:_buttonArray[index]];
    }
}
@end
