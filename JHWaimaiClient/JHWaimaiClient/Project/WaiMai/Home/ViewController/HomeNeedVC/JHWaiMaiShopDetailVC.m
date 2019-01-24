//
//  JHWaiMaiShopDetailVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/4.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiShopDetailVC.h"
#import "ContentView.h"
#import "JHShopMenuVC.h"
#import "JHShopDetailVC.h"
#import "JHShopEvaluateVC.h"
#import "DynamicItem.h"
#import "ShopDetailTopView.h"
#import "ShopDetailYouHuiView.h"
#import "JHUserModel.h"
#import <UIImageView+WebCache.h>
#import "JHWMShopShowStatusView.h"
#import "XTPopView.h"
#import "JHWMSearchOnShopVC.h"

// 最小距离顶部的距离
#define TopViewHeight  90
// 最小距离顶部的距离
#define MinTopOffSet  NAVI_HEIGHT
// 最大距离顶部的距离
#define MaxTopOffSet  (110 + NAVI_HEIGHT)
// 回弹的最大距离
#define BottomOffSet (HEIGHT * 0.6)

// 推荐商品view的高度
#define TuiJianViewH 230

@interface JHWaiMaiShopDetailVC ()<ContentViewDelegate,UIDynamicAnimatorDelegate,selectIndexPathDelegate>
@property(nonatomic,weak)ContentView *contentView;
@property(nonatomic,weak)UIImageView *backImgView;
@property(nonatomic,weak)JHShopMenuVC *menuVC;
// 收藏按钮
@property(nonatomic,weak)UIButton *collectionShopBtn;
// 展示商家信息的View
@property(nonatomic,weak)ShopDetailTopView *topView;
// 展示商家优惠信息的View
@property(nonatomic,weak)ShopDetailYouHuiView *youhuiView;
// contentView 距离顶部的约束高度
@property(nonatomic,assign)CGFloat offsetTop;
/**
 *  用于模拟scrollView滚动
 */
@property (nonatomic, strong) UIDynamicAnimator  *animator;
@property (nonatomic, strong) UIDynamicItemBehavior *inertialBehavior;

@property(nonatomic,assign)BOOL is_showMore;

@property(nonatomic,weak)WMShopModel *shop;
@property(nonatomic,strong)JHWMShopShowStatusView *closeStoreView;//打烊的view
@property(nonatomic,strong)XTPopView *popView;//右上角的弹出
@property(nonatomic,strong)UIButton *customBtn;
@property(nonatomic,assign)float alpha;
@property(nonatomic,assign)BOOL have_tjView;// 是否存在推荐商品
@end

@implementation JHWaiMaiShopDetailVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar yf_setTitle:self.shop.title];
    [self.navigationController.navigationBar yf_setTitleAlpha:self.alpha];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController.navigationBar yf_setBackgroundColor:self.naviColor];
    });
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar yf_setTitleAlpha:0.0];
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewDidDisappear:(BOOL)animated{
    [NoticeCenter postNotificationName:NaviClearTitle object:nil];
    [super viewDidDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [WMShopDBModel shareWMShopDBModel].moreShopCartProductStr = @"";
    [self.menuVC adjustShopCartView];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];

//    [NoticeCenter addObserver:self selector:@selector(needPopToRoot) name:WMCreateOrderSuccess object:nil];
    
    [self setNavi];
    [self setUpView];
    [self changeAlphaWith:self.offsetTop];
//    [self showEmptyViewWithImgName:@"icon_wu" desStr:nil btnTitle:nil inView:self.view];
    [NoticeCenter addObserver:self selector:@selector(getData) name:Login_Success object:nil];
    [self getData];
}

-(void)needPopToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setNavi{
    self.naviColor = NaVi_COLOR_Alpha(0.0);
    [self moreRightBtn];
    [self.navigationController.navigationBar yf_setTitleAlpha:0.0];
    if (self.presentingViewController) {
        [self.navigationController.navigationBar yf_setTitleAlpha:0.0];
        [self createBackBtn];
        self.backBtnImgName = @"closeNew";
        [WMShopDBModel shareWMShopDBModel].is_presentShopDetailVC = YES;
    }else{
        self.backBtnImgName = @"btn_top_back";
    }
}

