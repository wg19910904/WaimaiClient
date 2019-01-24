//
//  JHFilterTableView.h
//  Lunch
//
//  Created by ios_yangfei on 17/3/21.
//  Copyright © 2017年 jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseFilter)(NSString *filter,NSString *filter1,int index);

@interface YFFilterView : UIView

@property(nonatomic,strong)NSArray *firstArr;
@property(nonatomic,strong)NSArray *secondArr;
@property(nonatomic,strong)NSArray *thirdArr;
@property(nonatomic,assign)BOOL isShop;
@property(nonatomic,copy)NSString *firstSelectedType;// 从上一个界面传过来的选中

@property(nonatomic,copy)ChooseFilter chooseFilter;

-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)arr;

-(void)getData;
@end