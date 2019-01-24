//
//  ShopDetailYouHuiView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickShowMore)(BOOL selected);

@interface ShopDetailYouHuiView : UIView

-(void)reloadViewWithArr:(NSArray *)youHuiArr;

@property(nonatomic,copy)ClickShowMore clickShowMore;
// 其他控件距离顶部的距离
@property(nonatomic,assign)float topOffset;

@end
