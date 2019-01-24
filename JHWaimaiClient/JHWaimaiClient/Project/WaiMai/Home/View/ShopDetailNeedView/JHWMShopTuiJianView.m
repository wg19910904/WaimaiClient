//
//  JHWMShopTuiJianView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/8/3.
//  Copyright © 2018年 xixixi. All rights reserved.
//
#import "JHWMShopTuiJianView.h"

#import <UIImageView+WebCache.h>
#import "YFSteper.h"
#import "WMShopGoodModel.h"
#import "NSString+Tool.h"

@interface JHWMShopTuiJianGoodCell : UICollectionViewCell<YFSteperDelegate>
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)YFSteper *steper;
@property(nonatomic,weak)UIButton *selectedTypeBtn;
@property(nonatomic,weak)UILabel *guiCountLab;// 规格商品选择的总数
@property(nonatomic,copy)NSString *good_id;
@property(nonatomic,strong)WMShopGoodModel *tj_good;
@property(nonatomic,copy)GoodCountChangeBlock changeBlock;

-(void)reloadCellWith:(WMShopGoodModel *)good;
@end

@implementation JHWMShopTuiJianGoodCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius=4;
    self.contentView.clipsToBounds=YES;
    
    UIImageView *iconImgView = [UIImageView new];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.width.height.offset(120);
    }];
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.layer.cornerRadius=2;
    iconImgView.clipsToBounds=YES;
    self.iconImgView = iconImgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(4);
        make.top.equalTo(iconImgView.mas_bottom).offset(6);
        make.right.offset(-4);
        make.height.offset(20);
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"666666", 1.0);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLab = titleLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.equalTo(titleLab.mas_bottom).offset(6);
        make.height.offset(24);
    }];
    priceLab.font = FONT(14);
    priceLab.textColor = HEX(@"FA4C34", 1.0);
    self.priceLab = priceLab;
    
    YFSteper *steper = [YFSteper new];
    [self.contentView addSubview:steper];
    [steper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(priceLab.mas_centerY).offset=0;
        make.width.offset=80;
        make.height.offset=30;
    }];
    steper.minCount = 0;
    steper.delegate = self;
    steper.subBtnImg = @"btn-num_subtraction";
    steper.addBtnImg = @"btn-num_addCart";
    self.steper = steper;
    
    UIButton *selectedTypeBtn = [UIButton new];
    [self.contentView addSubview:selectedTypeBtn];
    [selectedTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(steper.mas_centerY);
        make.width.offset=22;
        make.height.offset=22;
    }];
    selectedTypeBtn.titleLabel.font = FONT(11);
    selectedTypeBtn.layer.cornerRadius=11;
    selectedTypeBtn.clipsToBounds=YES;
    selectedTypeBtn.hidden = YES;
    [selectedTypeBtn setTitle:NSLocalizedString(@"选", @"WMShopGoodCell") forState:UIControlStateNormal];
    [selectedTypeBtn addTarget:self action:@selector(chooseGoodType) forControlEvents:UIControlEventTouchUpInside];
    self.selectedTypeBtn = selectedTypeBtn;
    
    UILabel *guiCountLab = [UILabel new];
    [self.contentView addSubview:guiCountLab];
    [guiCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selectedTypeBtn.mas_right).offset=5;
        make.top.equalTo(selectedTypeBtn.mas_top).offset=-5;
        make.height.offset = 10;
        make.width.greaterThanOrEqualTo(@18);
    }];
    guiCountLab.backgroundColor = HEX(@"ff2200", 1.0);
    guiCountLab.textColor = [UIColor whiteColor];
    guiCountLab.layer.cornerRadius=5;
    guiCountLab.font = FONT(10);
    guiCountLab.textAlignment = NSTextAlignmentCenter;
    guiCountLab.hidden = YES;
    guiCountLab.clipsToBounds=YES;
    
    self.guiCountLab = guiCountLab;
    
}

