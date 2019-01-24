//
//  UITableView+XHTool.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/9/22.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "UITableView+XHTool.h"
#import <objc/runtime.h>
@implementation UITableView (XHTool)

+(void)load{
    Method systemMethod = class_getInstanceMethod(self, @selector(initWithFrame:style:));
    Method customMethod = class_getInstanceMethod(self, @selector(xh_initWithFrame:style:));
    method_exchangeImplementations(systemMethod, customMethod);
}

- (instancetype)xh_initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    UITableView *table = [self xh_initWithFrame:frame style:style];
    if (@available(iOS 11.0, *)) {
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        
    }else{
        
        
    }
    return table;
}

@end

