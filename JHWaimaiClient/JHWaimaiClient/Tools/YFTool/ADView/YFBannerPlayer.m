//
//  YFBannerPlayer.m
//  PresentAnimationTest
//
//  Created by ios_yangfei on 17/4/18.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import "YFBannerPlayer.h"
#import "YFPageControl.h"
#import <UIImageView+WebCache.h>

@interface YFBannerPlayer ()<UIScrollViewDelegate>
@property (nonatomic,assign) CGFloat timeInterval;
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,assign) CGRect currentRect;
@property(nonatomic,strong)YFPageControl *pageControl;
@property (nonatomic, weak)  UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *sourceArray;
@property(nonatomic,assign)BOOL is_url;

@end

@implementation YFBannerPlayer


//便利构造器
+ (YFBannerPlayer *)initWithSourceArray:(NSArray *)picArray
                                withFrame:(CGRect)frame
                        withTimeInterval:(CGFloat)interval{
    
    YFBannerPlayer *bannerPlayer = [[YFBannerPlayer alloc]initWithFrame:frame];
    bannerPlayer.currentRect = frame;
    bannerPlayer.sourceArray = picArray;
    bannerPlayer.timeInterval = interval;
    bannerPlayer.is_url = NO;
    if (interval != 0) {
        [bannerPlayer initTimer];
    }
    [bannerPlayer resetImages];
    return bannerPlayer;
    
}

+ (YFBannerPlayer *)initWithUrlArray:(NSArray *)urlArray
                             withFrame:(CGRect)frame
                     withTimeInterval:(CGFloat)interval{
    
    YFBannerPlayer *bannerPlayer = [[YFBannerPlayer alloc]initWithFrame:frame];
    bannerPlayer.currentRect = frame;
    bannerPlayer.timeInterval = interval;
    bannerPlayer.urlArray = urlArray;
    bannerPlayer.is_url = YES;
    if (interval != 0 && urlArray.count > 1) {
        [bannerPlayer initTimer];
    }
    [bannerPlayer resetImages];
    return bannerPlayer;
}

#pragma mark ======InitView=======

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.currentRect = frame;
        [self initScrollView];
        [self initImageView];
        [self initPageControl];
    }
    return self;
}

//初始化主滑动视图
-(void)initScrollView{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.currentRect.size.width, self.currentRect.size.height)];
    
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.currentRect.size.width * 3, self.currentRect.size.height);
    scrollView.delegate = self;
    [scrollView setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
    
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

//初始化imageview
-(void)initImageView{
    
    CGFloat width = 0;
    
    for (int a = 0; a < 3; a++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width, 0, self.currentRect.size.width, self.currentRect.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.tag = a + 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgActive)];
        [imageView addGestureRecognizer:tap];
        [self.scrollView addSubview:imageView];
        width += self.currentRect.size.width;
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }
    
}

//初始化一个定时器
-(void)initTimer{
    
    if (self.timer == nil) {
        
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]
                                             interval:self.timeInterval
                                               target:self
                                             selector:@selector(timerActive)
                                             userInfo:nil
                                              repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }
}

-(void)initPageControl{
 
    YFPageControl *pageControl = [[YFPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-8, self.frame.size.width, 8)];
    pageControl.currentPageIndicatorTintColor = HEX(@"FF9900", 1.0);
    pageControl.pageIndicatorTintColor = HEX(@"000000", 0.3);
    pageControl.dotWidth = 18;
    pageControl.dotHeight = 4;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

#pragma mark ======Functions=======
//点击图片的回调
-(void)imgActive{
    if (self.urlArray.count == 0) {
        return;
    }
    if (self.clickAD) {
        self.clickAD(self.index);
    }
}

//定时器事件
-(void)timerActive{

//    CGFloat width = self.scrollView.contentOffset.x + self.currentRect.size.width;
//    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
    [self.self.scrollView scrollRectToVisible:CGRectMake(self.currentRect.size.width * 2, 0, self.currentRect.size.width, self.currentRect.size.height) animated:YES];
    
}

//触摸后停止定时器
- (void)scrollViewWillBeginDragging:( UIScrollView *)scrollView{
    
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//触摸停止后再次启动定时器
- (void)scrollViewDidEndDragging:( UIScrollView *)scrollView willDecelerate:( BOOL )decelerate{
    if (self.timeInterval == 0) {
        return;
    }
    [self initTimer];
}

#pragma mark ======滚动处理=======
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
    
        if (scrollView.contentOffset.x == 0) {
            if (self.index == 0) {
                self.index = self.sourceArray.count - 1;
            }else{
                self.index--;
            }
            [scrollView setContentOffset:CGPointMake(self.currentRect.size.width , 0) animated:NO];
            
        }else if(scrollView.contentOffset.x == self.currentRect.size.width *2){
            
            if (self.index == self.sourceArray.count - 1 ) {
                self.index = 0;
            }else{
                self.index++;
            }
            [scrollView setContentOffset:CGPointMake(self.currentRect.size.width , 0) animated:NO];
        }
        
        [self resetImages];
        
    }

}