-(void)reloadCellWith:(WMShopGoodModel *)model{
    _tj_good = model;
    self.titleLab.text = model.title;
    self.priceLab.attributedText = [NSString priceLabText:model.price attributeFont:20];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(model.photo)] placeholderImage:IMAGE(@"product60_default")];
    
    self.steper.hidden = model.is_spec || model.is_specification;
    self.selectedTypeBtn.hidden = !model.is_spec && !model.is_specification;
    
    self.good_id = model.product_id;
    int count = [[WMShopDBModel shareWMShopDBModel] getShopGoodChoosedCountFromDB:model.product_id choosedSize_id:nil propretyStr:nil good:model];
    if (model.is_spec) {// 规格商品
        self.guiCountLab.text = [NSString stringWithFormat:@"%d",count];
        self.guiCountLab.hidden = count == 0 ? YES : NO;
        for (WMShopGoodSpecModel *spec in model.specs) {
            if ([model.choosedSize_id isEqualToString:spec.spec_id]) {
                self.steper.maxCount = spec.sale_sku;
            }
        }
    }else if (model.is_specification) {// 非规格商品但是属性商品
        self.guiCountLab.text = [NSString stringWithFormat:@"%d",count];
        self.guiCountLab.hidden = count == 0 ? YES : NO;
        self.steper.maxCount = count == 0 ? model.sale_sku :(model.remain_count+ count);//model.sale_sku;
    }else{// 普通商品
        self.steper.maxCount = count == 0 ? model.sale_sku :(model.remain_count+ count);//model.sale_sku;
        self.steper.currentCount = count;
        self.guiCountLab.hidden = YES;
    }
    
    if (model.sale_sku == 0) {
        self.steper.hidden = YES;
        self.selectedTypeBtn.hidden = NO;
        self.selectedTypeBtn.userInteractionEnabled = NO;
        self.selectedTypeBtn.backgroundColor = LINE_COLOR;
    }else{
        self.selectedTypeBtn.userInteractionEnabled = YES;
        self.selectedTypeBtn.backgroundColor = HEX(@"4DC831", 1.0);
        
    }
}

#pragma mark ======YFSteperDelegate=======
-(void)addCount{
    if (self.changeBlock) {
        self.changeBlock(_tj_good, YES);
    }
}

-(void)subCount:(int)count{
    if (self.changeBlock) {
        self.changeBlock(_tj_good, NO);
    }
}
// 选择规格
-(void)chooseGoodType{
    if (self.changeBlock) {
        self.changeBlock(_tj_good, NO);
    }
}

@end


#import "YFCollectionViewLayout.h"
@interface JHWMShopTuiJianView ()<YFCollectionViewLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation JHWMShopTuiJianView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.height.offset(20);
    }];
    titleLab.text =  NSLocalizedString(@"店铺招牌", NSStringFromClass([self class]));
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"333333", 1.0);
    
    YFCollectionViewLayout * flowLayout=[[YFCollectionViewLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.lineItems = 10000;
    flowLayout.interSpace = 10;
    flowLayout.delegate = self;
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,WIDTH,0) collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = BACK_COLOR;
    [collectionView registerClass:[JHWMShopTuiJianGoodCell class] forCellWithReuseIdentifier:@"JHWMShopTuiJianGoodCell"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=40;
        make.right.offset=0;
        make.height.offset=180;
        make.bottom.offset=0;
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHWMShopTuiJianGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHWMShopTuiJianGoodCell" forIndexPath:indexPath];
    cell.changeBlock = self.goodCountChangeBlock;
    [cell reloadCellWith:self.dataSource[indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WMShopGoodModel *good = self.dataSource[indexPath.item];
    if (self.goShopDetailBlock) {
        self.goShopDetailBlock(good, nil);
    }
}

-(void)reloadViewWithGoodArr:(NSArray *)goodArr{
    self.dataSource = goodArr;
    [self.collectionView reloadData];
}

#pragma mark ====== YFCollectionViewLayoutDelegate =======
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(120, 180);
}

@end

