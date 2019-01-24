//
//  JHWMSearchOnShopVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMSearchOnShopVC.h"
#import "WMShopGoodCell.h"
#import "YFTextField.h"
#import "JHWMShopCartVC.h"
#import "JHView.h"
#import "JHWMCreateOrderVC.h"
#import "JHWMChooseSizeGoodPropertyVC.h"
#import "JHShopMenuVC.h"
#import "YFTypeBtn.h"
@interface JHWMSearchOnShopVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,CAAnimationDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)YFTextField *searchField;
@property(nonatomic,copy)NSString *keyword;

@end

@implementation JHWMSearchOnShopVC

-(void)loadView{
    
    self.view = [[JHView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchField resignFirstResponder];
    [self.searchField endEditing:YES];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView{
    
    self.navigationItem.titleView = self.searchField;
    [self.searchField becomeFirstResponder];
    self.dataSource = [NSMutableArray array];
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, 0, HEIGHT) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=NAVI_HEIGHT;
        make.width.offset=WIDTH;
        make.bottom.offset=-WMShopCartBottomViewH;
    }];

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

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.dataSource.count;
    if (count == 0) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr:nil btnTitle:nil inView:tableView];
    }else{
        [self hiddenEmptyView];
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"WMShopGoodCell";
    WMShopGoodCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[WMShopGoodCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
   
    WMShopGoodModel *good = self.dataSource[indexPath.row];
    [cell reloadCellWithModel:good keyword:self.keyword];
    
    __weak typeof(self) weakSelf=self;
    cell.productNumChange = ^(UIView *fromView){ // fromView不为nil 添加商品
        [weakSelf dealWithChooseProduct:fromView indexPath:indexPath];
    };
    
    cell.chooseGoodSize = ^{
        [weakSelf chooseSizeGood:indexPath];
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *goodArr = [self.shopModel.cateArr[indexPath.section] products] ;
    WMShopGoodModel *good = goodArr[indexPath.row];
    
    CGFloat titleH = getStrHeight(good.title, WIDTH - 115 -10, 16);
    if (good.intro.length != 0) titleH += 25;
    if (good.is_discount) titleH += (5 + 16);
    titleH = titleH + 10 + 25 + 40;
    return MAX(titleH, 120);
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchField resignFirstResponder];
    [self.searchField endEditing:YES];
}

#pragma mark ====== 点击清除搜索信息的按钮 =======
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickSearch];
    return YES;
}
#pragma mark ====== Functions =======
// 点击搜索
-(void)clickSearch{
    if (self.searchField.text.length == 0 ) {
        return;
    }
    [self.searchField endEditing:YES];
    [self.searchField resignFirstResponder];

    self.keyword = self.searchField.text;
    [self.shopModel searchProductWithKeyword:self.searchField.text block:^(NSArray *arr, NSString *msg) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:arr];
        [self.tableView reloadData];
    }];
}

#pragma mark  ------- 点击cell中的steper商品数量变化时的界面变化
-(void)dealWithChooseProduct:(UIView *)fromView indexPath:(NSIndexPath *)indexpath{
    
    WMShopGoodModel *good = self.dataSource[indexpath.row];
    BOOL is_add = YES;
    if (fromView) {// 增加
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addProductAnimation:fromView dropToPoint:CGPointMake(30, self.view.height - 20)];
        });
    }else{// 减少
        is_add = NO;
        [self.shopCartVC cartBtnAnimation:is_add];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.shopMenuVC dealWithChooseProduct:good is_add:is_add];
    });
    
}

// 选规格商品
-(void)chooseSizeGood:(NSIndexPath *)indexpath{
    
    WMShopGoodModel *good = self.dataSource[indexpath.row];
    
    JHWMChooseSizeGoodPropertyVC *chooseSizeVC = [JHWMChooseSizeGoodPropertyVC new];
    chooseSizeVC.good = good;
    [self presentViewController:chooseSizeVC animated:YES
                     completion:nil];
    __weak typeof(self) weakSelf=self;
    chooseSizeVC.goodCountChange = ^(BOOL is_add){
        [weakSelf.shopMenuVC dealWithChooseProduct:good is_add:is_add];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark ====== 懒加载 =======
-(YFTextField *)searchField{
    if (_searchField==nil) {
        UIButton *btn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 30, 30)];
        [btn setImage:IMAGE(@"nav_btn_search_gray") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
        
        _searchField=[[YFTextField alloc] initWithFrame:CGRectMake(0, 0, 350, 30) leftView:[UIView new] rightView:btn];
        _searchField.letfMargin = 15;
        _searchField.rightMargin = 5;
        _searchField.font = FONT(14);
        _searchField.placeholdeFont = FONT(14);
        _searchField.textColor = HEX(@"666666", 1.0);
        _searchField.placeholdeColor = HEX(@"999999", 1.0);
        _searchField.delegate = self;
        _searchField.placeholder = NSLocalizedString(@"搜索商品", @"JHWMSearchOnShopVC");
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.backgroundColor = [UIColor whiteColor];
        _searchField.layer.cornerRadius=15;
        _searchField.clipsToBounds=YES;
        _searchField.tintColor = [UIColor blueColor];
        _searchField.returnKeyType = UIReturnKeySearch;
    }
    return _searchField;
}


@end
