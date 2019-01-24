//
//  KindItemCollectionView.m
//  LayoutTest
//
//  Created by ios_yangfei on 16/12/2.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "YFKindItemCollectionView.h"
#import "YFCollectionViewLayout.h"
#import "KindItemCell.h"
#import "YFPageControl.h"

@interface YFKindItemCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,YFCollectionViewLayoutDelegate>
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,strong)YFPageControl *pageControl;

@end

@implementation YFKindItemCollectionView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    YFCollectionViewLayout * layout = [[YFCollectionViewLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.interSpace = 0; // 每个item 的间隔
    layout.lineItems = 4;
    layout.delegate = self;
    _colOrLineItems = 4;

    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH , self.frame.size.height-10) collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[KindItemCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    CGFloat bottom_margin = -36;
    if (self.dataSource.count > self.colOrLineItems ) {
        bottom_margin = -10;
    }
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset = 0;
        make.bottom.offset = -36;
    }];
}

#pragma mark ====== UICollectionViewDataSource,UICollectionViewDelegate =======
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = NSClassFromString(self.cellClass);
    if ([class isSubclassOfClass:[UICollectionViewCell class]]) {
     
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if ([cell respondsToSelector:@selector(reloadCellWithDic:)]) {
            [cell performSelector:@selector(reloadCellWithDic:) withObject:self.dataSource[indexPath.item]];
        }

        return cell;
    }else{
        KindItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.textColor = _textColor;
        [cell reloadCellWithDic:self.dataSource[indexPath.item]];
        return cell;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickKindItem) {//点击事件的回调
        self.clickKindItem(indexPath.item);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollVie{
    NSInteger page = scrollVie.contentOffset.x/WIDTH;
    self.pageControl.currentPage = page;
}

#pragma mark ======YFCollectionViewLayoutDelegate=======
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    CGFloat width =  WIDTH/self.colOrLineItems;
    CGFloat height = self.dataSource.count > self.colOrLineItems ? (self.height-36)/2.0 : (self.height-12);
    return CGSizeMake(width, height);
}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.collectionView reloadData];
    if (dataSource.count <= self.colOrLineItems * 2 && _pageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    [self pageControl];
}
#pragma mark -- 当按钮超过八个时需要pageControl
-(YFPageControl *)pageControl{
    if (!_pageControl && _dataSource.count > self.colOrLineItems * 2) {
        _pageControl = [[YFPageControl alloc]initWithFrame:FRAME(0, self.frame.size.height-36, WIDTH, 36)];
        _pageControl.currentPageIndicatorTintColor = HEX(@"73e966", 1.0);
        _pageControl.pageIndicatorTintColor = HEX(@"cccccc", 1);
        if (self.dataSource.count % (self.colOrLineItems * 2) == 0) {
            _pageControl.numberOfPages = _dataSource.count/(self.colOrLineItems * 2);
        }else{
            _pageControl.numberOfPages = _dataSource.count/(self.colOrLineItems * 2 ) + 1;
        }
        [self addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset= -10;
            make.centerX.offset=0;
            make.width.offset=WIDTH;
            make.height.offset=10;
        }];
        _pageControl.dotHeight = 5;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

-(void)setColOrLineItems:(int)colOrLineItems{
    _colOrLineItems = colOrLineItems;
    YFCollectionViewLayout *layout = (YFCollectionViewLayout *) self.collectionView.collectionViewLayout;
    layout.lineItems = colOrLineItems;
    [self.collectionView reloadData];
}

-(void)setCellClass:(NSString *)cellClass{
    _cellClass = cellClass;
   
    Class class = NSClassFromString(cellClass);
    if ([class isSubclassOfClass:[UICollectionViewCell class]]) {
        [self.collectionView registerClass:class forCellWithReuseIdentifier:@"cell"];
        [self.collectionView reloadData];
    }
}
- (void)setTextColor:(NSString *)textColor{
    _textColor = textColor;
}
@end
