//
//  ZQConditonModel.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQConditonModel.h"

@implementation ZQConditonModel
+(ZQConditonModel *)showZQConditonModelWithDic:(NSDictionary *)dic{
    return [[ZQConditonModel alloc]init];
}
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)subArr{
    if (!_subArr) {
        _subArr = @[].mutableCopy;
    }
    return _subArr;
}
@end
