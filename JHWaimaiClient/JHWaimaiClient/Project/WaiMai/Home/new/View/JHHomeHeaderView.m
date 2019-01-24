//
//  JHHomeHeaderView.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/8/30.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeHeaderView.h"
#import "JHHomeHeaderViewOne.h"
#import "JHHomeHeaderViewTwo.h"
@implementation JHHomeHeaderView
{
    JHHomeHeaderViewOne *header_one;
    JHHomeHeaderViewTwo *header_two;
    
}
- (instancetype)initWithFrame:(CGRect)frame type:(NSUInteger)type{
    
    if (type == 2) {
        //第二种表头
        header_two = [[JHHomeHeaderViewTwo alloc] initWithFrame:frame];
        return header_two;
    }else{
        //第一和第三种表头(有天气)
        header_one = [[JHHomeHeaderViewOne alloc] initWithFrame:frame];
        return header_one;
    }
}
//子类去具体实现
- (void)changeStatusWithOffset_y:(CGFloat)offset_y{}

- (void)addrL_addTarget:(id)target action:(SEL)action{}
//设置数据
- (void)setDataDic:(NSDictionary *)dataDic{}

@end
