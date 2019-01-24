//
//  JHWMCreateOrderPayTypeSheetView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHWMCreateOrderPayTypeSheetViewDelegate <NSObject>

-(void)payOrderWith:(NSString *)code use_money:(BOOL)is_use;
-(void)cancelPayOrder;
@end

@interface JHWMCreateOrderPayTypeSheetView : UIView
// 订单支付的金额
@property(nonatomic,copy)NSString *amount;

/**
 创建sheetview
 
 @param title 标题
 @param amount 支付时的金额
 @param delegate 代理
 @return 创建好的sheetview对象
 */
-(JHWMCreateOrderPayTypeSheetView *)initWithTitle:(NSString *)title amount:(NSString *)amount delegate:(id<JHWMCreateOrderPayTypeSheetViewDelegate>)delegate;


-(void)sheetShow;

-(void)sheetHidden;
@end
