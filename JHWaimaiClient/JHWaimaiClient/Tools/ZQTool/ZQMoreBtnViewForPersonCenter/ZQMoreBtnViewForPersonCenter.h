//
//  ZQMoreBtnViewForPersonCenter.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/7/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  ZQMoreBtnViewDelegate<NSObject>
@required

/**
 展示的按钮的个数

 @return 返回按钮的个数
 */
-(NSInteger)moreBtnViewNumberOfBtn;

/**
 需要的图片的数组,出入图片的名字即可

 @return 返回的图片数组
 */
-(NSArray*)moreBtnViewForBtnImage;

/**
 需要的每个按钮的名字

 @return 返回的按钮的名字
 */
-(NSArray *)moreBtnViewForTitle;
@optional

/**
 需要展示的红色角标值(不需要可不实现该方法)

 @param index 展示的角标的索引(0开始)
 @return 返回的角标值
 */
-(NSString *)moreBtnViewForBtnValue:(NSInteger)index;

/**
 点击按钮后的回调

 @param index 选中的索引
 */
-(void)moreBtnViewDidSelector:(NSInteger)index;
@end
@interface ZQMoreBtnViewForPersonCenter : UIView
@property(nonatomic,weak)id<ZQMoreBtnViewDelegate>delegate;
@property(nonatomic,assign)BOOL isShowLine;//是否展示每个按钮之间的分割线
/**
 刷新角标数值的(全部刷新)
 */
-(void)reloadData;

/**
 刷新某一个的角标值

 @param index 需要的索引
 */
-(void)reloadDataWithIndex:(NSInteger)index;
@end
