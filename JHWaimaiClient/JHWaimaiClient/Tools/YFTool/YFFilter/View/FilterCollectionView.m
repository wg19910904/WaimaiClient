//
//  FilterCollectionView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "FilterCollectionView.h"
#import "FilterCollectionCell.h"
#import "FilterCollectionHeaderView.h"
#import "YFCollectionViewLayout.h"

@interface FilterCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewLayoutDelegate>
@property(nonatomic,weak)UICollectionView *firstCollectionView;
@property(nonatomic,weak)UICollectionView *secondCollectionView;
@property(nonatomic,weak)UICollectionView *thirdCollectionView;
// 记录上次选中的item
@property(nonatomic,assign)NSInteger firstSelectedItem;
@property(nonatomic,assign)NSInteger secondSelectedItem;
@property(nonatomic,assign)NSInteger thirdSelectedItem;
// 记录未点击确定之前的选择
@property(nonatomic,assign)NSInteger firstWillSelectedItem;
@property(nonatomic,assign)NSInteger secondWillSelectedItem;
@property(nonatomic,assign)NSInteger thirdWillSelectedItem;

@end

@implementation FilterCollectionView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    self.backgroundColor = [UIColor whiteColor];
    for (int i=0; i<3; i++) {
        YFCollectionViewLayout * flowLayout=[[YFCollectionViewLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.lineItems = 3;
        flowLayout.interSpace = 0;
        flowLayout.delegate = self;
        
        [self createCollectionViewWithLayout:flowLayout index:i];
    }
    
    [self.firstCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.secondCollectionView.mas_top).offset=0;
    }];
    [self.secondCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.thirdCollectionView.mas_top).offset=0;
    }];
    [self.thirdCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondCollectionView.mas_bottom).offset=0;
    }];
    
    UIButton *clearBtn = [UIButton new];
    [self addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.bottom.offset=0;
        make.width.offset = WIDTH/2;
        make.height.offset = 48;
    }];
    clearBtn.titleLabel.font = FONT(16);
    [clearBtn setTitle:NSLocalizedString(@"清空", nil) forState:UIControlStateNormal];
    [clearBtn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clickClear) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureBtn = [UIButton new];
    [self addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.width.offset=WIDTH/2;
        make.height.offset = 48;
        make.bottom.offset=0;
    }];
    sureBtn.titleLabel.font = FONT(16);
    sureBtn.backgroundColor = THEME_COLOR_Alpha(1.0);
    [sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    
    self.firstSelectedItem = 0;
    self.secondSelectedItem = -1;
    self.thirdSelectedItem = -1;
    
    [self clickClear];
}

// 创建CollectionViews
-(void)createCollectionViewWithLayout:(YFCollectionViewLayout *)flowLayout index:(int)index{
    flowLayout.interSpace = 10;
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,WIDTH,0) collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[FilterCollectionCell class] forCellWithReuseIdentifier:@"FilterCollectionCell"];
    [collectionView registerClass:[FilterCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterCollectionHeaderView"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:collectionView];
    collectionView.scrollEnabled = NO;
     __weak typeof(self) weakSelf=self;
    if (index == 0) {
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=16;
            make.top.offset=10;
            make.right.offset=-16;
        }];
        self.firstCollectionView = collectionView;
        
    }else if (index == 1){
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=16;
            make.top.equalTo(weakSelf.firstCollectionView.mas_bottom).offset=0;
            make.right.offset=-16;
        }];
        self.secondCollectionView = collectionView;
    }else{
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=16;
            make.top.equalTo(weakSelf.secondCollectionView.mas_bottom).offset=0;
            make.right.offset=-16;
            make.bottom.offset = -40;
        }];
        self.thirdCollectionView = collectionView;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.firstCollectionView) {
        return self.firstArr.count;
    }else if (collectionView == self.secondCollectionView){
        return self.secondArr.count;
    }else{
        return self.thirdArr.count;
    }
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCollectionCell" forIndexPath:indexPath];
    
    NSString *str = @"";
    if (collectionView == self.firstCollectionView) {
        str = self.firstArr[indexPath.item];
    }else if (collectionView == self.secondCollectionView){
        str = self.secondArr[indexPath.item];
    }else{
        str = self.thirdArr[indexPath.item];
    }
    [cell reloadCellWithTitle:str];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    FilterCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterCollectionHeaderView" forIndexPath:indexPath];
    NSString *title = @"";
    if (collectionView == self.firstCollectionView) {
        title = NSLocalizedString(@"配送方式", nil);
    }else if (collectionView == self.secondCollectionView){
        title = NSLocalizedString(@"优惠信息", nil);
    }else{
        title = NSLocalizedString(@"商家特色", nil);
    }
    [header reloadViewWithTitle:title];
    return header;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.firstCollectionView) {
        self.firstWillSelectedItem = indexPath.item;
    }else if (collectionView == self.secondCollectionView){
        self.secondWillSelectedItem = indexPath.item;
    }else{
        self.thirdWillSelectedItem = indexPath.item;
    }
}


