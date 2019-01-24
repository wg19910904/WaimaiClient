//
//  WMShopEvaluateHeadView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

// index 选择第几个  showContent 是否只看有内容的
typedef void(^ChooseShowEvaluateType)(NSInteger index , BOOL showContent);

@interface WMShopEvaluateHeadView : UIView

@property(nonatomic,copy)ChooseShowEvaluateType chooseShowEvaluateType;
-(void)reloadViewWithEvaluate:(NSDictionary *)dic type:(NSArray *)typeArr;
@end
