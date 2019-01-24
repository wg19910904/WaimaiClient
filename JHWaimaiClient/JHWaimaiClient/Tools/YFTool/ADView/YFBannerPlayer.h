//
//  YFBannerPlayer.h
//  PresentAnimationTest
//
//  Created by ios_yangfei on 17/4/18.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickAD)(NSInteger index);

@interface YFBannerPlayer : UIView

@property (strong, nonatomic) NSArray *urlArray;
@property(nonatomic,copy)NSString *placeHolderImage;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,copy)ClickAD clickAD;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,assign)BOOL pageIndexHidden;
@property(nonatomic,assign)BOOL is_radius_dot;// 是不是小圆点
@property(nonatomic,strong)UIColor *dotColor;// pageIndex的颜色
@property(nonatomic,assign)float pageMarginBottom;// pageIndex距离底部的距离



//初始化一个本地图片播放器
+ (YFBannerPlayer *)initWithSourceArray:(NSArray *)picArray
                                withFrame:(CGRect)frame
                        withTimeInterval:(CGFloat)interval;


//初始化一个网络图片播放器
+ (YFBannerPlayer *)initWithUrlArray:(NSArray *)urlArray
                             withFrame:(CGRect)frame
                     withTimeInterval:(CGFloat)interval;

-(void)initTimer;

-(void)invalidateTimer;

@end
