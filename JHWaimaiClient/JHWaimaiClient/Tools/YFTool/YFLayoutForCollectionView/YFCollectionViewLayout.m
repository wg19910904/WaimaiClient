//
//  YFCollectionViewLayout.m
//  LayoutTest
//
//  Created by ios_yangfei on 16/11/23.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "YFCollectionViewLayout.h"

@interface YFCollectionViewLayout ()
@property(nonatomic,strong)NSMutableArray *attributeArray;
@end

@implementation YFCollectionViewLayout

-(void)setLineItems:(int)lineItems{
    if (_lineItems != lineItems) {
        _lineItems = lineItems;
        // 重新布局
        [self invalidateLayout];
    }
}

- (void)setInterSpace:(CGFloat)interSpace {
    if (_interSpace != interSpace) {
        _interSpace = interSpace;
        [self invalidateLayout];
    }
}

-(void)prepareLayout{
    [super prepareLayout];
    
    [self.attributeArray removeAllObjects];
    
    NSInteger totalSections = [self.collectionView numberOfSections];
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {// 水平方向
        
        for (NSInteger section = 0; section < totalSections; section++) {
            // 每个分区section的y值
            CGFloat sectionX = [self getSectionX:section];
            
            //拿到每个分区所有item的个数
            NSInteger totalItems = [self.collectionView numberOfItemsInSection:section];
            
            // 每个分区section的高度
            CGFloat sectionW = 0;
            if (_delegate && [_delegate respondsToSelector:@selector(collectionViewSectionHeadSizeForSection:)] && totalItems > 0) {
                sectionW = [_delegate collectionViewSectionHeadSizeForSection:section].width;
            }
            
            // 每个分区section的attribute
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attribute.frame = CGRectMake(sectionX, 0, sectionW,self.collectionView.frame.size.height);
            [self.attributeArray addObject:attribute];
            
            
            //第几行
            int col = 0;
            for (NSInteger i=0; i<totalItems; i++) {
                
                //获取每一个item的size
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
                CGSize itemSize = CGSizeZero;
                if (_delegate && [_delegate respondsToSelector:@selector(collectionView:itemSizeForIndexPath:)]) {
                    itemSize = [_delegate collectionView:self.collectionView itemSizeForIndexPath:indexPath];
                }
                CGFloat itemW = itemSize.width;
                
                //获取width最小的行
                for (NSInteger j=0; j<_lineItems; j++) {
                    if (i+j >= totalItems) {
                        break;
                    }
                    
                    // 当前的item是在第几列
                    int count = (int) (i+j )/(_lineItems * 2);
                    int vCount  = _lineItems * count;
                    int vLine = ((int)(i+j) - count * _lineItems * 2) % _lineItems ;
                    vCount += vLine;

                    CGFloat xPos = [self getSectionX:section] + sectionW + (itemW+_interSpace) * vCount ;
                    CGFloat yPos = ( itemSize.height + _interSpace )* col;
                    CGRect frame = CGRectMake(xPos, yPos, itemW, itemSize.height);
                    
                    NSIndexPath *newIndedPath = [NSIndexPath indexPathForItem:(i+j) inSection:section];
                    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:newIndedPath];
                    attribute.frame = frame;
                    
                    [self.attributeArray addObject:attribute];
//                    NSLog(@"%ld  %@",(i+j),NSStringFromCGRect(frame) );
                }
                
                i += _lineItems-1;
                // 换行
                col++;
                if (col > 1) {
                    col = 0;
                }
            }

        }
        
        
    }else{// 竖直方向
        self.collectionView.pagingEnabled = NO;
        
        for (NSInteger section = 0; section < totalSections; section++) {
            
            // 每个分区section的y值
            CGFloat sectionY = [self getSectionY:section];
            
            // 每个分区section的高度
            CGFloat sectionH = 0;
            if (_delegate && [_delegate respondsToSelector:@selector(collectionViewSectionHeadSizeForSection:)]) {
                sectionH = [_delegate collectionViewSectionHeadSizeForSection:section].height;
            }
            
            // 每个分区section的attribute
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attribute.frame = CGRectMake(0, sectionY,self.collectionView.frame.size.width, sectionH);
            [self.attributeArray addObject:attribute];
            
            //拿到每个分区所有item的个数
            NSInteger totalItems = [self.collectionView numberOfItemsInSection:section];
            //第几行
            int col = 0;
            for (NSInteger i=0; i<totalItems; i++) {
                
                //获取每一个item的size
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
                CGSize itemSize = CGSizeZero;
                if (_delegate && [_delegate respondsToSelector:@selector(collectionView:itemSizeForIndexPath:)]) {
                    itemSize = [_delegate collectionView:self.collectionView itemSizeForIndexPath:indexPath];
                }
                CGFloat itemHeight = itemSize.height;
                
                //获取width最小的行
                for (NSInteger j=0; j<_lineItems; j++) {
                    if (i+j >= totalItems) {
                        break;
                    }
                    
                    CGFloat yPos = [self getSectionY:section] + sectionH + (itemHeight+_interSpace) * col;
                    CGFloat xPos = ( itemSize.width + _interSpace )* j;
                    CGRect frame = CGRectMake(xPos, yPos, itemSize.width, itemHeight);
                    
                    NSIndexPath *newIndedPath = [NSIndexPath indexPathForItem:(i+j) inSection:section];
                    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:newIndedPath];
                    attribute.frame = frame;
                    
                    [self.attributeArray addObject:attribute];
                    
                }
                
                i += _lineItems-1;
                col++;
            }

            
        }
        
    }
    
}