-(void)clickBackBtn{
    if (self.presentingViewController){
        if ([WMShopDBModel shareWMShopDBModel].sureChooseBlock) {
            [WMShopDBModel shareWMShopDBModel].sureChooseBlock(NO,@"");
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else [super clickBackBtn];
}

#pragma mark - 这是一个按钮的
-(void)oneRightBtn{
    self.navigationItem.rightBarButtonItems  = nil;
     _customBtn = [self addRightBtnWith:@"btn_more" sel:@selector(clickPop:)];
}
#pragma mark - 这是多个按钮的显示
-(void)moreRightBtn{
    self.navigationItem.rightBarButtonItems  = nil;
    [self addRightBtnWith:@"index_btn_searchFr" sel:@selector(jumpSearch)];
    [self addRightBtnWith:@"navbar_btn_share" sel:@selector(shareShop)];
    self.collectionShopBtn = [self addRightBtnWith:@"navbar_btn_collect_no" sel:@selector(collectionShop)];
    self.collectionShopBtn.selected = self.shop.collect;
    [self.collectionShopBtn setImage:IMAGE(@"navbar_btn_collect_yes") forState:UIControlStateSelected];
   
}
#pragma mark - 添加右上角的弹出
-(void)clickPop:(UIButton *)btn{
    [self.popView popView];
}
-(XTPopView *)popView{
    if (!_popView) {
        _popView = [[XTPopView alloc] initWithOrigin:(CGPoint){WIDTH-20,_customBtn.frame.origin.y + (NAVI_HEIGHT - STATUS_HEIGHT) + 4}
                                               Width:100
                                              Height:(40 * 3+10)
                                                Type:XTTypeOfUpRight
                                               Color:BACK_COLOR];
        _popView.dataArray = @[NSLocalizedString(@"店内搜索",nil),
                               NSLocalizedString(@"分享店铺",nil),
                               NSLocalizedString(@"收藏店铺",nil)];
        _popView.fontSize = 14;
        _popView.row_height = 40;
        _popView.titleTextColor = HEX(@"333333", 1.0);
        _popView.delegate = self;
    }
    _popView.images = @[@"shop_icon_search",@"shop_icon_share", self.shop.collect?@"shop_icon_like_checked":@"shop_icon_like"];
    return _popView;
}
-(void)setUpView{
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(0, 0, WIDTH,HEIGHT)];
    imgView.userInteractionEnabled = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = FRAME(0, 0, WIDTH, HEIGHT);
    [imgView addSubview:effectView];
    [self.view addSubview:imgView];
    self.backImgView = imgView;
    
    ShopDetailTopView *topView = [ShopDetailTopView new];
    [imgView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset= MinTopOffSet;
        make.right.offset = 0;
        make.height.offset= TopViewHeight;
    }];
    [topView addTarget:self action:@selector(clickTopView) forControlEvents:UIControlEventTouchUpInside];
    self.topView = topView;
    ShopDetailYouHuiView *youhuiView = [ShopDetailYouHuiView new];
    [imgView addSubview:youhuiView];
    [youhuiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(topView.mas_bottom).offset=0;
        make.right.offset = 0;
    }];
    self.youhuiView = youhuiView;
    __weak typeof(self) weakSelf=self;
    youhuiView.clickShowMore = ^(BOOL selected){
        float toOffSet = MinTopOffSet + TopViewHeight + weakSelf.youhuiView.height;
        if (!selected) {
            toOffSet = MaxTopOffSet;
        }
        [weakSelf showMoreYouHuiAnmation:selected toOffSet:toOffSet];
    };
    [self setUpContentView];
}
-(void)setUpContentView{
    self.offsetTop = MaxTopOffSet;
    ContentView *contentView = [ContentView new];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(self.offsetTop);
        make.height.offset = HEIGHT - self.offsetTop;
    }];
    contentView.delegate = self;
    self.contentView = contentView;
    JHShopMenuVC *menu = [JHShopMenuVC new];
    menu.superVC = self;
    menu.good_id = self.good_id;
    menu.onceAgainProductsArr = self.onceAgainProductsArr;
    [menu loadView];
    [self addChildViewController:menu];
    [contentView addViewController:menu.view index:0];
    self.menuVC = menu;
    JHShopEvaluateVC *evaluate = [JHShopEvaluateVC new];
    evaluate.superVC = self;
    evaluate.shop_id = self.shop_id;
    [evaluate loadView];
    [self addChildViewController:evaluate];
    [contentView addViewController:evaluate.view index:1];
    JHShopDetailVC *detail = [JHShopDetailVC new];
    detail.superVC = self;
    detail.shop_id = self.shop_id;
    [detail loadView];
    [self addChildViewController:detail];
    [contentView addViewController:detail.view index:2];
}
#pragma mark ====== ContentViewDelegate =======
-(void)panGestureDealWith:(UIPanGestureRecognizer *)pan{
    
    [self.animator removeAllBehaviors];
    if ([self.contentView.currentTableView isRefresh]) {// 刷新的时候手势不响应
        [pan setValue:@(UIGestureRecognizerStateEnded) forKeyPath:@"state"];
    }
    CGPoint point = [pan translationInView:self.contentView];
    // 速度
    CGFloat velocity = [pan velocityInView:self.contentView].y;
    // 偏移计算
    CGFloat offsety = self.offsetTop + point.y;
    if (point.y > 0 && self.contentView.currentTableView.contentOffset.y > 0) {//下滑

        if (self.contentView.currentTableView.contentOffset.y - point.y <= 0) {
            self.contentView.currentTableView.contentOffset = CGPointMake(0, 0);
        }else{
            self.contentView.currentTableView.contentOffset = CGPointMake(0, self.contentView.currentTableView.contentOffset.y - point.y);
        }
    

        
    }else if (point.y < 0 && self.offsetTop == MinTopOffSet) {//上滑
        CGFloat f = self.contentView.currentTableView.contentSize.height - self.contentView.currentTableView.frame.size.height;
        if (f <= 0) {// tableveiw 本身不具备互动能力的处理（contentSize不大于frame.height）
            self.contentView.currentTableView.contentOffset = CGPointMake(0,0);
        }else {
            
            if(self.contentView.currentIndex == 0 && self.have_tjView){ // 是菜单界面
                if (self.menuVC.tuiJianView.y > -TuiJianViewH) {
                    //                    self.contentView.currentTableView.y -= point.y;
                    self.menuVC.tuiJianView.y += point.y;
                }else{
                    self.menuVC.tuiJianView.y = -TuiJianViewH;
                }
            }

            if (self.contentView.currentTableView.contentSize.height - self.contentView.currentTableView.contentOffset.y - HEIGHT +40 < -50) {// tableView 拖动到底部且继续往上拖动（tableView增加的偏移量小于拖动的距离）
                self.contentView.currentTableView.contentOffset = CGPointMake(0, self.contentView.currentTableView.contentOffset.y - point.y * 0.3);
            }else{//正常上滑处理
                
                if(self.contentView.currentIndex == 0  && self.have_tjView){ // 是菜单界面
                    if (self.menuVC.tuiJianView.y > -TuiJianViewH) {
                        self.menuVC.tuiJianView.y += point.y;
                    }else{
                        self.menuVC.tuiJianView.y = -TuiJianViewH;
                        self.contentView.currentTableView.contentOffset = CGPointMake(0, self.contentView.currentTableView.contentOffset.y - point.y);
                    }
                }else{
                    self.contentView.currentTableView.contentOffset = CGPointMake(0, self.contentView.currentTableView.contentOffset.y - point.y);
                }
                
            }
        }
    }else{// 更新contentView的顶部的约束

        self.offsetTop = offsety < MinTopOffSet ? MinTopOffSet : offsety;
        if(self.contentView.currentIndex == 0 && self.have_tjView){ // 是菜单界面
            if (self.menuVC.tuiJianView.y <= 0 && point.y > 0 ) { // 下滑
                if (self.menuVC.tuiJianView.y + point.y >= 0) {
                    self.menuVC.tuiJianView.y = 0;
                }else{
                    self.menuVC.tuiJianView.y += point.y;
                }
                if (self.menuVC.tuiJianView.y < 0) {
                    self.offsetTop = MinTopOffSet;
                }
            }
        }

    }
    float toOffSet = MinTopOffSet + TopViewHeight + self.youhuiView.height ;
    if (self.offsetTop < toOffSet){
        self.is_showMore = NO;
    }
    if (point.y > 0 && self.contentView.currentTableView.contentOffset.y == 0) {
        
        if (self.offsetTop >= toOffSet && velocity < 300) {
            self.is_showMore = YES;
        }
    }
    // 防止滑动到最底部
    if (offsety > BottomOffSet  ) {
        [pan setValue:@(UIGestureRecognizerStateEnded) forKeyPath:@"state"];
    }
    // 拖动结束
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed) {
        
        if (self.is_showMore) {
            self.offsetTop = toOffSet;
            [self rubberBandingAnimation];
            return;
        }
        
        if (self.offsetTop >= MaxTopOffSet && self.contentView.currentTableView.contentOffset.y == 0) {// 超过预设的高度，回弹
            self.offsetTop = MaxTopOffSet;
            [self rubberBandingAnimation];
        }else{

            if (self.contentView.currentTableView.contentOffset.y >0 && (self.offsetTop == MinTopOffSet || self.offsetTop == MaxTopOffSet) ) {
                // contentView 距离顶部为零但是tableView的contentOffSet大于零，这时候速度传递给tableView
                // 下滑减速
                self.contentView.velocity = velocity;
            }else if(velocity< 0 && self.contentView.currentTableView.contentOffset.y >0 && self.offsetTop >MinTopOffSet ){
                // contentView 距离顶部大于零但是tableView的contentOffSet大于零，contentView模拟减速滚动效果
                [self deceleratingAnimator:velocity];

            }else{// 上滑减速
                //contentView 模拟减速滚动效果
                [self deceleratingAnimator:velocity];
            }
        }
    }else{
        [self changeAlphaWith:self.offsetTop];
        // 拖动的时候更改约束达到修改表的高度的效果
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.offsetTop);
            make.height.offset = HEIGHT - self.offsetTop;
        }];
    }
    //清零防止偏移累计
    [pan setTranslation:CGPointZero inView:self.contentView];
}
// tableView的反向速度传递
-(void)velocityOfTableViewWhenTableIsTop:(CGFloat)speed{
    //反向速度传递的速度有点小，处理下，和之前传过去的速度进行处理的倍数有关
    [self deceleratingAnimator:speed*40];
}
// 移除滚动效果
-(void)removeBehaviors{
    [self.animator removeAllBehaviors];
}