// 重新分配图片
-(void)resetImages{
    
    UIImageView *indexViewOne = (UIImageView *)[self.scrollView viewWithTag:1];
    UIImageView *indexViewTwo = (UIImageView *)[self.scrollView viewWithTag:2];
    UIImageView *indexViewThree = (UIImageView *)[self.scrollView viewWithTag:3];
    
    // 一张图片
//    NSLog(@" ============ %@  %ld",self.sourceArray,self.index);
    if (self.sourceArray.count == 1) {
        if (self.is_url) {
//            NSLog(@"图片  ====== %@",self.sourceArray[self.index]);
            NSURL *url1 = [NSURL URLWithString:self.sourceArray[0]];
            UIImage *img1 = [[SDImageCache sharedImageCache] imageFromCacheForKey:url1.absoluteString];
            if (img1) {
                indexViewOne.image = img1;
                indexViewTwo.image = img1;
                indexViewThree.image = img1;
            }else{
                [indexViewOne sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
                [indexViewTwo sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
                [indexViewThree sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
            }
           
        }else{
            
            indexViewOne.image = [UIImage imageNamed:self.sourceArray[self.index]];
            indexViewTwo.image = [UIImage imageNamed:self.sourceArray[self.index]];
            indexViewThree.image = [UIImage imageNamed:self.sourceArray[self.index]];
        }
        return;
    }
    
    // 多张图片
    self.pageControl.currentPage = self.index;
    
    if (self.is_url) { // 网络图片
        NSURL *url1;
        NSURL *url2;
        NSURL *url3;
        if (self.index == 0) {
            url1 = [NSURL URLWithString:self.sourceArray.lastObject];
            url2 = [NSURL URLWithString:self.sourceArray[self.index]];
            url3 = [NSURL URLWithString:self.sourceArray[self.index+1]];

        }else if(self.index == self.sourceArray.count-1){
            
            url1 = [NSURL URLWithString:self.sourceArray[self.index-1]];
            url2 = [NSURL URLWithString:self.sourceArray[self.index]];
            url3 = [NSURL URLWithString:self.sourceArray[0]];
            
        }else{
            
            url1 = [NSURL URLWithString:self.sourceArray[self.index-1]];
            url2 = [NSURL URLWithString:self.sourceArray[self.index]];
            url3 = [NSURL URLWithString:self.sourceArray[self.index+1]];
        }

        [indexViewOne sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
        [indexViewTwo sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
        [indexViewThree sd_setImageWithURL:url3 placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
        
    }else{ // 本地图片
        
        if (self.index == 0) {
            indexViewOne.image = [UIImage imageNamed:[self.sourceArray lastObject]];
            indexViewTwo.image = [UIImage imageNamed:self.sourceArray[self.index]];
            indexViewThree.image = [UIImage imageNamed:self.sourceArray[self.index+1]];
        }else if(self.index == self.sourceArray.count-1){
            indexViewOne.image = [UIImage imageNamed:self.sourceArray[self.index-1]];
            indexViewTwo.image = [UIImage imageNamed:self.sourceArray[self.index]];
            indexViewThree.image = [UIImage imageNamed:self.sourceArray[0]];
        }else{
            indexViewOne.image = [UIImage imageNamed:self.sourceArray[self.index-1]];
            indexViewTwo.image = [UIImage imageNamed:self.sourceArray[self.index]];
            indexViewThree.image = [UIImage imageNamed:self.sourceArray[self.index+1]];
        }
    }

}

-(void)setIs_radius_dot:(BOOL)is_radius_dot{
    _is_radius_dot = is_radius_dot;
    self.pageControl.dotWidth = 0;
    self.pageControl.dotHeight = 8;
}

-(void)setPageMarginBottom:(float)pageMarginBottom{
    _pageMarginBottom = pageMarginBottom;
    self.pageControl.y = self.currentRect.size.height - pageMarginBottom - self.pageControl.dotHeight;
}

-(void)setDotColor:(UIColor *)dotColor{
    _dotColor = dotColor;
    self.pageControl.currentPageIndicatorTintColor = dotColor;
}

-(void)setPageIndexHidden:(BOOL)pageIndexHidden{
    _pageIndexHidden = pageIndexHidden;
    self.pageControl.hidden = pageIndexHidden;
}

-(void)setPlaceHolderImage:(NSString *)placeHolderImage{
    _placeHolderImage = placeHolderImage;
    [self resetImages];
}

-(void)setSourceArray:(NSArray *)sourceArray{
    _sourceArray = sourceArray;
    
    self.scrollView.scrollEnabled = sourceArray.count == 1 ? NO : YES;
    self.pageControl.numberOfPages = _sourceArray.count;
    self.pageControl.currentPage = 0;
    
}

-(void)setUrlArray:(NSArray *)urlArray{
    _urlArray = urlArray;
    self.is_url = YES;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *str in urlArray) {
        if ([str hasPrefix:@"http"]) {
            [arr addObject:str];
        }else{
            [arr addObject:ImageUrl(str)];
        }
    }
    arr.count != 0 ? ({self.sourceArray = arr.copy;}):({self.sourceArray=@[@""];});
    self.index = 0;
    [self resetImages];
}

-(void)dealloc{
    [self invalidateTimer];
}

-(void)invalidateTimer{
    [self.timer invalidate];
    _timer = nil;
}

-(NSInteger)currentIndex{
    return self.index;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    self.index = currentIndex;
    [self.scrollView scrollRectToVisible:CGRectMake(self.currentRect.size.width, 0, self.currentRect.size.width, self.currentRect.size.height) animated:YES];
    [self resetImages];
}
@end
