//
//  AppDelegate.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/4/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaimaiHomeModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)JHWaimaiHomeModel *tabbarConfig;
@property(nonatomic,strong)JHWaimaiHomeModel *homeConfig;

- (UIViewController*)topViewController;

@end

