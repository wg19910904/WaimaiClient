//
//  FilterAddressModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/4.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterAddressModel : NSObject
@property(nonatomic,copy)NSString *area_id;
@property(nonatomic,copy)NSString *area_name;
@property(nonatomic,strong)NSArray *business;
@end
