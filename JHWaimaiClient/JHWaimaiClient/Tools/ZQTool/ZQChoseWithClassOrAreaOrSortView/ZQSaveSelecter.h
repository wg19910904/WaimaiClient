//
//  ZQSaveSelecter.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQSaveSelecter : NSObject
@property(nonatomic,assign)BOOL isSelector;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,assign)BOOL isClass;
@property(nonatomic,assign)BOOL isSub;
@property(nonatomic,strong)NSIndexPath *indexP;
@property(nonatomic,assign)BOOL isArea;
@property(nonatomic,assign)BOOL isAreaSub;
@property(nonatomic,strong)NSIndexPath *areaIndexP;
+(ZQSaveSelecter *)saveModel;
@end
