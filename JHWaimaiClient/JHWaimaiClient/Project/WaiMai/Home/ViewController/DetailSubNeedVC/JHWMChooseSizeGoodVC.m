//
//  JHWMChooseSizeGoodVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/22.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMChooseSizeGoodVC.h"
#import "PresentAnimationTransition.h"
#import "YFCollectionViewLayout.h"
#import <UIImageView+WebCache.h>
#import "NSString+Tool.h"
#import "WMGoodSizeCell.h"
#import "YFSteper.h"
#import "WMGoodSizeSectionHeadView.h"

@interface JHWMChooseSizeGoodVC ()<UIViewControllerTransitioningDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewLayoutDelegate,YFSteperDelegate>
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)UILabel *sizeLab;
@property(nonatomic,weak)YFSteper *steper;
//@property(nonatomic,copy)NSString *chooseSize_id;
//@property(nonatomic,copy)NSString *chooseSize_Name;
@property(nonatomic,assign)NSInteger selecteIndexRow;
@end

@implementation JHWMChooseSizeGoodVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.good.specs.count > 0) {
        // 默认选择规格
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selecteIndexRow inSection:0]];
    }
    
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView{
   
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.right.offset=0;
    }];
    backView.backgroundColor = [UIColor whiteColor];
    self.backView = backView;
    
    UIImageView *iconImgView = [UIImageView new];
    [backView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=-10;
        make.width.offset=100;
        make.height.offset=100;
    }];
    self.iconImgView = iconImgView;
    
    UILabel *priceLab = [UILabel new];
    [backView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.top.offset=10;
        make.height.offset=20;
    }];
    priceLab.font = FONT(12);
    priceLab.textColor = HEX(@"ff6600", 1.0);
    self.priceLab = priceLab;
    
    UILabel *desLab = [UILabel new];
    [backView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.top.equalTo(priceLab.mas_bottom).offset=10;
        make.height.offset=20;
    }];
    desLab.font = FONT(12);
    desLab.textColor = HEX(@"999999", 1.0);
    self.desLab = desLab;
    
    UILabel *sizeLab = [UILabel new];
    [backView addSubview:sizeLab];
    [sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.top.equalTo(desLab.mas_bottom).offset=10;
        make.height.offset=20;
    }];
    sizeLab.font = FONT(12);
    sizeLab.textColor = HEX(@"333333", 1.0);
    self.sizeLab = sizeLab;
    
    UIButton *closeBtn = [UIButton new];
    [backView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.top.offset=0;
        make.width.offset=30;
        make.height.offset=30;
    }];
    [closeBtn setImage:IMAGE(@"index_btn_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    YFCollectionViewLayout * flowLayout=[[YFCollectionViewLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.lineItems = 5;
    flowLayout.interSpace = 0;
    flowLayout.delegate = self;
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,WIDTH,0) collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[WMGoodSizeCell class] forCellWithReuseIdentifier:@"WMGoodSizeCell"];
    [collectionView registerClass:[WMGoodSizeSectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMGoodSizeSectionHeadView"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [backView addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(iconImgView.mas_bottom).offset=10;
        make.right.offset=0;
    }];
    
    UIView *lineView=[UIView new];
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(collectionView.mas_bottom).offset=0;
        make.right.offset=0;
        make.height.offset=1;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    UILabel *lab = [UILabel new];
    [backView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(lineView.mas_bottom).offset=10;
        make.height.offset=20;
    }];
    lab.font = FONT(14);
    lab.textColor = HEX(@"333333", 1.0);
    lab.text = NSLocalizedString(@"数量", nil);
    
    YFSteper *steper = [YFSteper new];
    [backView addSubview:steper];
    [steper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(lab.mas_centerY).offset=0;
        make.width.offset=100;
        make.height.offset=40;
        make.bottom.offset = -10;
    }];
    steper.minCount = 0;
    steper.delegate = self;
    steper.subBtnImg = @"btn-num_subtraction";
    steper.addBtnImg = @"btn-num_addCart";
    self.steper = steper;
  
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.good.specs count];
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMGoodSizeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMGoodSizeCell" forIndexPath:indexPath];

    WMShopGoodSpecModel *spec = self.good.specs[indexPath.row];
    [cell reloadCellWith:spec.spec_name is_selected:NO];
  
    return cell;
    
}

#pragma mark ======YFCollectionViewLayoutDelegate=======
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH/5.0, 40);
}

-(CGSize)collectionViewSectionHeadSizeForSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 30);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    WMGoodSizeSectionHeadView *header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMGoodSizeSectionHeadView" forIndexPath:indexPath];
    NSString *title = NSLocalizedString(@"规格", nil);
    [header reloadViewWith:title];
    
    return header;
    
}

#pragma mark ======YFSteperDelegate=======
-(void)addCount{

    if ( self.goodCountChange) {
        self.goodCountChange(YES);
    }
}

-(void)subCount:(int)count{

    if ( self.goodCountChange) {
        self.goodCountChange(NO);
    }
}

#pragma mark ====== Functions =======
// 选个不同的size
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selecteIndexRow = indexPath.row;
    [self reloadView];
    
}

// 刷新界面
-(void)reloadView{
    
    WMShopGoodSpecModel *spec = self.good.specs[self.selecteIndexRow];
    self.good.choosedSize_id = spec.spec_id;
    self.good.choosedSize_price = spec.price;
    self.good.choosedSize_photo = spec.spec_photo;
    self.good.choosedSize_Name = spec.spec_name;
    self.good.spec_package_price = spec.package_price;
    self.good.choosedSize_sale_ku = spec.sale_sku;
    
    NSString *sizeStr = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"已选", @"JHWMChooseSizeGoodVC"),spec.spec_name];
    NSString *img = spec.spec_photo.length == 0 ? self.good.photo : spec.spec_photo;

    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(img)] placeholderImage:IMAGE(@"product100_default")];
    self.priceLab.attributedText = [NSString priceLabText:spec.price attributeFont:16];
    self.desLab.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"已售", nil),spec.sale_count];

    self.sizeLab.text = sizeStr;
    int count = [[WMShopDBModel shareWMShopDBModel] getShopGoodChoosedCountFromDB:self.good.product_id choosedSize_id:spec.spec_id propretyStr:self.good.choosed_proprety good:_good];
    self.good.good_choosedCount = count;
    self.steper.maxCount = spec.sale_sku;
    self.steper.currentCount = count;
    [self.collectionView reloadData];
    
    CGSize size = [self.collectionView.collectionViewLayout collectionViewContentSize];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset = size.height + 10;
    }];

    // 选择规格
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selecteIndexRow inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
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
    return [PresentAnimationTransition transitionWithTransitionType:YFPresentTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [PresentAnimationTransition transitionWithTransitionType:YFPresentTransitionTypeDismiss];
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
    [self dismiss];
}

@end