#pragma mark ====== 减速效果 =======
- (void)deceleratingAnimator:(CGFloat)velocity{
    
//    NSLog(@"velocity === %f",velocity);// 为负 上滑  为正 下滑
    
     static BOOL canJianTuiJianViewH = NO;
    if (velocity > 0 && self.contentView.currentIndex == 0 && self.have_tjView) {//  为正 下滑
//        if (self.offsetTop == MinTopOffSet) {
//             canJianTuiJianViewH = YES;
//        }else{
//            canJianTuiJianViewH = NO;
//        }
        canJianTuiJianViewH = YES;
    }
    
    if (self.inertialBehavior != nil) {
        [self.animator removeBehavior:self.inertialBehavior];
    }
    DynamicItem *item = [[DynamicItem alloc] init];
    // topOffset表示当前Container距离顶部的距离
    item.center = CGPointMake(0, self.offsetTop);
    // velocity是在手势结束的时候获取的竖直方向的手势速度
    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ item ]];
    [inertialBehavior addLinearVelocity:CGPointMake(0, velocity ) forItem:item];
    // 通过尝试取2.0比较像系统的效果
    inertialBehavior.resistance = 2;
    __weak typeof(self)weakSelf = self;
    static CGFloat lastTop = 0;
    static CGFloat lastTopCenterY = 0;
    inertialBehavior.action = ^{
        CGFloat itemTop = item.center.y ;
        itemTop = itemTop < MinTopOffSet ? MinTopOffSet : itemTop;
        NSLog(@"lastTop  %f",lastTop);
        NSLog(@"itemTop  %f",weakSelf.offsetTop);
        NSLog(@"fabs(itemTop - lastTop) ===== %f",fabs(itemTop - lastTop));
        if (fabs(itemTop - lastTop) < 1  && velocity > 0) { // pan 的快速下拉（velocity > 0），tableView进行反向速度传递时，减速效果越到后来耽误的时间越多，移除减速效果(后面的变化量都小于1，且耽误时间较长，所以直接忽略)
            [weakSelf.animator removeBehavior:weakSelf.inertialBehavior];
            weakSelf.inertialBehavior = nil;
            return;
        }
        
        
        if (velocity > 0 && self.contentView.currentIndex == 0 && self.have_tjView) {//为正 下滑 且是菜单界面

            if (self.menuVC.tuiJianView.y < 0) {
                if (self.contentView.currentTableView.contentOffset.y == 0) {
                    self.menuVC.tuiJianView.y += fabs(lastTop - itemTop) ;
                }
            }else{

                CGFloat newTop = itemTop - (canJianTuiJianViewH ? TuiJianViewH : 0);
                newTop = MAX(newTop, weakSelf.offsetTop);
                weakSelf.offsetTop = newTop;
            }
            lastTop = itemTop;

            if (self.menuVC.tuiJianView.y > 0 && self.have_tjView){
                self.menuVC.tuiJianView.y = 0;
            }
            
            NSLog(@"offsetTop  %f",weakSelf.offsetTop);
            // 往上还是往下减速都要更新约束
            [weakSelf changeAlphaWith:weakSelf.offsetTop];
            [weakSelf.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.view).offset(weakSelf.offsetTop);
                make.height.offset = HEIGHT - weakSelf.offsetTop;
            }];
            
        }else{//为负 上滑
            lastTop = itemTop;
            weakSelf.offsetTop = itemTop;
            // 往上还是往下减速都要更新约束
            [weakSelf changeAlphaWith:itemTop];
            [weakSelf.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.view).offset(weakSelf.offsetTop);
                make.height.offset = HEIGHT - weakSelf.offsetTop;
            }];
        }
        
        // contentview距离顶部的距离为零，这时候进行速度传递给tableView，移除contentView的减速效果
        if (itemTop == MinTopOffSet) {
            if (self.contentView.currentIndex == 0  && self.have_tjView) {// 菜单界面
                if(velocity > 0)
                {
                    // 速度传递给tableView
                    CGFloat velovity = [weakSelf.inertialBehavior linearVelocityForItem:weakSelf.inertialBehavior.items.firstObject].y;
                    weakSelf.contentView.velocity = velovity;
                    
                    [weakSelf.animator removeBehavior:weakSelf.inertialBehavior];
                    weakSelf.inertialBehavior = nil;
                }else{
                    
                    // 上滑动处理推荐View
                    if (self.menuVC.tuiJianView.y > -TuiJianViewH && self.have_tjView) {
                        self.menuVC.tuiJianView.y -= fabs(lastTopCenterY - item.center.y);
                    }else{
                        self.menuVC.tuiJianView.y = -TuiJianViewH;
                        
                        // 速度传递给tableView
                        CGFloat velovity = [weakSelf.inertialBehavior linearVelocityForItem:weakSelf.inertialBehavior.items.firstObject].y;
                        weakSelf.contentView.velocity = velovity;
                        
                        [weakSelf.animator removeBehavior:weakSelf.inertialBehavior];
                        weakSelf.inertialBehavior = nil;
                    }
                    
                }
            }else{// 不是菜单界面
                // 速度传递给tableView
                CGFloat velovity = [weakSelf.inertialBehavior linearVelocityForItem:weakSelf.inertialBehavior.items.firstObject].y;
                weakSelf.contentView.velocity = velovity;
                
                [weakSelf.animator removeBehavior:weakSelf.inertialBehavior];
                weakSelf.inertialBehavior = nil;
            }
        }
        
        lastTopCenterY = item.center.y;
        
        CGFloat topMax = itemTop;
        if (self.contentView.currentIndex == 0 && canJianTuiJianViewH && self.have_tjView) {// 菜单界面
            topMax = itemTop - TuiJianViewH;
        }
        // 移除contentView的减速效果
        if (topMax >= BottomOffSet) {
            [weakSelf.animator removeBehavior:weakSelf.inertialBehavior];
            weakSelf.inertialBehavior = nil;
        }

    };
    self.inertialBehavior = inertialBehavior;
    [self.animator addBehavior:inertialBehavior];
}
#pragma mark ====== 模拟弹回效果 =======
-(void)rubberBandingAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset = self.offsetTop;
            make.height.offset = HEIGHT - self.offsetTop;
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.is_showMore = NO;
    }];
    [self changeAlphaWith:self.offsetTop];
}

