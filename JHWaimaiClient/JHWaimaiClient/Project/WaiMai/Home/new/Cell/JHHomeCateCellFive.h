//
//  JHHomeCateCell.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickCateItemFive)(NSInteger index);
@interface JHHomeCateCellFive : UITableViewCell
@property(nonatomic,copy)ClickCateItemFive clickKindItem;
@property(nonatomic,assign)int lineOfItems;
-(void)reloadCellWithArr:(NSArray *)kindItemArr;
//数据
@property(nonatomic,copy)NSDictionary *dataDic;
@end