#pragma mark ======YFCollectionViewLayoutDelegate=======
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH-48)/3.0, 40);
}

-(CGSize)collectionViewSectionHeadSizeForSection:(NSInteger)section{
    return CGSizeMake(WIDTH-32, 44);
}

#pragma mark ======Functions=======
// 点击清空
-(void)clickClear{
    
    self.firstWillSelectedItem = 0;
    self.secondWillSelectedItem = -1;
    self.thirdWillSelectedItem = -1;

    if (self.firstArr.count > 0) {
        [self.firstCollectionView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.firstCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    [self.secondCollectionView reloadData];
    [self.thirdCollectionView reloadData];

}

// 点击确定
-(void)clickSure{
    
    self.firstSelectedItem = self.firstWillSelectedItem;
    self.secondSelectedItem = self.secondWillSelectedItem;
    self.thirdSelectedItem = self.thirdWillSelectedItem;
   
    if (self.chooseBlock) {
        self.chooseBlock(self.firstSelectedItem,self.secondSelectedItem,self.thirdSelectedItem);
    }
    
}

// 刷新CollectionView
-(void)reloadCollectionViews{
    if (self.firstArr.count > 0 && self.firstSelectedItem > -1) {
        [self.firstCollectionView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.firstSelectedItem inSection:0];
        [self.firstCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    if (self.secondArr.count > 0 && self.secondSelectedItem > -1) {
        [self.secondCollectionView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.secondSelectedItem inSection:0];
        [self.secondCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    if (self.thirdArr.count > 0 && self.thirdSelectedItem > -1) {
        [self.thirdCollectionView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.thirdSelectedItem inSection:0];
        [self.thirdCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
}

#pragma mark ======Setter=======
-(void)setFirstArr:(NSArray *)firstArr{
    
    _firstArr = firstArr;
    [self.firstCollectionView reloadData];
    [self layoutIfNeeded];
    
}

-(void)setSecondArr:(NSArray *)secondArr{
    
    _secondArr = secondArr;
    [self.secondCollectionView reloadData];
    [self layoutIfNeeded];

}

-(void)setThirdArr:(NSArray *)thirdArr{
    
    _thirdArr = thirdArr;
    [self.thirdCollectionView reloadData];
    [self layoutIfNeeded];
    
}

-(void)setHeight:(CGFloat)height{
    
    CGFloat h = self.firstCollectionView.contentSize.height + self.secondCollectionView.contentSize.height + self.thirdCollectionView.contentSize.height + 50;
    height =  height == 0 ? height : h;
    
    if (height == 0) {
        [self.firstCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
        }];
        [self.secondCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
        }];
        [self.thirdCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
        }];
    }else{
        [self.firstCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = self.firstCollectionView.contentSize.height;
        }];
        [self.secondCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = self.secondCollectionView.contentSize.height;
        }];
        [self.thirdCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = self.thirdCollectionView.contentSize.height;
        }];
    }
    self.frame = CGRectMake(self.x, self.y, self.width, height);
    
    [self layoutIfNeeded];
}

@end