-(void)showMoreYouHuiAnmation:(BOOL)showMore toOffSet:(float)offSet{
    if (self.inertialBehavior != nil) {
        [self.animator removeBehavior:self.inertialBehavior];
    }
    DynamicItem *item = [[DynamicItem alloc] init];
    // topOffset表示当前Container距离顶部的距离
    item.center = CGPointMake(0, self.offsetTop);
    // velocity是在手势结束的时候获取的竖直方向的手势速度
    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ item ]];
    CGFloat velocity = showMore ? 300 : -300;
    [inertialBehavior addLinearVelocity:CGPointMake(0, velocity) forItem:item];
    // 通过尝试取2.0比较像系统的效果
    inertialBehavior.resistance = 2;
    __weak typeof(self)weakSelf = self;
    self.is_showMore = showMore;
    inertialBehavior.action = ^{
        CGFloat itemTop = item.center.y;
        weakSelf.offsetTop = showMore ? MIN(itemTop, offSet) : MAX(itemTop, offSet);
        [weakSelf.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(weakSelf.offsetTop);
            make.height.offset = HEIGHT - weakSelf.offsetTop;
        }];
        [weakSelf changeAlphaWith:itemTop];
        if (showMore) {
            if (itemTop > offSet) {
                [weakSelf.animator removeBehavior:weakSelf.inertialBehavior];
                weakSelf.inertialBehavior = nil;
                return ;
            }
        }else{
            if (itemTop <= offSet) {
                [weakSelf.animator removeBehavior:weakSelf.inertialBehavior];
                weakSelf.inertialBehavior = nil;
                return;
            }
        }
    };
    self.inertialBehavior = inertialBehavior;
    [self.animator addBehavior:inertialBehavior];
}

