//
//  YFWMFilterView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaiMaiHomeVC.h"
#import "YFTypeBtn.h"
//filterIndex 第几个筛选表
typedef void(^ChooseFilter)(NSString *cate_id,NSString *order,NSString *pei_filter,NSString *youhui_filter,NSString *feature_filter,int filterIndex,NSString *title1,NSString *title2,NSString *title3);

@interface YFWMFilterView : UIView

@property(nonatomic,strong)NSArray *firstArr;
@property(nonatomic,strong)NSArray *secondArr;
@property(nonatomic,strong)NSArray *thirdArr;
@property(nonatomic,weak)JHWaiMaiHomeVC *targetVC;
@property(nonatomic,copy)NSString *firstSelectedType;// 从上一个界面传过来的选中

@property(nonatomic,copy)ChooseFilter chooseFilter;

-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)arr;
-(void)clickTable:(YFTypeBtn *)btn;
-(void)getData;
- (void)updateTitle:(NSArray *)titleArr;
-(void)filterTableHidden;
@end
