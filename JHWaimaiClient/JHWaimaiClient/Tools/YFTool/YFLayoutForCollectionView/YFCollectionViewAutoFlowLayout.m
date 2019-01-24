//
//  YFCollectionViewLayout.m
//  LayoutTest
//
//  Created by ios_yangfei on 16/11/23.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "YFCollectionViewAutoFlowLayout.h"

//#define LimeItems 4

@interface YFCollectionViewAutoFlowLayout ()

// 宽度数组
@property(nonatomic,strong)NSMutableArray *widthArr;
// 每个cell的 UICollectionViewLayoutAttributes
@property(nonatomic,strong)NSMutableArray *attributeArray;

@end

@implementation YFCollectionViewAutoFlowLayout

- (void)setInterSpace:(CGFloat)interSpace {
    if (_interSpace != interSpace) {
        _interSpace = interSpace;
        [self invalidateLayout];
    }
}

-(void)prepareLayout{
    [super prepareLayout];
    
    //清空数组赋初值
    [self.widthArr removeAllObjects];
    [self.attributeArray removeAllObjects];
    
    NSInteger totalSections = [self.collectionView numberOfSections];
    
    for (NSInteger i=0; i<totalSections; i++) {
        NSMutableArray *arr = [NSMutableArray array];
         [arr addObject:@(_interSpace)];
        [self.widthArr addObject:arr];
    }

    for (NSInteger i=0; i<totalSections; i++) {

        //拿到每个分区所有item的个数
        NSInteger totalItems = [self.collectionView numberOfItemsInSection:i];
        
        // 每个分区item的高度
        CGFloat itemH = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(collectionViewItemSizeForIndexPath:)] && totalItems > 0) {
            itemH = [_delegate collectionViewItemSizeForIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]].height;
        }
        
        // 每个分区section的高度
        CGFloat sectionH = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(collectionViewSectionHeadSizeForSection:)]) {
            sectionH = [_delegate collectionViewSectionHeadSizeForSection:i].height;
        }
        
        // 每个分区section的y值
        CGFloat sectionY = [self getSectionY:i];
//        for (NSInteger section = 0; section < i; section++) {
//            sectionY += sectionH + [_widthArr[section] count] * ( itemH + _interSpace) + _interSpace;
//        }
        
        // 每个分区section的attribute
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        attribute.frame = CGRectMake(0, sectionY,self.collectionView.frame.size.width, sectionH);
        [self.attributeArray addObject:attribute];
        
        for (NSInteger j=0; j<totalItems; j++) {
            
            CGSize itemSize = CGSizeZero;
            //获取每一个item的size
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            if (_delegate && [_delegate respondsToSelector:@selector(collectionViewItemSizeForIndexPath:)]) {
                itemSize = [_delegate collectionViewItemSizeForIndexPath:indexPath];
            }
            
            //获取width最小的行
            NSInteger currentCol = [self minCurrentLineWithSection:i];
            CGFloat yPos = (itemH + _interSpace) * currentCol + _interSpace + sectionY + sectionH;
            CGFloat xPos = [_widthArr[i][currentCol] floatValue];
            
            // 如果新的宽度大于屏幕的宽度则新起一行
            if (xPos + itemSize.width + _interSpace > self.collectionView.frame.size.width) {
                [_widthArr[i] addObject:@(_interSpace)];
                //获取width最小的行
                currentCol = [self minCurrentLineWithSection:i];
                xPos = _interSpace;
                yPos = (itemH + _interSpace) * currentCol + _interSpace + sectionY + sectionH;
            }
            
            CGRect frame = CGRectMake(xPos, yPos, itemSize.width, itemH);
            
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attribute.frame = frame;
            
            [self.attributeArray addObject:attribute];
            //更新最小行的宽度
            CGFloat upDateX = [_widthArr[i][currentCol]  floatValue] + itemSize.width + _interSpace;
            _widthArr[i][currentCol] = @(upDateX);
            
        }
    }
}

#pragma mark ====== 获取竖直方向滑动时的每个分区的y值 =======
-(CGFloat)getSectionY:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    
    CGFloat y = 0;
    
    for (NSInteger i=0; i<section; i++) {
        
        //拿到每个分区所有item的个数
        NSInteger totalItems = [self.collectionView numberOfItemsInSection:i];
        
        // 每个分区item的高度
        CGFloat itemH = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(collectionViewItemSizeForIndexPath:)] && totalItems > 0) {
            itemH = [_delegate collectionViewItemSizeForIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]].height;
        }
        
        CGFloat sectionH = 0;
        // 每个分区section的高度
        if (_delegate && [_delegate respondsToSelector:@selector(collectionViewSectionHeadSizeForSection:)]) {
            sectionH = [_delegate collectionViewSectionHeadSizeForSection:i].height;
        }
        y += sectionH + [_widthArr[i] count] * ( itemH + _interSpace) + _interSpace;
    
    }

    return y;
    
}

#pragma mark ====== 计算collectionView的内容大小 =======
- (CGSize)collectionViewContentSize {
   
    NSInteger totalSections = [self.collectionView numberOfSections];
    CGFloat height = 0;
    
    for (NSInteger i=0; i<totalSections; i++) {
        // 每个分区section的高度
        CGFloat sectionH = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(collectionViewSectionHeadSizeForSection:)]) {
            sectionH = [_delegate collectionViewSectionHeadSizeForSection:i].height;
        }
        
        //拿到每个分区所有item的个数
        NSInteger totalItems = [self.collectionView numberOfItemsInSection:i];
        // 每个分区item的高度
        CGFloat itemH = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(collectionViewItemSizeForIndexPath:)] && totalItems > 0) {
            itemH = [_delegate collectionViewItemSizeForIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]].height;
        }
        
        height += sectionH + (itemH + _interSpace) * [_widthArr[i] count];
        
    }

    height += _interSpace * totalSections ;
    CGFloat width =self.collectionView.frame.size.width;
    
    return CGSizeMake(width, height);
    
}

/*
 这个方法的返回值是个数组
 这个数组中存放的都是UICollectionViewLayoutAttributes对象
 UICollectionViewLayoutAttributes对象决定了cell的排布方式（frame等）
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    return _attributeArray;
   
}

//每次取最小x的行
- (NSInteger)minCurrentLineWithSection:(NSInteger)section {
    __block CGFloat minWidth = CGFLOAT_MAX;
    __block NSInteger minIndex = 0;
    NSArray *arr = _widthArr[section];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat currentWidth = [arr[idx] floatValue];
        if (currentWidth < minWidth) {
            minWidth = currentWidth;
            minIndex = idx;
        }
    }];
    
    return minIndex;
}

-(NSMutableArray *)widthArr{
    if (_widthArr==nil) {
        _widthArr=[[NSMutableArray alloc] init];
    }
    return _widthArr;
}

-(NSMutableArray *)attributeArray{
    if (_attributeArray==nil) {
        _attributeArray=[[NSMutableArray alloc] init];
    }
    return _attributeArray;
}

@end