#pragma mark ======UIDynamicAnimatorDelegate=======
//移除contentView的减速效果后判断需不需要回弹
-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    if (self.offsetTop > MaxTopOffSet && !self.is_showMore) {
        self.offsetTop = MaxTopOffSet;
        [self rubberBandingAnimation];
    }
}

#pragma mark ======Function=======
// 获取数据
-(void)getData{
    SHOW_HUD
    [WMShopModel getShopDetailWith:self.shop_id block:^(WMShopModel *model, NSString *msg) {
        HIDE_HUD
        if (model) {
            [self hiddenEmptyView];
            self.shop = model;
            [WMShopDBModel shareWMShopDBModel].shopModel = model;
            self.have_tjView = model.tj_items.products.count > 0;
            [self presetToCloseStore:model.status];
            self.collectionShopBtn.selected = self.shop.collect;
        #pragma mark ====== 设置凑单金额 =======
            model.couDanPrice = [model.min_amount floatValue]/2.0;
            self.menuVC.shopModel = model;
            [self.topView reloadViewWithModel:model];
            [self.youhuiView reloadViewWithArr:model.huodong];
            [self.navigationController.navigationBar yf_setTitle:model.title];

            UIImage *img = [[[SDWebImageManager sharedManager] imageCache]imageFromCacheForKey:ImageUrl(self.shop.logo)];
            self.backImgView.image = [self clipPictureWithImg:img];
            
        }else{
            [self showToastAlertMessageWithTitle:msg];
            [self showEmptyViewWithImgName:@"icon_wu" desStr:nil btnTitle:nil inView:self.view];
        }
    }];
}
#pragma mark - 判断是否打烊的弹出的方法
-(void)presetToCloseStore:(int)status{
    if (status == 0) {//打烊弹出
        self.closeStoreView.shopStatus = ShopShowStatusViewCloseType;
        [self.closeStoreView showAnimation];
    }else if(self.shop.is_distance){
        self.closeStoreView.shopStatus = ShopShowStatusViewDistanceType;
        [self.closeStoreView showAnimation];
    }

}
-(JHWMShopShowStatusView *)closeStoreView{
    if (!_closeStoreView) {
        _closeStoreView = [[JHWMShopShowStatusView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:_closeStoreView];
    }
    return _closeStoreView;
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
#pragma mark - pop的点击事件回调
- (void)selectIndexPathRow:(NSInteger)index
{
    [_popView removeFromSuperview];
    _popView = nil;
    switch (index) {
        case 0://点击店内搜索
        {
            [self jumpSearch];
        }
            break;
        case 1://点击分享
        {
            [self shareShop];
        }
            break;
        case 2://点击收藏或者取消店铺
        {
            [self collectionShop];
        }
            break;
    }
}

// - 店内搜索的跳转
-(void)jumpSearch{
    if (!self.shop) return;
    JHWMSearchOnShopVC *shopSearch = [JHWMSearchOnShopVC new];
    shopSearch.shopCartVC = self.menuVC.shopCartVC;
    shopSearch.shopMenuVC = self.menuVC;
    shopSearch.shopModel = self.shop;
    [self.navigationController pushViewController:shopSearch animated:YES];
    
}

// 收藏商家
-(void)collectionShop{
    if (!self.shop) return;
    if ([JHUserModel shareJHUserModel].isLogin) {
        int status = self.shop.collect ? 0 : 1;
        [WMShopModel collectShopWith:self.shop_id status:status block:^(BOOL success, NSString *msg) {
            [self showToastAlertMessageWithTitle:msg];
            if (success) {
                self.shop.collect = !self.shop.collect;
                self.collectionShopBtn.selected = self.shop.collect;
            }
      }];
   }else{
        [NoticeCenter postNotificationName:LOGIN_NoticeName object:nil];
    }
    
}

//分享商家
-(void)shareShop{

    if (!self.shop) return;
    [self presentToNextVcWithVcName:@"YFWMShopShareVC" params:@{@"shop":self.shop,@"superVC":self}];
    
}

//点击TopView,显示公告和优惠信息的
-(void)clickTopView{
    
    [self removeBehaviors];
    JHBaseVC *vc = [NSClassFromString(@"JHWMShopNoticeVC") new];
    [vc setValue:self.shop forKey:@"shopModel"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

// 改变控件的透明度变化
-(void)changeAlphaWith:(CGFloat)topOffSet{
    
    if (topOffSet < TopViewHeight + MinTopOffSet) {
        if (topOffSet <= 10 + MinTopOffSet){
            CGFloat alpha = (10 + MinTopOffSet - topOffSet )/10;
            self.alpha = alpha;
            [self.navigationController.navigationBar yf_setTitleAlpha:alpha];
            [self oneRightBtn];
        }else{
            [self moreRightBtn];
            self.alpha = 0.0;
            [self.navigationController.navigationBar yf_setTitleAlpha:0.0];
        }
        self.topView.alpha = 1 - (TopViewHeight + MinTopOffSet - topOffSet )/(TopViewHeight + MinTopOffSet);
    }else{
        self.topView.alpha = 1.0;
    }
    
    self.youhuiView.topOffset = topOffSet - (TopViewHeight + MinTopOffSet);
    
    
}

#pragma mark - 懒加载
- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    return _animator;
}

@end

