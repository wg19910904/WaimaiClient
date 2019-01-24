//
//  JHHomeSearchResultShopHeaderView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/26.
//  Copyright © 2018年 xixixi. All rights reserved.
//

// CollectionViewCell
@interface YouHuiCollectionCell : UICollectionViewCell
@property(nonatomic,weak)UILabel *titleLab;
@end

@implementation YouHuiCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    titleLab.textColor = HEX(@"FB564D", 1.0);
    titleLab.font = FONT(10);
    titleLab.layer.borderColor=HEX(@"FB564D", 1.0).CGColor;
    titleLab.layer.borderWidth=0.5;
    titleLab.layer.cornerRadius=4;
    titleLab.clipsToBounds=YES;
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab = titleLab;
}

@end


#import "JHHomeSearchResultShopHeaderView.h"
#import "YFCollectionViewAutoFlowLayout.h"
#import <UIImageView+WebCache.h>

@interface JHHomeSearchResultShopHeaderView ()<YFCollectionViewAutoFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSArray *colorSource;
@property(nonatomic,strong)UILabel *restL;
@property(nonatomic,weak)UILabel *tipLab;
@end

@implementation JHHomeSearchResultShopHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
   
        
        UIImageView *iconImgView = [UIImageView new];
        [self.contentView addSubview:iconImgView];
        [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(12);
            make.top.offset(16);
            make.width.height.offset(44);
        }];
        iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        iconImgView.clipsToBounds = YES;
        self.iconImgView = iconImgView;
        //
        UILabel *restL = [UILabel new];
        [_iconImgView addSubview:restL];
        [restL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset = 0;
            make.height.offset = 14;
        }];
        restL.font = FONT(10);
        restL.text = NSLocalizedString(@"已打烊", nil);
        restL.textAlignment = NSTextAlignmentCenter;
        restL.backgroundColor = HEX(@"000000", 0.5);
        restL.textColor = UIColor.whiteColor;
        restL.hidden = YES;
        self.restL = restL;
        
        //
        YFCollectionViewAutoFlowLayout * flowLayout=[[YFCollectionViewAutoFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.interSpace = 8;
        flowLayout.delegate = self;
        
        UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,100,0) collectionViewLayout:flowLayout];
        collectionView.dataSource=self;
        collectionView.delegate=self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[YouHuiCollectionCell class] forCellWithReuseIdentifier:@"YouHuiCollectionCell"];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.scrollEnabled = NO;
        [self.contentView addSubview:collectionView];
        self.collectionView = collectionView;
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImgView.mas_right).offset=0;
            make.bottom.offset=-7;
            make.right.offset=-10;
            make.height.offset=30;
        }];
        
        UILabel *titleLab = [UILabel new];
        [self.contentView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImgView.mas_right).offset(8);
            make.top.equalTo(iconImgView.mas_top).offset(0);
            make.right.offset(-10);
            make.height.offset(22);
        }];
        titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLab.font = FONT(16);
        titleLab.textColor = HEX(@"333333", 1.0);
        self.titleLab = titleLab;
        
        UILabel *tipLab = [UILabel new];
        [self.contentView addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLab.mas_left);
            make.top.equalTo(titleLab.mas_bottom).offset(7);
            make.height.offset = 0;
            make.width.mas_lessThanOrEqualTo(WIDTH-130);
        }];
        tipLab.backgroundColor = HEX(@"4DBD4D", 1.0);
        tipLab.layer.cornerRadius = 2;
        tipLab.layer.masksToBounds = YES;
        tipLab.font = FONT(11);
        tipLab.textColor = HEX(@"ffffff", 1.0);
        tipLab.textAlignment = NSTextAlignmentCenter;
        self.tipLab = tipLab;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderView)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YouHuiCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YouHuiCollectionCell" forIndexPath:indexPath];
    cell.titleLab.text = self.dataSource[indexPath.item];
    cell.titleLab.textColor = HEX(self.colorSource[indexPath.item], 1);
    cell.titleLab.layer.borderColor = HEX(self.colorSource[indexPath.item], 1).CGColor;
    return cell;
}


#pragma mark ====== YFCollectionViewAutoFlowLayoutDelegate =======
/**
 *  每个item的尺寸
 *
 *  @param indexPath 所在的分组
 *
 *  @return item的尺寸
 */
-(CGSize)collectionViewItemSizeForIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"";
    str = self.dataSource[indexPath.item];
    CGSize size = getSize(str, 16, 14);
    return CGSizeMake(size.width, 16);
}


/**
 每个section的headerView的大小
 
 @param section 分区
 @return 返回section的headerView的大小
 */
-(CGSize)collectionViewSectionHeadSizeForSection:(NSInteger)section{
    return CGSizeZero;
}


-(void)reloadViewWith:(WMShopModel *)shop withStr:(NSString *)str withColor:colorStr{
    self.titleLab.text = shop.title;//shop.title;
    NSRange range = [shop.title rangeOfString:str];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:shop.title];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEX(colorStr, 1) range:range];
    self.titleLab.attributedText = attStr;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(shop.logo)] placeholderImage:IMAGE(@"logo_shop60_default")];
    NSMutableArray *daSource = @[].mutableCopy;
    NSMutableArray *tempcolorSource = @[].mutableCopy;
    for (NSDictionary *dic in shop.huodong) {
        [daSource addObject:dic[@"title"]];
        [tempcolorSource addObject:dic[@"color"]];
    }
    self.colorSource = tempcolorSource;
    self.dataSource = daSource;
    self.restL.hidden = shop.yyst.integerValue == 1;
    
    NSString *tipStr = shop.tips_label;
    self.tipLab.text = tipStr;
    if (tipStr.length != 0) {
        CGFloat width_str = getSize(tipStr, 18, 13).width;
        [self.tipLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 18;
            make.width.offset = width_str;
        }];
    }
}

-(void)clickHeaderView{
    YF_SAFE_BLOCK(self.clickHeaderBlock,YES,@"");
}

@end
