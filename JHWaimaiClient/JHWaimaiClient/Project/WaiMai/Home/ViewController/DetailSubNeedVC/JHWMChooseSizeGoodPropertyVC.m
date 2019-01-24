//
//  JHWMChooseSizeGoodPropertyVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMChooseSizeGoodPropertyVC.h"
#import "PresentAnimationTransition.h"
#import "YFCollectionViewLayout.h"
#import <UIImageView+WebCache.h>
#import "NSString+Tool.h"
#import "WMGoodSizeCell.h"
#import "YFSteper.h"
#import "WMGoodSizeSectionHeadView.h"

@interface JHWMChooseSizeGoodPropertyVC ()<UIViewControllerTransitioningDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewLayoutDelegate,YFSteperDelegate>
@property(nonatomic,weak)UICollectionView *sizeCollectionView;
@property(nonatomic,weak)UICollectionView *propertyCollectionView;
@property(nonatomic,assign)NSInteger selecteIndexRow;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)YFSteper *steper;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIView *priceView;
@property(nonatomic,strong)NSMutableDictionary *propertyDic;
@property(nonatomic,copy)NSString *proprety_str;
@property(nonatomic,weak)UILabel *discountLab;// 折扣lab
@property(nonatomic,weak)UILabel *discountDesLab;// 限购lab
@end

@implementation JHWMChooseSizeGoodPropertyVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.good.is_specification) {
        for (NSDictionary *dic in self.good.specification) {
            NSString *key = dic[@"key"];
            self.propertyDic[key] = [dic[@"val"] firstObject];
        }
    }
    
    if (self.good.specs.count > 0) {
        // 默认选择规格
        [self collectionView:self.sizeCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selecteIndexRow inSection:0]];
    }else{
        [self reloadView];
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
        make.left.offset = 20;
        make.right.offset = -20;
        make.center.offset=0;
 
    }];
    backView.layer.cornerRadius=4;
    backView.clipsToBounds=YES;
    backView.backgroundColor = [UIColor whiteColor];
    self.backView = backView;
    
    UILabel *titleLab = [UILabel new];
    [backView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset=10;
        make.centerX.offset= 0;
        make.height.offset = 20;
    }];
    titleLab.font = FONT(16);
    titleLab.textColor = HEX(@"333333", 1.0);
    self.titleLab = titleLab;
    
    UIButton *closeBtn = [UIButton new];
    [backView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(titleLab.mas_centerY).offset=0;
        make.width.offset=30;
        make.height.offset=30;
    }];
    [closeBtn setImage:IMAGE(@"index_btn_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *discountLab = [UILabel new];
    [backView addSubview:discountLab];
    [discountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=20;
        make.top.equalTo(titleLab.mas_bottom).offset = 7;
        make.width.greaterThanOrEqualTo(@30);
        make.height.offset=16;
    }];
    discountLab.textColor = [UIColor whiteColor];
    discountLab.font = FONT(12);
    discountLab.backgroundColor = HEX(@"ff4848", 1.0);
    discountLab.layer.cornerRadius=4;
    discountLab.clipsToBounds=YES;
    self.discountLab = discountLab;
    
    UILabel *discountDesLab = [UILabel new];
    [backView addSubview:discountDesLab];
    [discountDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(discountLab.mas_right).offset=5;
        make.centerY.equalTo(discountLab.mas_centerY);
//        make.right.offset = 0;
        make.height.offset=20;
    }];
    discountDesLab.textColor = HEX(@"666666", 1.0);
    discountDesLab.lineBreakMode = NSLineBreakByTruncatingTail;
    discountDesLab.font = FONT(12);
    self.discountDesLab = discountDesLab;

    YFCollectionViewLayout * flowLayout=[[YFCollectionViewLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.lineItems = 4;
    flowLayout.interSpace = 0;
    flowLayout.delegate = self;
    
    UICollectionView *sizeCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,WIDTH,0) collectionViewLayout:flowLayout];
    sizeCollectionView.dataSource=self;
    sizeCollectionView.delegate=self;
    sizeCollectionView.backgroundColor = [UIColor whiteColor];
    [sizeCollectionView registerClass:[WMGoodSizeCell class] forCellWithReuseIdentifier:@"WMGoodSizeCell"];
    [sizeCollectionView registerClass:[WMGoodSizeSectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMGoodSizeSectionHeadView"];
    sizeCollectionView.showsVerticalScrollIndicator = NO;
    sizeCollectionView.showsHorizontalScrollIndicator = NO;
    [backView addSubview:sizeCollectionView];
    self.sizeCollectionView = sizeCollectionView;
    [sizeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(discountLab.mas_bottom).offset=10;
        make.right.offset=-10;
    }];

    YFCollectionViewLayout * flowLayout_2=[[YFCollectionViewLayout alloc] init];
    flowLayout_2.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout_2.lineItems = 4;
    flowLayout_2.interSpace = 0;
    flowLayout_2.delegate = self;
    
    UICollectionView *propertyCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,WIDTH,0) collectionViewLayout:flowLayout_2];
    propertyCollectionView.dataSource=self;
    propertyCollectionView.delegate=self;
    propertyCollectionView.backgroundColor = HEX(@"edf2f5", 1.0);
    [propertyCollectionView registerClass:[WMGoodSizeCell class] forCellWithReuseIdentifier:@"WMGoodSizeCell"];
    [propertyCollectionView registerClass:[WMGoodSizeSectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMGoodSizeSectionHeadView"];
    propertyCollectionView.showsVerticalScrollIndicator = NO;
    propertyCollectionView.showsHorizontalScrollIndicator = NO;
    [backView addSubview:propertyCollectionView];
    self.propertyCollectionView = propertyCollectionView;
    [propertyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(sizeCollectionView.mas_bottom).offset=0;
        make.right.offset=-10;
    }];
    
    UIView *priceView = [UIView new];
    [backView addSubview:priceView];
    priceView.backgroundColor = BACK_COLOR;
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=0;
        make.top.equalTo(propertyCollectionView.mas_bottom).offset= 10;
        make.right.offset=0;
        make.height.offset=50;
    }];
    self.priceView = priceView;

    UILabel *priceLab = [UILabel new];
    [priceView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    priceLab.textColor = HEX(@"999999", 1.0);
    priceLab.font =FONT(12);
    self.priceLab = priceLab;
    
    YFSteper *steper = [YFSteper new];
    [priceView addSubview:steper];
    [steper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(priceLab.mas_centerY).offset=0;
        make.width.offset=100;
        make.height.offset=40;
    }];
    steper.minCount = 0;
    steper.delegate = self;
    steper.subBtnImg = @"btn-num_subtraction";
    steper.addBtnImg = @"btn-num_addCart";
    self.steper = steper;

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  collectionView == self.sizeCollectionView ? 1 : self.good.specification.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.sizeCollectionView) {
        return  [self.good.specs count];
    }else{
        return [self.good.specification[section][@"val"] count];
    }
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMGoodSizeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMGoodSizeCell" forIndexPath:indexPath];
    
    if (collectionView == self.sizeCollectionView) {
        WMShopGoodSpecModel *spec = self.good.specs[indexPath.row];
        [cell reloadCellWith:spec.spec_name is_selected:NO];
    }else{
        cell.is_property = YES;
        NSDictionary *dic = self.good.specification[indexPath.section];
        NSString *str = dic[@"val"][indexPath.item];
        NSString *key = dic[@"key"];
        BOOL selected = [self.propertyDic[key] isEqualToString:str];
        [cell reloadCellWith:str is_selected:selected];
    }
    
    return cell;
    
}

