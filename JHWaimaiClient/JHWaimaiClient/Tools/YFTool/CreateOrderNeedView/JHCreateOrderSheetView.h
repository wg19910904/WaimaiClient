//
//  JHCreateOrderSheetView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SheetViewChoosePayType,// 支付的类型
    SheetViewChoosePayWay,// 支付的方式（在线支付）
    SheetViewChooseMoneyPayType,
    SheetViewChooseHongBao,
    SheetViewChooseYouHui,
    SheetViewChooseTime,
    SheetViewChooseNormal // 仅仅显示一行文字
} JHCreateOrderSheetViewType;

@class JHCreateOrderSheetView;

@protocol JHCreateOrderSheetViewDelegate <NSObject>
@optional

/**
 选择某一个选项

 @param sheetView 当前的sheetView
 @param index 选择的index
 @param str 选择的value
 */
-(void)sheetView:(JHCreateOrderSheetView *)sheetView clickIndex:(NSInteger)index choosedValue:(NSString *)str;

// 调起支付
-(void)sureToPay;

// 取消支付
-(void)cancleToPay;

@end

@interface JHCreateOrderSheetView : UIView

@property(nonatomic,weak)id<JHCreateOrderSheetViewDelegate> delegate;

 // 只有支付类型才有效 0 都支持 1 只支持在线支付 2 只支持货到付款
@property(nonatomic,assign)int payWayType;
 //  修改标题
@property(nonatomic,copy)NSString *titleStr;

// 选中的
@property(nonatomic,copy)NSString *hongbao_id;
@property(nonatomic,copy)NSString *coupon_id;
// 订单支付的金额
@property(nonatomic,copy)NSString *amount;

@property(nonatomic,strong)NSArray *dataSource;

@property(nonatomic,assign)BOOL didAppear;// 是否显示出来了
//@property(nonatomic,assign)BOOL canClickPay;// 可以再次点击支付

@property(nonatomic,strong)NSIndexPath *lastIndexPath;// 上次选中的index

/**
 创建sheetview

 @param title 标题
 @param amount 支付时的金额
 @param delegate 代理
 @param sheetType sheetview的类型
 @param dataSource 数据源
 @return 创建好的sheetview对象
 */
-(JHCreateOrderSheetView *)initWithTitle:(NSString *)title amount:(NSString *)amount delegate:(id<JHCreateOrderSheetViewDelegate>)delegate sheetViewType:(JHCreateOrderSheetViewType)sheetType dataSource:(NSArray *)dataSource;


-(void)sheetShow;

-(void)sheetHidden;

@end
