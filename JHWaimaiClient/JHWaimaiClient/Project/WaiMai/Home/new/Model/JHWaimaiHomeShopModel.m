//
//  JHWaimaiHomeShopModel.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/8/29.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHWaimaiHomeShopModel.h"

@implementation JHWaimaiHomeShopModel

- (NSArray *)huodongTitleArr{
    NSMutableArray *titleArr = @[].mutableCopy;
    for (NSDictionary *huodongDic in self.huodong) {
        NSString *title = huodongDic[@"title"];
        [titleArr addObject:title];
    }
    [titleArr addObjectsFromArray:self.default_titleArr];
    return titleArr;
}

- (NSArray *)default_titleArr{
    NSMutableArray *titleArr = @[].mutableCopy;
    if (self.is_refund.integerValue == 1){
        [titleArr addObjectsFromArray:@[@"极速退款"]];
    }
    if (self.is_ziti.integerValue == 1) {
        [titleArr addObjectsFromArray:@[@"支持自提"]];
    }
    return titleArr;
}
@end
