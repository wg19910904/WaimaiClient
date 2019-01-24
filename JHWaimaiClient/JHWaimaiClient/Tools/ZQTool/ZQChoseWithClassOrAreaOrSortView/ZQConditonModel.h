//
//  ZQConditonModel.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQConditonModel : NSObject
+(ZQConditonModel *)showZQConditonModelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,assign)BOOL isSelector;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSMutableArray *subArr;
@end
