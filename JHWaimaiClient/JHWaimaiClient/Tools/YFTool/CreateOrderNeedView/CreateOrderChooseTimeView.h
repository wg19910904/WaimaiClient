//
//  CreateOrderChooseTimeView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

// 点击的回调
typedef void(^ClickChooseBlock)(NSInteger left,NSInteger right,NSString *str);

@interface CreateOrderChooseTimeView : UIView

@property(nonatomic,copy)ClickChooseBlock chooseBlock;
@property(nonatomic,strong)NSArray *leftArr;

// 刷新界面
-(void)reloadView;

@end
