//
//  JHWMShopGoodDetailVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/23.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMShopGoodDetailVC.h"
#import <UIImageView+WebCache.h>
#import "WMGoodDetailCellOne.h"
#import "WMGoodDetailCellTwo.h"
#import "JHWMShopCartVC.h"
#import "JHShopMenuVC.h"
#import "JHWMChooseSizeGoodPropertyVC.h"
#import "JHView.h"
#import "YFTypeBtn.h"
#import "JHWMCreateOrderVC.h"
@interface JHWMShopGoodDetailVC ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>
@property(nonatomic,weak)UIImageView *imgView;
@end

@implementation JHWMShopGoodDetailVC

-(void)loadView{
    self.view = [[JHView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.naviColor = NaVi_COLOR_Alpha(0.0);
    [self setUpView];
//    self.navigationItem.title = NSLocalizedString(@"商品详情", @"JHWMShopGoodDetailVC");
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(self.good.photo)] placeholderImage:IMAGE(@"product186_default")];
}

-(void)setUpView{

    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 49) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 120;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(0, 0, WIDTH, WIDTH * 0.75)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.masksToBounds = YES;
    self.imgView = imgView;
    self.tableView.tableHeaderView = imgView;
  
    [self.view addSubview:self.shopCartVC.view];
    [self.shopCartVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.right.offset= 0;
        make.height.offset=WMShopCartBottomViewH;
    }];
    
    self.shopCartVC.superVC = self;
    [self addChildViewController:self.shopCartVC];
    ((JHView *)self.view).willToHitView = self.shopCartVC.ziTiBtn;
     __weak typeof(self) weakSelf=self;
    self.shopCartVC.shopCartCountChange = ^{
         [weakSelf.tableView reloadData];   
    };
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *ID=@"WMGoodDetailCellOne";
        WMGoodDetailCellOne *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WMGoodDetailCellOne alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell reloadCellWithModel:self.good];
         __weak typeof(self) weakSelf=self;
        cell.productNumChange = ^(UIView *fromView){
            [weakSelf dealProductCountChange:fromView];
        };
        cell.chooseGoodSize = ^(){
            [weakSelf chooseSizeGood];
        };
        return cell;
    }else{
        static NSString *ID=@"WMGoodDetailCellTwo";
        WMGoodDetailCellTwo *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WMGoodDetailCellTwo alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell reloadCellWithModel:self.good];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark ====== Functions =======
// 选非规格商品
-(void)dealProductCountChange:(UIView *)fromView{
    
    BOOL is_add = fromView ? YES : NO;
    [self.shopMenuVC dealWithChooseProduct:_good is_add:is_add];
    if (is_add) {
        [self addProductAnimation:fromView dropToPoint:CGPointMake(30, self.view.height - 20)];
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

// 选规格商品
-(void)chooseSizeGood{
   
    JHWMChooseSizeGoodPropertyVC *chooseSizeVC = [JHWMChooseSizeGoodPropertyVC new];
    chooseSizeVC.good = self.good;
    [self presentViewController:chooseSizeVC animated:YES
                             completion:nil];
     __weak typeof(self) weakSelf=self;
    chooseSizeVC.goodCountChange = ^(BOOL is_add){
        [weakSelf.shopMenuVC dealWithChooseProduct:weakSelf.good is_add:is_add];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    
}

#pragma mark ======购物车动画=======
- (void)addProductAnimation:(UIView *)out_view dropToPoint:(CGPoint)dropToPoint {
    
    CGRect rect = [out_view convertRect:out_view.bounds toView:self.view];
    CGFloat startX = rect.origin.x + 5;
    CGFloat startY = rect.origin.y ;
    
    UIBezierPath *path= [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startX  , startY )];
    
    CGFloat margin=50;
    
    //三点曲线
    [path addCurveToPoint:CGPointMake(dropToPoint.x, dropToPoint.y)
            controlPoint1:CGPointMake(startX - 5, startY - 5)
            controlPoint2:CGPointMake(startX - 2 * margin, startY- 2 * margin)];
    
    CALayer * dotLayer = [CALayer layer];
    dotLayer.backgroundColor = HEX(@"4DC831", 1.0).CGColor;
    dotLayer.frame = CGRectMake(0, 0, 24, 24);
    dotLayer.cornerRadius = 24/2.0;
    [self.view.layer addSublayer:dotLayer];
    [self groupAnimation:dotLayer path:path];
    
}

#pragma mark - 组合动画
-(void)groupAnimation:(CALayer *)layer path:(UIBezierPath *)path
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.6, 0.6, 1)];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation,transformAnimation];
    groups.duration = .5f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [layer addAnimation:groups forKey:@"cartParabola"];
    
    [self performSelector:@selector(removeFromLayer:) withObject:layer afterDelay:.45f];
    
}

- (void)removeFromLayer:(CALayer *)layerAnimation{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layerAnimation removeFromSuperlayer];
        [layerAnimation removeAnimationForKey:@"cartParabola"];
    });
    
}

@end
