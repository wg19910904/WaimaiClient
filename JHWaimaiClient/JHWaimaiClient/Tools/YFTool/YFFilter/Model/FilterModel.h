//
//  FilterModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/4.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterModel : NSObject
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *parent_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSArray *childrens;
@property(nonatomic,copy)NSString *icon;
@end
