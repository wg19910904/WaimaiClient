//
//  KindItemCollectionView.h
//  LayoutTest
//
//  Created by ios_yangfei on 16/12/2.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickKindItem)(NSInteger index);

@interface YFKindItemCollectionView : UIView
// collectionViewCell的类名 且实现 reloadCellWithDic:的方法
@property(nonatomic,copy)NSString *cellClass;
@property(nonatomic,assign)int colOrLineItems;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,copy)ClickKindItem clickKindItem;
@property(nonatomic,copy)NSString *textColor;

@end