#pragma mark ======YFCollectionViewLayoutDelegate=======
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH - 60)/4.0, 40);
}

-(CGSize)collectionViewSectionHeadSizeForSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 30);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    WMGoodSizeSectionHeadView *header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMGoodSizeSectionHeadView" forIndexPath:indexPath];
    NSString *title;
    if (collectionView == self.sizeCollectionView) {
        title = NSLocalizedString(@"规格",nil);
    }else{
        NSDictionary *dic = self.good.specification[indexPath.section];
        title = dic[@"key"];
    }
    
    [header reloadViewWith:title];
    return header;
    
}

#pragma mark ======YFSteperDelegate=======
-(void)addCount{
    if ( self.goodCountChange) {
        self.goodCountChange(YES);
        [self reloadView];
    }
}

-(void)subCount:(int)count{
    if ( self.goodCountChange) {
        self.goodCountChange(NO);
        [self reloadView];
    }
}

#pragma mark ====== Functions =======
// 选个不同的size
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.sizeCollectionView) {
        self.selecteIndexRow = indexPath.row;
        [self reloadView];
    }else{
        NSDictionary *dic = self.good.specification[indexPath.section];
        NSString *str = dic[@"val"][indexPath.item];
        NSString *key = dic[@"key"];
        self.propertyDic[key] = str;
        [self reloadView];
    }
    
}

