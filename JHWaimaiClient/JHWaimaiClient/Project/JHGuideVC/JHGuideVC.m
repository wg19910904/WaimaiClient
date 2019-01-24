//
//  JHGuideVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHGuideVC.h"
#import "AppDelegate.h"

@interface JHGuideVC ()
@end

@implementation JHGuideVC

-(void)setupWithImgs:(NSArray *)imgs{
    
    CGFloat h= HEIGHT + SYSTEM_GESTURE_HEIGHT;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:FRAME(0, 0, WIDTH, h)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(WIDTH * imgs.count, h);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    for (NSInteger i=0; i<imgs.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(WIDTH * i, 0, WIDTH, h)];
        [scrollView addSubview:imgView];
        imgView.image = IMAGE(imgs[i]);
        if (i == imgs.count -1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLastImgView)];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
        }
    }
}
#pragma mark ====== 点击最后一个图片 =======
-(void)tapLastImgView{
    [NoticeCenter postNotificationName:AppChangeRootVC object:nil];
}

@end
