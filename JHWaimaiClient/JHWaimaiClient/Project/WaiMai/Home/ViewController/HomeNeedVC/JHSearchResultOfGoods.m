//
//  JHSearchResultOfGoods.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHSearchResultOfGoods.h"
#import "YFCollectionViewLayout.h"
#import "MaybeLikeCollectionCell.h"


@interface JHSearchResultOfGoods ()<UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewLayoutDelegate>
@property(nonatomic,assign)int page;
@property(nonatomic,copy)NSString *keyword;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation JHSearchResultOfGoods

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    self.page = 1;
    
}

-(void)setUpView{

    YFCollectionViewLayout * flowLayout=[[YFCollectionViewLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.lineItems = 2;
    flowLayout.interSpace = 5;
    flowLayout.delegate = self;
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,WIDTH,HEIGHT-NAVI_HEIGHT-40) collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = BACK_COLOR;
    [collectionView registerClass:[MaybeLikeCollectionCell class] forCellWithReuseIdentifier:@"MaybeLikeCollectionCell"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    
    __weak typeof(self) weakSelf=self;
    //--下拉加载
    [collectionView bindHeadRefreshHandler:^{
        weakSelf.page=1;
        [weakSelf getData];
    }];
    //--上拉加载
    [collectionView bindFootRefreshHandler:^{
        weakSelf.page++;
        [weakSelf getData];
    }];
    //---
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource.count == 0) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr:@"" btnTitle:nil inView:collectionView];
    }else{
        [self hiddenEmptyView];
    }
    return self.dataSource.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MaybeLikeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MaybeLikeCollectionCell" forIndexPath:indexPath];
    MaybeLikeGood *good = self.dataSource[indexPath.item];
    [cell reloadCellWithModel:good showCount:YES];
    return cell;
}

#pragma mark ======YFCollectionViewLayoutDelegate=======
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH -5)/2, 270);
}


#pragma mark ======Functions=======
// 点击不同商品
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MaybeLikeGood *good = self.dataSource[indexPath.item];
    [self goShopDetail:good.shop_id good_id:good.product_id];
}

// 前往商家详情界面
-(void)goShopDetail:(NSString *)shop_id good_id:(NSString *)good_id{
    JHBaseVC *vc = [NSClassFromString(@"JHWaiMaiShopDetailVC") new];
    [vc setValue:shop_id forKey:@"shop_id"];
    [vc setValue:good_id forKey:@"good_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

// 根据搜索关键词搜索内容
-(void)getDataWithKeyword:(NSString *)keyword{
    self.page = 1;
    self.keyword = keyword;
    [self getData];
}

// 获取数据
-(void)getData{
    SHOW_HUD

    [MaybeLikeGood searchWMProductsListWithKW:self.keyword page:self.page block:^(NSArray *arr, NSString *msg) {
        HIDE_HUD
        
        [self.collectionView endRefresh];
        if (arr.count != 0) {
            [self.historySearchView searchHistoryAddStr:self.keyword];
        }
        if (arr) {
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:arr];
            }else{
                if (arr.count == 0) {
                    [self showHaveNoMoreData];
                }else {
                    [self.dataSource addObjectsFromArray:arr];
                }
            }
            [self.collectionView reloadData];
        }else [self showToastAlertMessageWithTitle:msg];
    }];
    
}

#pragma mark ====== 懒加载 =======
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end
