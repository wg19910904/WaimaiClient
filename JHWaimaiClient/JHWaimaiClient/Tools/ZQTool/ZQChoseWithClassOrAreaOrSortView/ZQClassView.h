//
//  ZQClassView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQClassView : UIView
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,copy)void(^removeBlock)();
@property(nonatomic,assign)BOOL isShangCheng;
/**
 是否是商品(在商城中才需要这样的判断)
 */
@property(nonatomic,assign)BOOL isGoods;
@end
