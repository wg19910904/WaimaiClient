//
//  ZQAreaView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQAreaView : UIView
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,copy)void(^removeBlock)();
@property(nonatomic,assign)BOOL isShangCheng;
@end
