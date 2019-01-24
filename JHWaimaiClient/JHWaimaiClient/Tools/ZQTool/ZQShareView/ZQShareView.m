//
//  ZQShareView.m
//  PopUpView
//
//  Created by 洪志强 on 17/5/2.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "ZQShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "UIImage+Extension.h"

#define CURRENT_W [UIScreen mainScreen].bounds.size.width
#define CURRENT_H [UIScreen mainScreen].bounds.size.height
#define CURRENT_SCALE CURRENT_W/375
@interface ZQShareView()<CAAnimationDelegate>
@property(nonatomic,strong)UIView *bottomView;//底部的view
@property(nonatomic,strong)NSMutableArray *imageArr;
@end
@implementation ZQShareView
-(instancetype)init{
    self =  [[ZQShareView alloc]initWithFrame:CGRectMake(0, 0, CURRENT_W,CURRENT_H)];
    if (self) {
        [self config];
    }
    return self;
}
-(void)config{
    [self addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
    self.imageArr = @[].mutableCopy;
    [self bottomView];
 }
-(void)clickToRemove{
    for (int i = 3; i >= 0; i--) {
        UIView *view = _imageArr[i];
        [self popDownAnimation:view];

    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
    
}
#pragma mark - 创建底部的按钮
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.frame = CGRectMake(0, CURRENT_H - 200*CURRENT_SCALE - SYSTEM_GESTURE_HEIGHT, CURRENT_W, 200*CURRENT_SCALE + SYSTEM_GESTURE_HEIGHT);
        _bottomView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _bottomView.alpha = 0;
        [self addSubview:_bottomView];
        
        //取消的按钮
        UIButton *cancelBtn = [[UIButton alloc]init];
        [cancelBtn setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 156*CURRENT_SCALE - SYSTEM_GESTURE_HEIGHT, CURRENT_W, 44*CURRENT_SCALE);
        cancelBtn.alpha = 0;
        cancelBtn.backgroundColor = [UIColor whiteColor];
        //cancelBtn.layer.cornerRadius = 15;
        //cancelBtn.layer.masksToBounds = YES;
        //cancelBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        //cancelBtn.layer.borderWidth = 1;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancelBtn];
        [UIView animateWithDuration:0.25 animations:^{
            _bottomView.alpha = 1;
             cancelBtn.alpha = 1;
        }];

        //点击分享的按钮
        [self creatShareBtn];
    }
    return _bottomView;
}
#pragma mark - 创建四个按钮
-(void)creatShareBtn{
    CGFloat w = (CURRENT_W - 60*CURRENT_SCALE*4)/5;
    NSArray *titleArr = @[NSLocalizedString(@"微信", nil),@"QQ",NSLocalizedString(@"朋友圈", nil),NSLocalizedString(@"QQ空间", nil)];
    for (int i = 0; i < 4; i++) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(w+(w +60*CURRENT_SCALE)*i, 200*CURRENT_SCALE - SYSTEM_GESTURE_HEIGHT, 60*CURRENT_SCALE, 90*CURRENT_SCALE);
        view.userInteractionEnabled = YES;
        view.tag = i;
        [_bottomView addSubview:view];
        
        //添加显示对应的分享位置的
        UILabel *titleL = [[UILabel alloc]init];
        titleL.frame = CGRectMake(0, 70*CURRENT_SCALE, 60*CURRENT_SCALE, 20*CURRENT_SCALE);
        titleL.font = [UIFont systemFontOfSize:14*CURRENT_SCALE];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        titleL.text = titleArr[i];
        [view addSubview:titleL];
        
        //添加图片显示
        UIImageView  *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(0,0, 60*CURRENT_SCALE, 60*CURRENT_SCALE);
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        imageV.userInteractionEnabled = YES;
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"my_share0%d",i+1]];
        imageV.tag = i;
        [view addSubview:imageV];
        [self.imageArr addObject:view];
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickShareView:)];
        [imageV addGestureRecognizer:tap];
    }
}
#pragma mark - 点击分享的按钮的响应事件
-(void)clickShareView:(UITapGestureRecognizer *)tap{
    if (!_shareUrl) {
         [self clickToRemove];
        return;
    }
    NSInteger index = tap.view.tag;
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = nil;
    
    if (self.isUrlImg) {
        if (![self.shareImgName hasPrefix:@"http"]) {
            self.shareImgName = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.shareImgName];
        }
        shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareStr thumImage:self.shareImgName];
    } else {
        shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareStr thumImage:IMAGE(self.shareImgName)];
    }
    shareObject.webpageUrl = self.shareUrl;
    
    messageObject.shareObject = shareObject;
   
    switch (index) {
        case 0:{
            [self shareToPlatform:UMSocialPlatformType_WechatSession data:messageObject];
        }
            break;
        case 1:{
            [self shareToPlatform:UMSocialPlatformType_QQ data:messageObject];
        }
            break;
        case 2:{
            [self shareToPlatform:UMSocialPlatformType_WechatTimeLine data:messageObject];
        }
            break;
        case 3:{
            [self shareToPlatform:UMSocialPlatformType_Qzone data:messageObject];
        }
            break;
        default:
            break;
    }
    [self clickToRemove];
}
-(void)shareToPlatform:(UMSocialPlatformType)platformType data:(UMSocialMessageObject *)messageObject{
    
    if (self.is_miniProgrammar && platformType == UMSocialPlatformType_WechatSession) {
        WXMiniProgramObject *wxMiniObject = [WXMiniProgramObject object];
        wxMiniObject.webpageUrl = self.shareUrl;// 兼容低版本的网页链接
        wxMiniObject.userName = self.userName;// 小程序的原始id
        wxMiniObject.path= self.pagePath;// 小程序的页面路径
        
        self.mini_shareImg = [self convertViewToImage:self.superVC.view];
        
        NSData *data = UIImageJPEGRepresentation(self.mini_shareImg, 1.0);
        NSString *str = [NSByteCountFormatter stringFromByteCount:data.length countStyle:NSByteCountFormatterCountStyleFile];
        CGFloat scale = [str intValue] > 128 ? ([str intValue] * 1.0 /128) : 1 ;
        scale = scale >= 1 ? (1/scale) : scale;
        wxMiniObject.hdImageData= UIImageJPEGRepresentation(self.mini_shareImg, scale);//data.shareImage;// 小程序节点高清大图，小于128k
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.shareTitle;// title
        message.description = self.shareStr;// description
        message.mediaObject = wxMiniObject;
        message.thumbData = nil;// 兼容旧版本的节点图片，小于32k，新版本优先
        //使用WXMiniProgramObject的hdImageData属性
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.scene = WXSceneSession;// 目前只支持会话
        [WXApi sendReq:req];
    }else{
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                YF_SAFE_BLOCK(self.shareResultBlock,NO,@"");
                [self.superVC showToastAlertMessageWithTitle:NSLocalizedString(@"分享失败",nil)];
            }else{
                YF_SAFE_BLOCK(self.shareResultBlock,YES,@"");
                [self.superVC showToastAlertMessageWithTitle:NSLocalizedString(@"分享成功",nil)];
            }
        }];
    }
    
}
/**
 展示的动画
 */
