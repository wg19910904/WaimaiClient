//
//  ZQProgressHud.m
//  ttt
//
//  Created by ijianghu on 2017/8/3.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQProgressHud.h"
@interface ZQProgressHud()
@property(nonatomic,strong)UIView *fatherView;//父视图
@property(nonatomic,strong)UIWebView *centerView;//中间用以承载UIActivityIndicatorView
@end
@implementation ZQProgressHud
-(instancetype)init{
    self = [super init];
    if (self) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        self.fatherView = window;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, self.fatherView.frame.size.width, self.fatherView.frame.size.height);
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        self.fatherView = window;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, self.fatherView.frame.size.width, self.fatherView.frame.size.height);
    }
    return self;
}
/**
 初始化的方法
 
 @param view 加载在哪个view上
 @return 返回创建的对象
 */
-(instancetype)initWithView:(UIView *)view{
    self = [super init];
    if (self) {
        self.fatherView = view;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, self.fatherView.frame.size.width, self.fatherView.frame.size.height);
    }
    return self;
}
//中间用以承载UIActivityIndicatorView
-(UIWebView *)centerView{
    if (!_centerView) {
        _centerView = [UIWebView new];
        _centerView.center = self.center;
        _centerView.backgroundColor = [UIColor clearColor];
        _centerView.layer.cornerRadius = 4;
        _centerView.layer.masksToBounds = YES;
        _centerView.userInteractionEnabled = NO;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        _centerView.scalesPageToFit = YES;
        [_centerView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        CGSize size = [UIImage imageNamed:@"loading.gif"].size;
        _centerView.bounds = CGRectMake(0, 0, size.width/2, size.height/2);
        _centerView.scrollView.backgroundColor = [UIColor clearColor];
        [_centerView setOpaque:NO];
    }
    return _centerView;
}

-(void)setViewTintColor:(UIColor *)viewTintColor{
    _viewTintColor = viewTintColor;
    if (_centerView) {
        _centerView.backgroundColor = viewTintColor;
    }
}
-(void)setViewWidth:(CGFloat)viewWidth{
    _viewWidth = viewWidth;
    if (_centerView) {
        _centerView.bounds = CGRectMake(0, 0, viewWidth, viewWidth);
    }
}
//显示hud的方法
-(void)showHud{
    [self.fatherView addSubview:self];
    [self addSubview:self.centerView];
}
//隐藏hud的方法
-(void)removeHud{
    [self removeFromSuperview];
}
/**
 类方法移除(宏定义时需要)
 
 @param view 从哪个视图移除
 */
+(void)removeHudInView:(UIView *)view{
    if (!view) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    for (UIView *tempView in view.subviews) {
        if ([tempView isKindOfClass:[ZQProgressHud class]]) {
            [tempView removeFromSuperview];
            break;
        }
    }
}
@end