// 刷新界面
-(void)reloadView{
    
    self.discountLab.hidden = !self.good.is_discount;
    self.discountDesLab.hidden = !self.good.is_discount;
    if (self.good.is_discount) {
        self.discountLab.text = self.good.disclabel;
        NSString *desStr = [NSString stringWithFormat: NSLocalizedString(@"%@  剩余%d份", NSStringFromClass([self class])),self.good.quotalabel,self.good.sale_sku];
        self.discountDesLab.attributedText = [NSString getAttributeString:desStr dealStr:self.good.quotalabel strAttributeDic:@{NSForegroundColorAttributeName: HEX(@"ff4848", 1.0)}];

        [self.discountLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom).offset=10;
        }];
    }else{

        [self.discountLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_top);
        }];
    }
    
    self.titleLab.text = self.good.title;
    self.good.choosed_proprety = self.proprety_str;
    NSLog(@"属性  %@",self.good.choosed_proprety);
    int count = 0;
    if (self.good.is_spec) {
        WMShopGoodSpecModel *spec = self.good.specs[self.selecteIndexRow];
        self.good.choosedSize_id = spec.spec_id;
        self.good.choosedSize_price = spec.price;
        self.good.choosedSize_photo = spec.spec_photo;
        self.good.choosedSize_Name = spec.spec_name;
        self.good.spec_package_price = spec.package_price;
        self.good.choosedSize_sale_ku = spec.sale_sku;
        
        self.good.quotalabel = spec.quotalabel;
        self.good.is_discount = spec.is_discount;
        self.good.disctype = spec.disctype;
        self.good.discval = spec.discval;
        self.good.oldprice = spec.oldprice;
//        self.good.price = spec.price;
        self.good.diffprice = spec.diffprice;
        self.good.disclabel = spec.disclabel;

        NSString *priceStr = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥", NSStringFromClass([self class])),spec.price];
        NSString *str = [NSString stringWithFormat:@"%@ (%@)", priceStr,spec.spec_name];
        NSAttributedString *attrStr = [NSString getAttributeString:str dealStr:spec.price strAttributeDic:@{NSFontAttributeName : FONT(16)}];
        attrStr = [NSString addAttributeString:attrStr dealStr:priceStr strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff8800", 1.0)}];
        self.priceLab.attributedText = attrStr;
        
        count = [[WMShopDBModel shareWMShopDBModel] getShopGoodChoosedCountFromDB:self.good.product_id choosedSize_id:spec.spec_id propretyStr:self.good.choosed_proprety good:_good];
        self.steper.maxCount = (_good.remain_count != 0 && count == 0)? spec.sale_sku :(_good.remain_count+ count);//_good.choosedSize_sale_ku
        
        CGSize size = [self.sizeCollectionView.collectionViewLayout collectionViewContentSize];
        [self.sizeCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = size.height + 10;
        }];
        [self.sizeCollectionView reloadData];
        
        // 选择规格
        [self.sizeCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selecteIndexRow inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }else{
        
        NSString *priceStr = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥", NSStringFromClass([self class])),self.good.price];
        NSString *str = priceStr;
        NSAttributedString *attrStr = [NSString getAttributeString:str dealStr:self.good.price strAttributeDic:@{NSFontAttributeName : FONT(16)}];
        attrStr = [NSString addAttributeString:attrStr dealStr:priceStr strAttributeDic:@{NSForegroundColorAttributeName : HEX(@"ff8800", 1.0)}];
        self.priceLab.attributedText = attrStr;
        
        [self.sizeCollectionView removeFromSuperview];
        self.sizeCollectionView = nil;
        count = [[WMShopDBModel shareWMShopDBModel] getShopGoodChoosedCountFromDB:self.good.product_id choosedSize_id:nil propretyStr:self.good.choosed_proprety good:_good];
        self.steper.maxCount = (_good.remain_count != 0 && count == 0) ? _good.sale_sku :(_good.remain_count+ count);
        
    }
    
    if (self.good.is_specification) {
        CGSize size2 = [self.propertyCollectionView.collectionViewLayout collectionViewContentSize];
        CGFloat height = size2.height > 300 ? 300 : size2.height;
        [self.propertyCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = height;
        }];
        
        [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.propertyCollectionView.mas_bottom).offset = 0;
        }];
        
        if (self.good.is_spec) {
            [self.propertyCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.sizeCollectionView.mas_bottom).offset = 0;
            }];
        }else{
            [self.propertyCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLab.mas_bottom).offset = 10;
            }];
        }
        [self.propertyCollectionView reloadData];
        
    }else{
        [self.propertyCollectionView removeFromSuperview];
        self.propertyCollectionView = nil;
        [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sizeCollectionView.mas_bottom).offset = 0;
        }];
    }
    
    self.good.good_choosedCount = count;
    self.steper.currentCount = count;
}

-(NSString *)proprety_str{
    if (self.good.is_specification) {
        
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *key_arr = [self.propertyDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
            return  [obj1 compare:obj2];
        }];
        for (NSString * key in key_arr) {
            NSString *str = [NSString stringWithFormat:@"%@:%@",key,self.propertyDic[key]];
            [arr addObject:str];
        }
        NSString *str = [arr componentsJoinedByString:@","];
        return str;
        
    }
    return @"";
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
    return [PresentAnimationTransition transitionWithTransitionType:YFPresentTransitionTypeShowHongBao];
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

#pragma mark ====== 懒加载 =======
-(NSMutableDictionary *)propertyDic{
    if (_propertyDic==nil) {
        _propertyDic=[[NSMutableDictionary alloc] init];
    }
    return _propertyDic;
}

@end
