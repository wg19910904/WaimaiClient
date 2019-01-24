//
//  ZQChoseWithClassOrAreaOrSortView.h
//  Ceshi
//
//  Created by 洪志强 on 17/5/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,EishaveRightBtnType){
    EishaveRightBtnTypeYes = 0,
    EishaveRightBtnTypeNo
};
@interface ZQChoseWithClassOrAreaOrSortView : UIView

/**
 创建view

 @param type 是否有右边的按钮
 @return 返回创建的对象(目前只支持三组条件的切换)
 */
+(ZQChoseWithClassOrAreaOrSortView *)showViewWithType:(EishaveRightBtnType)type inView:(UIView *)view frame:(CGRect)frame;

/**
 右边的按存在的情况下,是否可点击(默认是Yes)
 */
@property(nonatomic,assign)BOOL isCanClick;
@property(nonatomic,copy)void(^myBlock)(NSInteger type);//点击右边的按钮的回调

/**
 (默认分类区域排序),可传入其他的条件

 */
@property(nonatomic,strong)NSArray *topTitleArr;

/**
 是否是商城
 */
@property(nonatomic,assign)BOOL isShangCheng;
/**
 是否是商品(在商城中才需要这样的判断)
 */
@property(nonatomic,assign)BOOL isGoods;
/**
 移除蒙层的方法
 */
-(void)clickRemove;
@end
