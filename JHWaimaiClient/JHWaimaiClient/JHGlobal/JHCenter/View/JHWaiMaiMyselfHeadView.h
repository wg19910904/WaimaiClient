//
//  JHWaiMaiMyselfHeadView.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWaiMaiMyselfHeadView : UIImageView
@property(nonatomic,copy)UILabel *nameL;
@property(nonatomic,strong)UIImageView *headIV;
@property(nonatomic,weak)UIViewController *superVC;
@property (nonatomic,assign)BOOL isMall; //用于区分商城和外卖,以展示不同的头部背景
- (void)refreshPosition:(CGFloat)offset_y;

/**
 刷新数据
 */
-(void)refreshData;
@end
