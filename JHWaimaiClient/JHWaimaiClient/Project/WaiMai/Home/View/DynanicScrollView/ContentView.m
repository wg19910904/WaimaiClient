//
//  ContentView.m
//  EleDemo
//
//  Created by ios_yangfei on 17/5/11.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import "ContentView.h"
#import "DynamicItem.h"
#import "YFSegmentedControl.h"
#import "YFScrollView.h"
#import <objc/runtime.h>
#import "JHShopDetailVC.h"
#import "JHShopEvaluateVC.h"

@interface ContentView ()<UIScrollViewDelegate,UIDynamicAnimatorDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,weak)YFSegmentedControl *segment;
@property(nonatomic,weak)YFScrollView *contentScr;
@property(nonatomic,assign)BOOL is_scroll;
@property(nonatomic,strong)NSMutableArray *viewArr;

/**
 *  用于模拟scrollView滚动
 */
@property (nonatomic, strong) UIDynamicAnimator  *animator;
@property (nonatomic, strong) UIDynamicItemBehavior *inertialBehavior;

@end

@implementation ContentView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)dealloc{
    Remove_Notice
}

-(void)configUI{
    
    [NoticeCenter addObserver:self selector:@selector(removeAllBehaviors) name:ScrollToTop object:nil];

    YFSegmentedControl *segment = [[YFSegmentedControl alloc] initWithFrame:FRAME(0, 0, WIDTH, 40) titleArr:@[@{@"title":NSLocalizedString(@"商品", nil)},@{@"title":NSLocalizedString(@"评价", @"ContentView")},@{@"title":NSLocalizedString(@"商家详情", @"ContentView")}]];
    [self addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=40;
    }];
    segment.indicatorWidth = WIDTH/3.0 * 0.5; 
    segment.textFont = FONT(16);
    segment.showIndicator = YES;
    segment.selectedColor = THEME_COLOR_Alpha(1.0);
    segment.backgroundColor = [UIColor whiteColor];
    segment.normalColor = HEX(@"333333", 1.0);
    [segment addTarget:self action:@selector(segementClick:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    self.segment = segment;
    
    UIView *lineView=[UIView new];
    [segment addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0.5;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    
    YFScrollView *contentScr = [YFScrollView new];
    [self addSubview:contentScr];
    [contentScr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=40;
        make.width.offset=WIDTH;
        make.height.mas_equalTo(self.mas_height).offset = -40;
    }];
    contentScr.contentSize = CGSizeMake(WIDTH * 3, 0);
    contentScr.pagingEnabled = YES;
    contentScr.delegate = self;
    contentScr.backgroundColor = BACK_COLOR;
    contentScr.showsHorizontalScrollIndicator = NO;
    self.contentScr = contentScr;
    
    // 添加拖动手势，处理滚动效果
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];

}

#pragma mark ====== Functions ======
-(void)addViewController:(UIView *)view index:(NSInteger)index{

    [self.contentScr addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=WIDTH * index;
        make.top.offset=0;
        make.width.offset=WIDTH;
        make.height.mas_equalTo(self.mas_height).offset = -40;
    }];
    [self.viewArr addObject:view];
    
}

-(void)segementClick:(UISegmentedControl *)segment{
    
    self.is_scroll = YES;
    // 控制器的时候移除当前tableView的滚动效果
    [self.animator removeAllBehaviors];
    [self.contentScr setContentOffset:CGPointMake(WIDTH * segment.selectedSegmentIndex, 0) animated:YES];
    
    UIViewController *vc = [self viewControllerForView:self.currentTableView];

    if ([vc isKindOfClass:[JHShopDetailVC class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [(JHShopDetailVC *)vc getData];
        });
    }

    if ([vc isKindOfClass:[JHShopEvaluateVC class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [(JHShopEvaluateVC *)vc getData];
        });
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.is_scroll) {// 点击segment导致的滚动不处理
//        self.shopVC.view.x = - scrollView.contentOffset.x;
        return;
    }
    CGFloat offsetpage = scrollView.contentOffset.x/[[UIScreen mainScreen] bounds].size.width;
    
    // 切换控制器
    self.segment.selectedSegmentIndex = offsetpage;

}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.is_scroll = NO;
}

