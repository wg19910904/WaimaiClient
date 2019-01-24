//
//  JHMallFilterView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/21.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseFilter)(NSString *filter,NSString *filter1,int index);
typedef void(^ChangeTableType)(BOOL is_selected);

@interface JHMallFilterView : UIView

@property(nonatomic,strong)NSArray *firstArr;
@property(nonatomic,strong)NSArray *secondArr;
@property(nonatomic,assign)BOOL isShop;// 商品还是商家
@property(nonatomic,copy)NSString *firstSelectedType;// 从上一个界面传过来的选中
@property(nonatomic,copy)ChangeTableType changeTableType;
@property(nonatomic,copy)ChooseFilter chooseFilter;

-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)arr;

-(void)getData;

-(void)filterTableHidden;
@end
