//
//  ZQSortView.h
//  Ceshi
//
//  Created by 洪志强 on 17/5/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,EBottomViewType){
    EBottomViewTypeClass = 1,//分类
    EBottomViewTypeArea = 2,//区域
    EBottomViewTypeSort = 3,//排序
};
@interface ZQBottomView : UIControl
@property(nonatomic,copy)void(^(removeBlock))(void);
+(ZQBottomView *)showZQBottomViewWithFrame:(CGRect)frame inView:(UIView *)view;
@property(nonatomic,assign)EBottomViewType type;
@property(nonatomic,strong)NSArray * currentArr;//排序需要传入的数组
@property(nonatomic,strong)NSArray *classArr;//分类需要的数据
@property(nonatomic,strong)NSArray *areaArr;//区域需要的数组
@property(nonatomic,assign)BOOL isShengCheng;//是否是商城
@property(nonatomic,assign)BOOL isGoods;//是否是商家

/**
 移除的方法
 */
-(void)clickRemove;

/**
 点击价格或者销量移除的方法
 */
-(void)clickRemoveForPrice;
@end
