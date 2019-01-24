//
//  HistorySearchView.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "HistorySearchView.h"
#import "YFCollectionViewAutoFlowLayout.h"
#import "YFCollectionReusableView.h"
#import "SearchCollectionViewCell.h"

@interface HistorySearchView ()<UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewAutoFlowLayoutDelegate>

@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *hotDataSource;
@property(nonatomic,strong)NSMutableArray *historyDataSource;

@end


@implementation HistorySearchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
 
    YFCollectionViewAutoFlowLayout * flowLayout=[[YFCollectionViewAutoFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.delegate = self;
    flowLayout.interSpace = 8;
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = self.backgroundColor;
    [collectionView registerClass:[YFCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"YFCollectionReusableView"];
    [collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"YFCollectionViewAutoFlowLayoutCell"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    self.collectionView =collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.bottom.offset=0;
    }];

    self.hotDataSource = [NSMutableArray array];
    self.historyDataSource = [NSMutableArray array];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.historyDataSource.count == 0) return 1;
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.historyDataSource.count == 0) return self.hotDataSource.count;
    return  section == 0 ? self.historyDataSource.count : self.hotDataSource.count;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFCollectionViewAutoFlowLayoutCell" forIndexPath:indexPath];
    
    NSString *title = @"";
    if (indexPath.section == 0) {
        if (self.historyDataSource.count == 0)
            title = self.hotDataSource[indexPath.item];
        else
            title = self.historyDataSource[indexPath.item];
    }else{
        title = self.hotDataSource[indexPath.item];
    }
    
    [cell reloadCellWith:title];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = @"";
    if (indexPath.section == 0) {
        if (self.historyDataSource.count == 0)
            title = self.hotDataSource[indexPath.item];
        else
            title = self.historyDataSource[indexPath.item];
    }else{
        title = self.hotDataSource[indexPath.item];
    }
    if (self.clickTitle) {
        self.clickTitle(title);
    }
}

#pragma mark - 返回头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    YFCollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFCollectionReusableView" forIndexPath:indexPath];
    NSString *text;
    NSString *img;
    if (indexPath.section==0 && self.historyDataSource.count > 0) {
        text = NSLocalizedString(@"历史搜索", @"HistorySearchView");
        img = @"index_icon_searchHistory";
        
    }else{
        text = NSLocalizedString(@"热门搜索", @"HistorySearchView");
        img = @"index_icon_searchHot";
    }
    header.titleStr = text;
    header.titleImg = img;
    header.hidden_delete = ![text isEqualToString:NSLocalizedString(@"历史搜索", @"HistorySearchView")];
     __weak typeof(self) weakSelf=self;
    header.deleteHistory = ^(){
        [weakSelf clearSearchHistory];
    };
    header.backgroundColor = [UIColor whiteColor];
    return header;
}

#pragma mark ====== YFCollectionViewAutoFlowLayoutDelegate =======
-(CGSize)collectionViewItemSizeForIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = @"";
    if (indexPath.section == 0) {
        if (self.historyDataSource.count == 0)
            str = self.hotDataSource[indexPath.item];
        else
            str = self.historyDataSource[indexPath.item];
    }else{
        str = self.hotDataSource[indexPath.item];
    }
    
    CGSize size = getSize(str, 20, 14);
    return CGSizeMake(size.width+20, 40);
}

-(CGSize)collectionViewSectionHeadSizeForSection:(NSInteger)section{
    return CGSizeMake(40, 40);
}

-(NSMutableArray *)hotDataSource{
    if (_hotDataSource==nil) {
        _hotDataSource=[[NSMutableArray alloc] init];
    }
    return _hotDataSource;
}

-(NSMutableArray *)historyDataSource{
    if (_historyDataSource==nil) {
        _historyDataSource=[[NSMutableArray alloc] init];
    }
    return _historyDataSource;
}

-(void)getData{
    
    [self.historyDataSource removeAllObjects];
    NSArray * arr = [[NSUserDefaults standardUserDefaults] objectForKey:self.historyCashDataFilePath];
    if (arr != nil) {
        [self.historyDataSource addObjectsFromArray:arr];
        [self.collectionView reloadData];
    }
}

-(void)searchHistoryAddStr:(NSString *)str{
    
    if (str.length == 0) {
        return;
    }
    if ([self.historyDataSource containsObject:str]) {
        [self.historyDataSource removeObject:str];
    }

    [self.historyDataSource insertObject:str atIndex:0];
    
    if (self.historyDataSource.count > 10) {
        [self.historyDataSource removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.historyDataSource forKey:self.historyCashDataFilePath];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.collectionView reloadData];
}

-(void)clearSearchHistory{
    [self.historyDataSource removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyDataSource forKey:self.historyCashDataFilePath];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.collectionView reloadData];
}

-(void)setHistoryCashDataFilePath:(NSString *)historyCashDataFilePath{
   
    if (!historyCashDataFilePath) {
        _historyCashDataFilePath = @"";
    }
     _historyCashDataFilePath = historyCashDataFilePath;
    [self getData];
}

-(void)setHotSearchUrl:(NSString *)hotSearchUrl{
    if (hotSearchUrl.length == 0) {
        return;
    }
    [HttpTool postWithAPI:hotSearchUrl withParams:@{} success:^(id json) {
        if (ISPostSuccess) {
            [self.hotDataSource removeAllObjects];
            [self.hotDataSource addObjectsFromArray:json[@"data"][@"hots"]];
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