-(void)showAnimation{
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.alpha = 0;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    for (UIView *view in _imageArr) {
        [self popUpAniamtion:view];
    }
    
}
#pragma makr - 弹出的动画
-(void)popUpAniamtion:(UIView *)imageView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((imageView.tag*0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CASpringAnimation *springAniamtion = [CASpringAnimation animationWithKeyPath:@"position.y"];
        if (@available(iOS 9.0,*)) {
            springAniamtion.duration = springAniamtion.settlingDuration;
            springAniamtion.initialVelocity = 10;//初始速率,正,与运动方向相同,负的则相反
        }else{
            springAniamtion.duration = 0.25;
        }
        springAniamtion.damping = 15;//阻尼系数,阻尼系数越大,停止越快
        springAniamtion.stiffness = 100;//刚度系数,刚度系数越大,形变产生的力就越大,运动越快
        springAniamtion.mass = 1;//质量.越大,幅度越大
        springAniamtion.delegate = self;
        springAniamtion.fromValue = @(imageView.layer.position.y);
        springAniamtion.toValue = @(imageView.layer.position.y-160);
        springAniamtion.removedOnCompletion = NO;
        springAniamtion.fillMode = kCAFillModeForwards;
        imageView.center = CGPointMake(imageView.center.x,85*CURRENT_SCALE);
        [imageView.layer addAnimation:springAniamtion forKey:nil];
    });
}
#pragma mark - 掉下的动画
-(void)popDownAnimation:(UIView *)imageView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((-imageView.tag+3)*0.05) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CASpringAnimation *springAniamtion = [CASpringAnimation animationWithKeyPath:@"position.y"];
        springAniamtion.duration = 0.25;
        springAniamtion.damping = 15;
        springAniamtion.stiffness = 100;
        springAniamtion.mass = 1;
        springAniamtion.delegate = self;
        if (@available(iOS 9.0,*)) {
            springAniamtion.initialVelocity = 10;//初始速率,正,与运动方向相同,负的则相反
        }
        springAniamtion.fromValue = @(imageView.layer.position.y);
        springAniamtion.toValue = @(imageView.layer.position.y+160);
        springAniamtion.removedOnCompletion = NO;
        springAniamtion.fillMode = kCAFillModeForwards;
        [springAniamtion setValue:[@"animationDown" stringByAppendingString:@(imageView.tag).stringValue] forKey:[@"animationDown" stringByAppendingString:@(imageView.tag).stringValue]];
        [imageView.layer addAnimation:springAniamtion forKey:nil];
        imageView.center = CGPointMake(imageView.center.x,245*CURRENT_SCALE);
  });
}

// 小程序分享的图片处理
- (UIImage *)convertViewToImage:(UIView *)view
{
    // 第二个参数表示是否非透明。如果需要显示半透明效果，需传NO，否则YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(WIDTH, HEIGHT),NO,[UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [self scaleToSize:CGSizeMake(WIDTH/1.5, HEIGHT/1.5) img:image];
}

-(UIImage*)scaleToSize:(CGSize)size img:(UIImage *)img{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
   
    return scaledImage;
}

@end
