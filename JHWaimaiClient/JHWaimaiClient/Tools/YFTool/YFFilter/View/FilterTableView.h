//
//  FilterTableView.h
//  Lunch
//
//  Created by ios_yangfei on 17/3/21.
//  Copyright © 2017年 jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger{
    FilterOneTable,
    FilterTwoTable
} YFFilterType;

// 点击的回调
typedef void(^ClickChooseBlock)(NSInteger left,NSInteger right);

@interface FilterTableView : UIView
@property(nonatomic,assign)YFFilterType filterType;
@property(nonatomic,copy)ClickChooseBlock chooseBlock;
@property(nonatomic,strong)NSArray *leftArr;
@property(nonatomic,strong)NSArray *rightArr;

@property(nonatomic,assign)int kindType; // 0分类  1地区  2排序

@property(nonatomic,assign)NSInteger firstShowSelectedIndex;// 从上一个界面传过来的选中

@property(nonatomic,assign)NSInteger leftSelectedIndex;
@property(nonatomic,assign)NSInteger rightSelectedIndex;

// 刷新界面
-(void)reloadView;
@end
