//
//  JHHomaDanmuView.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/9/3.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeDanmuView.h"
#import "UIView+Extension.h"

@implementation JHHomeDanmuView
{
    UIControl *bgV;
    UIImageView *imgV;
    UILabel *infoL;
    NSMutableArray *ordersArr;
}
- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)superV{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.0;
        ordersArr = @[].mutableCopy;
        [self setupUI];
        [superV addSubview:self];

        //设置阴影
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.9;
        self.layer.shadowRadius = 4;
    }
    return self;
}

//布局
- (void)setupUI{
    bgV = [UIControl new];
    [self addSubview:bgV];
    bgV.layer.cornerRadius = 4;
    bgV.clipsToBounds = YES;
    [bgV addTarget:self action:@selector(clickDanmu) forControlEvents:(UIControlEventTouchUpInside)];
    imgV = [UIImageView new];
    [bgV addSubview:imgV];
    imgV.frame = FRAME(0, 0, 32, 32);
    
    infoL = [UILabel new];
    [bgV addSubview:infoL];
    infoL.frame = FRAME(32, 0, 166, 32);
    infoL.backgroundColor = HEX(@"000000", 0.5);
    infoL.font = FONT(12);
    infoL.textColor  = HEX(@"ffffff", 1.0);
    infoL.adjustsFontSizeToFitWidth = YES;
    
    //
    [self updateDanmu];
}

- (void)getOrders{
    __weak typeof(self)ws = self;
    [HttpTool postWithAPI:@"client/waimai/index/getOrders"
               withParams:@{}
                  success:^(id json) {
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [ordersArr addObjectsFromArray:json[@"data"][@"items"]];
                      }
                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          [ws getOrders];
                      });
                      
                  } failure:^(NSError *error) {
                      
                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          [ws getOrders];
                      });
                      
                  }];
}

- (void)updateDanmu{
    self.hidden = (ordersArr.count == 0);
    if (self.hidden == NO) {
        NSDictionary *curentDic = (NSDictionary *)ordersArr[0];
        //logo
        NSString *logo = curentDic[@"shop"][@"logo"];
        [imgV sd_setImageWithURL:[NSURL URLWithString:logo]];
        //info
        NSString *nickname = curentDic[@"member"][@"nickname"];
        NSString *dateLine = curentDic[@"dateline"];
        NSUInteger time = [self timeInterval:dateLine];
        NSString *time_str;
        if (time >= 3600) {
            time_str = NSLocalizedString(@"1小时", nil);
        }else if(time > 60){
            time_str = [NSString stringWithFormat:@"%ld分钟", (unsigned long)time / 60];
        }else{
            time_str = [NSString stringWithFormat:@"%ld秒", (unsigned long)time];
        }
        NSString *infoText = [NSString stringWithFormat:NSLocalizedString(@"  %@%@前下了单 › ", nil),nickname,time_str];
        infoL.text = infoText;
        CGFloat widthS = getSize(infoText, 32, 12).width;
        infoL.width = widthS;
        widthS += 32;
        self.width = widthS;
        bgV.frame = self.bounds;
        [self showAnimation];
        //4s之后隐藏的动画
        [self hideAnimation];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateDanmu];
        });
    }
}

- (NSUInteger)timeInterval:(NSString *)unux_time{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];
    return time - unux_time.integerValue;
}
- (void)showAnimation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1.0;
        }];
    });
}

- (void)hideAnimation{
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (ordersArr.count) {
                [ordersArr removeObjectAtIndex:0];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updateDanmu];
            });
        }];
    });
}
- (void)clickDanmu{
   // http://wmdemo.jhcms.cn/waimai/shop/detail-802.html
    if (ordersArr.count) {
        NSDictionary *danmuDic = (NSDictionary *)ordersArr[0];
        NSDictionary *shopDic = danmuDic[@"shop"];
        NSString *shop_id = shopDic[@"shop_id"];
        NSString *postStr = [NSString stringWithFormat:@"http://%@/waimai/shop/detail-%@.html",KReplace_Url,shop_id];
        [NoticeCenter postNotificationName:KNotification_Home_newLink object:postStr];
    }
    
}

@end
