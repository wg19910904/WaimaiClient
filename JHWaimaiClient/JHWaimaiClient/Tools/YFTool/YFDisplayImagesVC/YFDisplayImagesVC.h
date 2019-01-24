//
//  YFDisplayImagesVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/9.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"
#import "PresentAnimationTransition.h"

typedef void(^ClickDismiss)(NSInteger index);

@interface YFDisplayImagesVC : JHBaseVC

@property(nonatomic,copy)ClickDismiss clickDismiss;
@property(nonatomic,strong)PresentAnimationTransition *presentAnimation;

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSArray *imgsArr;

@end
