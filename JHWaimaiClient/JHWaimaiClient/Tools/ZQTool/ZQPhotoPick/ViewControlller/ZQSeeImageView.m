//
//  ZQSeeImageView.m
//  ZQPhotos
//
//  Created by 洪志强 on 17/6/11.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQSeeImageView.h"
#import "ZQImageModel.h"
// 屏幕宽高
#define The_WIDTH [UIScreen mainScreen].bounds.size.width
#define The_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ZQSeeImageView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollV;//滑动视图
@property(nonatomic,strong)UILabel * label_image;
@end
@implementation ZQSeeImageView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self creatSubView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}
-(void)creatSubView{
    self.backgroundColor = [UIColor blackColor];
    self.frame = CGRectMake(0, 0, The_WIDTH, The_HEIGHT);
    self.alpha = 0;
    //创建点击view移除图片展示的view
    UITapGestureRecognizer * tap_remove = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove_image)];
    [self addGestureRecognizer:tap_remove];
    [self scrollV];
    [self label_image];
}
-(UIScrollView *)scrollV{
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc]init];
        _scrollV.bounds = CGRectMake(0, 0,The_WIDTH, The_HEIGHT);
        _scrollV.center = self.center;
        _scrollV.showsHorizontalScrollIndicator = NO;
        _scrollV.showsVerticalScrollIndicator = NO;
        _scrollV.pagingEnabled = YES;
        _scrollV.delegate = self;
        //滑动到头／尾的时候，不能滑动
        //_scrollV.bounces = NO;
        [self addSubview:_scrollV];
    }
    return _scrollV;
}
-(UILabel *)label_image{
    if (!_label_image) {
        _label_image = [[UILabel alloc]init];
        _label_image.backgroundColor = [UIColor blackColor];
        _label_image.frame = CGRectMake((The_WIDTH-50)/2,The_HEIGHT-30, 50, 20);
        _label_image.textAlignment = NSTextAlignmentCenter;
        _label_image.textColor  = [UIColor whiteColor];
        _label_image.backgroundColor = [UIColor clearColor];
        [self addSubview:_label_image];
    }
    return _label_image;
}
-(void)remove_image{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)showViewWithImgArr:(NSArray *)arr{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    _label_image.text = [NSString stringWithFormat:@"%d/%ld",1,arr.count];
    _scrollV.contentOffset = CGPointMake(0, 0);
    _scrollV.contentSize = CGSizeMake(The_WIDTH*arr.count, The_HEIGHT);
    _scrollV.tag = arr.count;
    for (UIImageView *view in _scrollV.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < arr.count; i++) {
        ZQImageModel * model = arr[i];
        CGFloat a = The_WIDTH/model.width;
        CGFloat h = model.height*a;
        if (h > The_HEIGHT - 80) {
            h = The_HEIGHT - 80;
        }
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*The_WIDTH, (The_HEIGHT - h)/2, The_WIDTH, h)];
        imageView.image = model.image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [_scrollV addSubview:imageView];
    }
}
#pragma mark - 这是滑动视图的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat f = scrollView.contentOffset.x/The_WIDTH+1;
    NSLog(@"%f",f);
    int  a = f;
    if (f+0.5 >= a+1) {
        a++;
    }
    _label_image.text = [NSString stringWithFormat:@"%d/%ld",a,scrollView.tag];
}
@end
