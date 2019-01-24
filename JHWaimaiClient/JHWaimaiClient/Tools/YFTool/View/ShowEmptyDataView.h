//
//  ShowEmptyDataView.h
//  JHLive
//
//  Created by jianghu3 on 16/8/31.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickStatusBtn)();

@interface ShowEmptyDataView : UIView
@property(nonatomic,copy)NSString *emptyImg;
@property(nonatomic,copy)NSString *desStr;
@property(nonatomic,copy)NSAttributedString *desAttrStr;
@property(nonatomic,copy)NSString *statusBtnTitle;
@property(nonatomic,strong)UIColor *btnColor;
@property(nonatomic,assign)BOOL is_showBtn;
/**
 *  点击不同状态下的按钮事件
 */
@property(nonatomic,copy)ClickStatusBtn clickStatusBtn;

@end
