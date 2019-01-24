//
//  UINavigationBar+Awesome.m
//  YFtab
//
//  Created by ios_yangfei on 16/12/1.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>
#import "JHBaseVC.h"

@implementation UINavigationBar (Awesome)

//添加属性
static char overlayKey;
static char titleViewKey;

static char currentVCKey;
static char lineViewKey;

- (JHBaseVC *)currentVC
{
    return objc_getAssociatedObject(self, &currentVCKey);
}

- (void)setCurrentVC:(JHBaseVC *)currentVC
{
    objc_setAssociatedObject(self, &currentVCKey, currentVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)lineView
{
    return objc_getAssociatedObject(self, &lineViewKey);
}

- (void)setLineView:(UIView *)lineView
{
    objc_setAssociatedObject(self, &lineViewKey, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)titleLab
{
    return objc_getAssociatedObject(self, &titleViewKey);
}

- (void)setTitleLab:(UILabel *)titleLab
{
    objc_setAssociatedObject(self, &titleViewKey, titleLab, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//设置NavigationBar的背景颜色
- (void)yf_setBackgroundColor:(UIColor *)backgroundColor
{
    
    if (!self.overlay) {
        
        [self setShadowImage:[UIImage new]];
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + STATUS_HEIGHT)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        self.overlay.backgroundColor = backgroundColor;
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
        
        UIView *lineView=[UIView new];
        [self.overlay addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.bottom.offset=-0.5;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor = HEX(@"E0E0E0", 1.0);
        self.lineView = lineView;
    }
    
    if (!self.titleLab) {
        [NoticeCenter addObserver:self selector:@selector(clearTitle) name:NaviClearTitle object:nil];
        self.titleLab =  [UILabel new];
        [[self.subviews firstObject] addSubview:self.titleLab];
        [[self.subviews firstObject] bringSubviewToFront:self.titleLab];
        
        self.titleLab.frame =  FRAME(WIDTH/2-(WIDTH - 44 *3 - 70)/2, STATUS_HEIGHT+44/2-15, WIDTH - 44 *3 - 70, 30);
        self.titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.font = FONT(17);
        self.titleLab.textColor = [UIColor whiteColor];
    }
    CGFloat alpha = CGColorGetAlpha(backgroundColor.CGColor);
    self.lineView.backgroundColor = HEX(@"E0E0E0", alpha);;
    self.overlay.backgroundColor = backgroundColor;
}

//设置NavigationBar的偏移量
- (void)yf_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

//改变NavigationBar所有控件的透明度
- (void)yf_setElementsAlpha:(CGFloat)alpha
{

    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
             obj.alpha = 0;
        }else{
            self.lineView.alpha = alpha;
            obj.alpha = alpha;
        }
    }];
}

-(UIColor *)yfBackgroundColor{
    return  self.overlay.backgroundColor;
}

-(void)yf_setTitle:(NSString *)title{
    self.titleLab.text = title;
}

-(void)yf_setTitleAlpha:(float)alpha{
    self.titleLab.alpha = alpha;
}
-(void)yf_setLineAlpha:(float)alpha;{
    self.lineView.alpha = alpha;
}
//移除之前对NavigationBar的操作
- (void)yf_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    self.titleLab = nil;
}

-(void)clearTitle{
    self.titleLab.text = @"";
    self.titleLab.alpha = 0.0;
    
}

-(void)yf_setCurrentNavBarVC:(JHBaseVC *)vc{
    [self setCurrentVC:vc];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (point.y < 20 && point.x > 100) {
        [NoticeCenter postNotificationName:ScrollToTop object:nil];
    }
    
    UIView *hitView;
    UIView *view;
    CGPoint pt;
    
//    NSLog(@"left  %ld  right  %ld",self.hitLeftViewArr.count,self.hitRightViewArr.count);
    
    hitView = self.currentVC.leftNavBtnView;
    if (hitView && point.x < WIDTH/2.0) {
        pt = [self convertPoint:point toView:hitView];
        view = [hitView hitTest:pt withEvent:event];
        if (view) {
            return view;
        }
    }
    
    hitView = self.currentVC.rightNavBtnView;
    if (hitView && point.x > WIDTH/2.0) {
        pt = [self convertPoint:point toView:hitView];
        view = [hitView hitTest:pt withEvent:event];
        if (view) {
            return view;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

//- (void)yf_setNavi_Y:(CGFloat)navi_y{
//    self.y = navi_y;
//    self.overlay.y = navi_y;
//}

-(void)dealloc{
    Remove_Notice
}

@end
