//
//  JHLaunchADVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/14.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHLaunchADVC.h"
#import "YFBannerPlayer.h"
#import "NSString+Tool.h"
#import "JHADWebVC.h"
#import <UIImageView+WebCache.h>
#import "YFPageControl.h"

#define Img_Tag 100

@interface JHLaunchADVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,weak)UILabel *jumpLab;
@property(nonatomic,weak)YFPageControl *pageControl;
@end

@implementation JHLaunchADVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];

}

-(void)setUpView{
    
    NSArray *advs = [JHConfigurationTool shareJHConfigurationTool].launchAds;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in advs) {
        [arr addObject:dic[@"thumb"]];
    }
    CGFloat h= HEIGHT + SYSTEM_GESTURE_HEIGHT;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:FRAME(0, 0, WIDTH, h)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(WIDTH * arr.count, h);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    
    for (NSInteger i=0; i<arr.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(WIDTH * i, 0, WIDTH, h)];
        [scrollView addSubview:imgView];
        imgView.tag = Img_Tag + i ;
        NSURL *url = [NSURL URLWithString:ImageUrl(arr[i])];
        UIImage *img = [[SDImageCache sharedImageCache] imageFromCacheForKey:url.absoluteString];
        if (img) {
            imgView.image = img;
        }else{
            [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView:)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:tap];
    }
    
    UILabel *jumpLab = [UILabel new];
    [self.view addSubview:jumpLab];
    [jumpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-15;
        make.top.offset= 20 + 15;
        make.width.offset=80;
        make.height.offset=30;
    }];
    jumpLab.layer.cornerRadius=15;
    jumpLab.clipsToBounds=YES;
    jumpLab.backgroundColor = HEX(@"000000", 0.3);
    jumpLab.textColor = [UIColor whiteColor];
    jumpLab.font = FONT(14);
    jumpLab.textAlignment = NSTextAlignmentCenter;
    jumpLab.userInteractionEnabled = YES;
    self.jumpLab = jumpLab;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpDismiss)];
    [jumpLab addGestureRecognizer:tap];
    
    NSAttributedString *str = [NSString getAttributeString:@"5s" strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff6600", 1.0)}];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"跳过 ", @"JHLaunchADVC")];
    [attStr appendAttributedString:str];
    jumpLab.attributedText = attStr.copy;
    
    [self initTimer];

    if (arr.count > 1) {
        YFPageControl *pageControl = [[YFPageControl alloc]initWithFrame:CGRectMake(0, scrollView.frame.size.height-20, scrollView.frame.size.width, 8)];
        pageControl.currentPageIndicatorTintColor = HEX(@"ffffff", 1.0);
        pageControl.pageIndicatorTintColor = HEX(@"000000", 0.3);
        pageControl.dotWidth = 0;
        pageControl.dotHeight = 8;
        pageControl.currentPage = 0;
        pageControl.numberOfPages = arr.count;
        [self.view addSubview:pageControl];
        self.pageControl = pageControl;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.pageControl.currentPage = (int)scrollView.contentOffset.x / WIDTH;
}

//初始化一个定时器
-(void)initTimer{
    
    if (self.timer == nil) {
        
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0]
                                             interval:1.0
                                               target:self
                                             selector:@selector(timerActive)
                                             userInfo:nil
                                              repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }
}

#pragma mark ====== Functions =======
// 切换根视图
-(void)jumpDismiss{
    [self invalidateTime];
    [NoticeCenter postNotificationName:AppChangeRootVC object:nil];
}

-(void)invalidateTime{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)timerActive{
    static int time = 4;
    
    NSString *timeStr = [NSString stringWithFormat:@"%ds",time];
    NSAttributedString *str = [NSString getAttributeString:timeStr strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff6600", 1.0)}];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"跳过 ", @"JHLaunchADVC")];
    [attStr appendAttributedString:str];
    self.jumpLab.attributedText = attStr.copy;
    
    time--;
    if (time < 0) {
        [self invalidateTime];
        [self jumpDismiss];
    }
}

-(void)clickImgView:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - Img_Tag;
    NSArray *advs = [JHConfigurationTool shareJHConfigurationTool].launchAds;
    NSDictionary *dic = advs[index];
    NSString *link = dic[@"link"];
    if (link.length) {
        [self invalidateTime];
        JHADWebVC *adVC = [JHADWebVC new];
        adVC.titleStr = dic[@"title"];
        adVC.url = dic[@"link"];
        adVC.is_launch_ad = YES;
        [self.navigationController pushViewController:adVC animated:YES];
    }   
}

@end
