//
//  KindItemCell.h
//  LayoutTest
//
//  Created by ios_yangfei on 16/12/2.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KindItemCell : UICollectionViewCell
-(void)reloadCellWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *textColor;

@end
