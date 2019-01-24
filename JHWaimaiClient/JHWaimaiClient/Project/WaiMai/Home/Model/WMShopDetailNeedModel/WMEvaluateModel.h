//
//  WMEvaluateModel.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EvaluateBlock)(NSArray *dataArr,NSDictionary *scoreDic,NSArray *typeArr,NSString *msg);

@interface WMEvaluateModel : NSObject
@property(nonatomic,assign)float score;
@property(nonatomic,copy)NSString *face;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,assign)NSInteger dateline;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *pei_time;
@property(nonatomic,assign)BOOL have_photo;
@property(nonatomic,strong)NSArray *comment_photos;
@property(nonatomic,copy)NSString *reply;


/**
 获取商家评论列表

 @param shop_id 商家id
 @param page 分页
 @param type 筛选条件
 @param is_null 是否看有内容评价  1 有内容 0 无内容
 @param block 回调的block
 */
+(void)getEvaluateListWith:(NSString *)shop_id page:(int)page type:(int)type is_null:(int)is_null block:(EvaluateBlock)block;
@end
