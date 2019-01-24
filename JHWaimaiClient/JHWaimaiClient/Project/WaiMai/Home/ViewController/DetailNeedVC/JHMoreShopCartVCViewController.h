//
//  JHMoreShopCartVCViewController.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/18.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "JHWMShopCartVC.h"

@interface JHMoreShopCartVCViewController : JHBaseVC
@property(nonatomic,copy)NSString *startPrice;// 起送价
@property(nonatomic,assign)BOOL isClosed;
@property(nonatomic,assign)BOOL have_must;
@property(nonatomic,weak)JHWMShopCartVC *shopCartVC;
@end
