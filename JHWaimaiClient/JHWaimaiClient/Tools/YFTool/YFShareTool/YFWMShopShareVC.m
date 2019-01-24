//
//  YFWMShopShareVC.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/21.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFWMShopShareVC.h"
#import "PresentAnimationTransition.h"
#import "YFTypeBtn.h"
#import "UIImage+Extension.h"
#import "YFShareTool.h"
#import "YFCollectionViewAutoFlowLayout.h"
#import "SearchCollectionViewCell.h"
#import <Photos/Photos.h>

@interface YFWMShopShareVC ()<UIViewControllerTransitioningDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewAutoFlowLayoutDelegate>
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UIView *bottomView;
@end

@implementation YFWMShopShareVC


-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        
    } error:nil];
    
}

-(void)setUpView{

    [self setUpBottomView];
    
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(self.bottomView.mas_top).offset(20);
        make.width.offset(SCALE * 300);
        make.height.offset(SCALE * 420);
    }];
    backView.backgroundColor = [UIColor whiteColor];
    self.backView = backView;
    
    UIImageView *backImgView = [UIImageView new];
    [backView addSubview:backImgView];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    backImgView.contentMode = UIViewContentModeScaleAspectFill;
    backImgView.clipsToBounds = YES;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = FRAME(0, 0, SCALE * 300, SCALE * 420);
    [backImgView addSubview:effectView];
    
    UIImageView *whiteBackImgView = [UIImageView new];
    [backImgView addSubview:whiteBackImgView];
    [whiteBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-20);
        make.height.offset(SCALE * 300);
    }];
    whiteBackImgView.contentMode = UIViewContentModeScaleAspectFill;
    whiteBackImgView.image = IMAGE(@"bg_shopshare");
    
    UIImageView *iconImgView = [UIImageView new];
    [backView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(SCALE * 60);
        make.width.height.offset(SCALE * 140);
    }];
    iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    [iconImgView addViewRadius:SCALE * 70];
    [iconImgView addViewBorder:[UIColor whiteColor] borderWidth:5];
    
    UIView *shopInfoView = [UIView new];
    [backView addSubview:shopInfoView];
    [shopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(170 * SCALE);
    }];
    shopInfoView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [UILabel new];
    [shopInfoView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(0);
        make.right.offset(-90);
    }];
    titleLab.font = FONT(18);
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.numberOfLines = 2;
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UILabel *qiSongLab = [UILabel new];
    [shopInfoView addSubview:qiSongLab];
    [qiSongLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.right.offset(-90);
    }];
    qiSongLab.font = FONT(12);
    qiSongLab.textColor = HEX(@"999999", 1.0);
    
    UILabel *peiSongLab = [UILabel new];
    [shopInfoView addSubview:peiSongLab];
    [peiSongLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(qiSongLab.mas_bottom).offset(5);
        make.right.offset(-90);
    }];
    peiSongLab.font = FONT(12);
    peiSongLab.textColor = HEX(@"999999", 1.0);
    
    UIImageView *erCodeImgView = [UIImageView new];
    [shopInfoView addSubview:erCodeImgView];
    [erCodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(0);
        make.width.height.offset(70);
    }];

    YFCollectionViewAutoFlowLayout * flowLayout=[[YFCollectionViewAutoFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.delegate = self;
    flowLayout.interSpace = 4;
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"YFCollectionViewAutoFlowLayoutCell"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
    collectionView.clipsToBounds = YES;
    [backView addSubview:collectionView];
    self.collectionView =collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(6);
        make.right.offset(-10);
        make.bottom.offset=-10;
        make.height.offset(50);
    }];

    [iconImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(self.shop.logo)] placeholderImage:IMAGE(@"logo_shop60_default")];
    titleLab.text = self.shop.title;
    qiSongLab.text = [NSString stringWithFormat: NSLocalizedString(@"起送￥%@   %@分钟送达", NSStringFromClass([self class])),self.shop.min_amount,self.shop.pei_time];
    
    if ([self.shop.freight floatValue] == 0) {
        peiSongLab.text =  NSLocalizedString(@"免配送费", NSStringFromClass([self class]));
    }else{
        if (self.shop.is_reduce_pei) {
            peiSongLab.text = [NSString stringWithFormat: NSLocalizedString(@"配送￥%@起", NSStringFromClass([self class])),self.shop.reduceEd_freight];
        }else{
            peiSongLab.text = [NSString stringWithFormat: NSLocalizedString(@"配送￥%@起", NSStringFromClass([self class])),self.shop.freight];
        }
   }
    
    erCodeImgView.image = [UIImage createCoreImage:self.shop.share_url centerImg:nil];

    UIImage *img = [[[SDWebImageManager sharedManager] imageCache]imageFromCacheForKey:ImageUrl(self.shop.logo)];
    backImgView.image = [self clipPictureWithImg:img];

    [backView layoutIfNeeded];
    [backImgView addViewRadius:8];
    [shopInfoView addViewRadius:8];
    [backView addViewShadow:HEX(@"000000", 0.8) shadowOffset:CGSizeMake(0, 3) radius:8];
    
}

