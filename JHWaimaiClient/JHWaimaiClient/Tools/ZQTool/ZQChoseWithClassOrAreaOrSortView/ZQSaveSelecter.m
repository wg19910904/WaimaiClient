//
//  ZQSaveSelecter.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQSaveSelecter.h"
static ZQSaveSelecter *saveModel;
@implementation ZQSaveSelecter
+(ZQSaveSelecter *)saveModel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        saveModel = [[ZQSaveSelecter alloc]init];
    });
    return saveModel;
}
@end