#pragma mark ====== 滚动效果的处理 ======
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];

    // 点击超出self范围的不响应
    if (![view isKindOfClass:[UIView class]]) {
        return nil;
    }

    // 触屏屏幕的时候移除当前的动力学效果
    [self.animator removeAllBehaviors];
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeBehaviors)]) {
        [self.delegate removeBehaviors];
    }
    
    // 点击self范围内的响应
    return view;
}

-(void)removeAllBehaviors{
    [self.animator removeAllBehaviors];
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeBehaviors)]) {
        [self.delegate removeBehaviors];
    }
}

#pragma mark Pan手势处理
-(void)pan:(UIPanGestureRecognizer *)pan{
    
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(panGestureDealWith:)]) {
        [self.delegate panGestureDealWith:pan];
    }
    
}

#pragma mark 速度传递到tableview 上
-(void)setVelocity:(float)velocity{

    CGFloat f = self.currentTableView.contentSize.height - self.currentTableView.frame.size.height;
    if (f <= 0) {// tableview 不能滑动的处理
        return;
    }
    
    if (self.inertialBehavior != nil) {
        [self.animator removeBehavior:self.inertialBehavior];
    }
    
    DynamicItem *item = [[DynamicItem alloc] init];
    item.center = CGPointMake(0, 0);
    // velocity是在手势结束的时候获取的竖直方向的手势速度
    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ item ]];
    //velocity * 0.025 调整速度大小，速度传递的时候也需要处理下
    [inertialBehavior addLinearVelocity:CGPointMake(0, velocity * 0.025) forItem:item];
    // 通过尝试取2.0比较像系统的效果，阻力系数
    inertialBehavior.resistance = 2;
    
    __weak typeof(self)weakSelf = self;
   
    inertialBehavior.action = ^{
        // 每次的移动tableView的bounds会发生变化，所以maxoffset是会变化的每次需要重新计算，否则刷新存在问题
        CGFloat maxOffset = self.currentTableView.contentSize.height - self.currentTableView.bounds.size.height;
        CGPoint contentOffset = weakSelf.currentTableView.contentOffset;
        CGFloat speed = [weakSelf.inertialBehavior linearVelocityForItem:item].y;
        CGFloat offset = contentOffset.y -  speed;
        
        if (offset >= maxOffset && maxOffset > 0){// 上滑动了最底部了

            [weakSelf.animator removeAllBehaviors];
            weakSelf.inertialBehavior = nil;
            
            CGFloat height = 0.0;
            if (self.segment.selectedSegmentIndex == 1) {
                height = 45;
            }
            
            [UIView animateWithDuration:0.15 animations:^{
                weakSelf.currentTableView.contentOffset = CGPointMake(contentOffset.x, offset);
            } completion:^(BOOL finished) {
                [weakSelf.currentTableView setContentOffset:CGPointMake(contentOffset.x, maxOffset + height) animated:YES];
            }];

        }else{
            
            offset = offset <= 0 ? 0 : offset;
            weakSelf.currentTableView.contentOffset = CGPointMake(contentOffset.x, offset);
            if (offset == 0) {
                // tableView的偏移量为零的时候，速度反向传递
                [weakSelf.animator removeBehavior:weakSelf.inertialBehavior];
                weakSelf.inertialBehavior = nil;
                if (self.delegate && [self.delegate respondsToSelector:@selector(velocityOfTableViewWhenTableIsTop:)]) {
                    [self.delegate velocityOfTableViewWhenTableIsTop:speed];
                }
            }
        }
        
    };
    self.inertialBehavior = inertialBehavior;
    [self.animator addBehavior:inertialBehavior];
    
}

#pragma mark ====== 获取当前的tableView =======
-(UITableView *)currentTableView{
    if (_currentTableView) {
        return _currentTableView;
    }else{
        if (self.viewArr.count == 0) {
            return nil;
        }
        UIViewController *vc = [self viewControllerForView:self.viewArr[self.segment.selectedSegmentIndex]];
        
        return (UITableView *)[vc valueForKeyPath:@"tableView"];
    }
}

- (UIViewController *)viewControllerForView:(UIView *)view {
    for (UIView* next = view; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(int)currentIndex{
    return (int)self.segment.selectedSegmentIndex;
}

#pragma mark - 懒加载
- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] init];
        _animator.delegate = self;
    }
    return _animator;
}

-(NSMutableArray *)viewArr{
    if (_viewArr==nil) {
        _viewArr=[[NSMutableArray alloc] init];
    }
    return _viewArr;
}

@end