-(void)setUpBottomView{

    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(SCALE * 190);
    }];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    
    UIButton *closeBtn = [UIButton new];
    [bottomView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(45);
    }];
    closeBtn.backgroundColor = HEX(@"D8D8D8", 1.0);
    closeBtn.titleLabel.font = FONT(14);
    [closeBtn setTitle: NSLocalizedString(@"关闭", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [closeBtn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arr = @[@{@"title":@"微信",@"img":@"share_weixin"},
                     @{@"title":@"朋友圈",@"img":@"share_pengyouquan"},
                     @{@"title":@"QQ",@"img":@"share_qq"},
                     @{@"title":@"空间",@"img":@"share_qqzone"},
                     @{@"title":@"保存",@"img":@"share_xiazai"}];
    
    CGFloat margin = 20 * SCALE;
    CGFloat btn_w = (WIDTH - 6 * margin) * 0.2;
    UIView *beforeView = nil;
    for (NSInteger i=0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        YFTypeBtn *btn = [YFTypeBtn new];
        [bottomView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            beforeView ? make.left.equalTo(beforeView.mas_right).offset(margin) : make.left.offset(margin);
            make.height.offset(60);
            make.width.offset(btn_w);
            make.bottom.equalTo(closeBtn.mas_top).offset(-10);
        }];
        btn.btnType = TopImage;
        btn.titleMargin = 5;
        btn.titleAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = FONT(12);
        [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        [btn setImage:IMAGE(dic[@"img"]) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        beforeView = btn;
    }
    
}

// 裁剪图片
-(UIImage *)clipPictureWithImg:(UIImage *)img{
    CGImageRef cgRef = img.CGImage;
    CGFloat imgW = img.size.width;
    CGFloat imgH = img.size.height;
    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake((imgW-40)/2.0,(imgH-40)/2.0,40,40));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shop.huodongMark.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFCollectionViewAutoFlowLayoutCell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.shop.huodongMark[indexPath.item];
    cell.titleLab.layer.borderColor=HEX(@"999999", 0.5).CGColor;
    cell.titleLab.layer.borderWidth=0.5;
    cell.titleLab.layer.cornerRadius=2;
    cell.titleLab.clipsToBounds=YES;
    cell.titleLab.backgroundColor = [UIColor whiteColor];
    cell.titleLab.textColor = HEX(dic[@"color"], 1.0);
    cell.titleLab.text = dic[@"title"];
    cell.titleLab.font = FONT(11);
    return cell;
}

#pragma mark ====== YFCollectionViewAutoFlowLayoutDelegate =======
-(CGSize)collectionViewItemSizeForIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.shop.huodongMark[indexPath.item];
    NSString *str = dic[@"title"];
    CGSize size = getSize(str, 18, 11);
    return CGSizeMake(size.width+15, 18);
}

-(CGSize)collectionViewSectionHeadSizeForSection:(NSInteger)section{
    return CGSizeZero;
}

#pragma mark ====== Functions =======
-(void)setShop:(WMShopModel *)shop{
    _shop = shop;
    [self setUpView];
}

// 点击分享
-(void)clickShare:(UIButton *)btn{
    
    NSMutableDictionary *dic =  @{
                           @"shareUrl":self.shop.share_url,
                           @"shareTitle":self.shop.title,
                           @"shareStr":NSLocalizedString(@"这家店还不错,外卖可以叫他们家的外卖哦!",nil),
                           @"urlImg":self.shop.logo,
                           @"isOnlyImg":@(NO)
                           }.mutableCopy;
    
    YFSharePlatformType type = YFSharePlatformType_WechatSession;
    
    switch (btn.tag - 100) {
        case 0:{// 微信
            type = YFSharePlatformType_WechatSession;
            dic[@"is_miniProgrammar"] = @([self.shop.wxapp[@"have_wx_app"] boolValue]);
            dic[@"miniProgrammar_vc"] = self.superVC;
            dic[@"userName"] = self.shop.wxapp[@"wx_app_id"];
            dic[@"pagePath"] = self.shop.wxapp[@"wx_app_url"];
        }
            break;
            
        case 1:{// 朋友圈
            type = YFSharePlatformType_WechatTimeLine;
            UIImage *img = [self convertViewToImage:self.backView];
            dic[@"urlImg"] = @"";
            dic[@"savedImg"] = img;
            dic[@"isOnlyImg"] = @(YES);
        }
            
            break;
            
        case 2:// QQ
            type = YFSharePlatformType_QQ;
            break;
            
        case 3:{// QQZone
            UIImage *img = [self convertViewToImage:self.backView];
            type = YFSharePlatformType_QQZone;
            dic[@"urlImg"] = @"";
            dic[@"savedImg"] = img;
            dic[@"isOnlyImg"] = @(YES);
        }
            break;
        case 4:{// 相册
            UIImage *img = [self convertViewToImage:self.backView];
            dic[@"savedImg"] = img;
            type = YFSharePlatformType_SaveImg;
        }
            break;
        default:
            break;
    }
    
    if ([dic[@"is_miniProgrammar"] boolValue]) [self dismiss];
    
    [YFShareTool yf_shareWithInfo:dic toPlatform:type block:^(BOOL success, NSString *msg) {
        [self dismiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToastAlertMessageWithTitle:msg];
        });
    }];
    
}

- (UIImage *)convertViewToImage:(UIView *)view
{
    // 第二个参数表示是否非透明。如果需要显示半透明效果，需传NO，否则YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,NO,[UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    view.layer.shadowOpacity = 0.0;
    view.layer.masksToBounds = YES;
    [view.layer renderInContext:context];
    view.layer.shadowOpacity = 1.0;
    view.layer.masksToBounds = NO;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark ======动画的实现=======
-(instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor clearColor];
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

//非手势的动画实现
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [PresentAnimationTransition transitionWithTransitionType:YFPresentTransitionTypePresentCaseIn];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [PresentAnimationTransition transitionWithTransitionType:YFPresentTransitionTypeDismissCaseOut];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ======拦截点击事件=======
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point =  [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(self.backView.frame, point)) {
        return;
    }
    if (CGRectContainsPoint(self.bottomView.frame, point)) {
        return;
    }
    [self dismiss];
    
}

@end
