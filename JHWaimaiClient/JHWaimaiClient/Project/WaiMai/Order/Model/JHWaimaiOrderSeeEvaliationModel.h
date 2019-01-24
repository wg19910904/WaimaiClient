//
//  JHWaimaiOrderSeeEvaliationModel.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/15.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWaimaiOrderSeeEvaliationModel : NSObject
@property(nonatomic,copy)NSString *clientip;
@property(nonatomic,copy)NSString *closed;
@property(nonatomic,copy)NSString *comment_id;
@property(nonatomic,copy)NSString *content;//评价的内容
@property(nonatomic,copy)NSString *dateline;//时间
@property(nonatomic,copy)NSString *have_photo;//是否有照片
@property(nonatomic,copy)NSString *order_id;//订单号
@property(nonatomic,copy)NSString *order_intro;
@property(nonatomic,copy)NSString *pei_time;
@property(nonatomic,strong)NSArray *photos;//图片的数组
@property(nonatomic,copy)NSString *reply;//回复的内容
@property(nonatomic,copy)NSString *reply_ip;
@property(nonatomic,copy)NSString *reply_time;//回复的时间
@property(nonatomic,copy)NSString *score;//总的评分
@property(nonatomic,copy)NSString *score_avg;//平均得分
@property(nonatomic,copy)NSString *score_peisong;//配送服务得分
@property(nonatomic,copy)NSString *shop_id;//商家的id
@property(nonatomic,copy)NSString *uid;//用户id
@property(nonatomic,copy)NSString *shop_logo;//商家的logo
@property(nonatomic,copy)NSString *shop_title;//商家的姓名
@property(nonatomic,copy)NSString *songda;//送达时间
@property(nonatomic,strong)NSArray *product_list;//对产品的评价

/*
 pingjia;
 "product_id";
 "product_name";
 
 */
@end