#pragma mark ====== 获取竖直方向滑动时的每个分区的y值 =======
-(CGFloat)getSectionY:(NSInteger)section{

    CGFloat height = 0;
    
    for (NSInteger i=0; i<section; i++) {
        
        CGFloat sectionH = 0;
        
        //拿到每个分区所有item的个数
        NSInteger totalItems = [self.collectionView numberOfItemsInSection:i];
        int one = totalItems %_lineItems == 0? 0:1;
        int count = (int)totalItems/_lineItems  +one;
        
        //获取每一个item的size
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        CGSize itemSize = CGSizeZero;
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:itemSizeForIndexPath:)]) {
            itemSize = [_delegate collectionView:self.collectionView itemSizeForIndexPath:indexPath];
        }
        
        CGFloat itemHeight = itemSize.height;
        CGFloat sectionHeaderH = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(collectionViewSectionHeadSizeForSection:)]) {
            sectionHeaderH = [_delegate collectionViewSectionHeadSizeForSection:i].height;
        }
        
        sectionH = count == 0 ? 0 : (itemHeight + _interSpace) *count ;
        height += sectionH + sectionHeaderH;
    
    }
    
    return height;
    
}

#pragma mark ====== 获取水平方向滑动时的每个分区的x值 =======
-(CGFloat)getSectionX:(NSInteger)section{

    CGFloat width = 0;

    for (NSInteger i=0; i<section; i++) {
        
        CGFloat sectionW = 0;
        
        //拿到每个分区所有item的个数
        NSInteger totalItems = [self.collectionView numberOfItemsInSection:i];

        // 求得每个分区的总列数
        int count = (int) totalItems/(_lineItems * 2);
        int vLine = ((int)totalItems - count * _lineItems * 2) / _lineItems ;
        
        int vCount = _lineItems * count;
        if (vLine == 1) {
            vCount += _lineItems;
        }else{
            vCount += ((int)totalItems - count * _lineItems * 2);
        }
        
        //获取每一个item的size
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        CGSize itemSize = CGSizeZero;
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:itemSizeForIndexPath:)]) {
            itemSize = [_delegate collectionView:self.collectionView itemSizeForIndexPath:indexPath];
        }
        
        CGFloat itemW = itemSize.width;
        CGFloat sectionHeaderW = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(collectionViewSectionHeadSizeForSection:)]) {
            sectionHeaderW = [_delegate collectionViewSectionHeadSizeForSection:i].width;
        }
        
        sectionW = vCount == 0 ? 0 : (itemW + _interSpace) * vCount;
        width += sectionW + sectionHeaderW;
        
    }
    
    return width;
    
}

//计算collectionView的内容大小
- (CGSize)collectionViewContentSize {

    CGFloat height =0;
    CGFloat width = 0;
    NSInteger totalSections = [self.collectionView numberOfSections];
    
    if(self.scrollDirection == UICollectionViewScrollDirectionVertical){
        width =self.collectionView.frame.size.width;
        height = [self getSectionY:totalSections];
    }else{
        height =self.collectionView.frame.size.height;
        width = [self getSectionX:totalSections];
        if (self.collectionView.pagingEnabled) {
            int beishu = (int) (width / self.collectionView.width);
            if (width - beishu * self.collectionView.width != 0) {
                width = (beishu + 1) * self.collectionView.width;
            }
        }
    }
    
    return CGSizeMake(width, height);

}

/*
 这个方法的返回值是个数组
 这个数组中存放的都是UICollectionViewLayoutAttributes对象
 UICollectionViewLayoutAttributes对象决定了cell的排布方式（frame等）
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 当collection被销毁的时候会再次走这个方法，如果不返回nil会 报-[UICollectionViewData validateLayoutInRect:]这个错误
//     NSInteger totalItems = [self.collectionView numberOfItemsInSection:0];
    if (_attributeArray.count == 0) return nil;
    
    return _attributeArray;
}

-(NSMutableArray *)attributeArray{
    if (_attributeArray==nil) {
        _attributeArray=[[NSMutableArray alloc] init];
    }
    return _attributeArray;
}

@end
