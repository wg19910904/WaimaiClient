//
//  JHWaimaiHomeShopModel.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/8/29.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWaimaiHomeShopModel : NSObject
/*
 "avg_score" = 5;
 bought = 0;
 "cate_id" = 39;
 comments = 1;
 delcare = "\U5546\U5bb6\U5236\U4f5c\U65f6\U95f415-20\U5206\U949f\Uff0c\U5e02\U533a45\U5206-50\U5206\U949f\U9001\U8fbe\Uff0c\U5e97\U94fa\U56fe\U7247\U4ec5\U4f9b\U53c2 \U8bf7\U4ee5\U5b9e\U7269\U4e3a\U51c6\U3002";
 freight = 11;
 huodong =                 (
 );
 "is_new" = 0;
 juli = "1261689.78";
 "juli_label" = "1261.7km";
 lat = "39.438493";
 lng = "106.889111";
 logo = "http://img01.jhcms.com/wmdemo/photo/201712/20171229_85A30E86A230DF87D6949BAB9E9F346D.png";
 "min_amount" = "20.00";
 orderby = 50;
 orders = 0;
 "pei_time" = 30;
 "pei_type" = 1;
 products =                 (
 );
 score = 5;
 "shop_id" = 623;
 title = "\U300e\U6d77\U5357\U533a \U516d\U4e94\U56db\U917f\U76ae\U70eb\U83dc\U300f";
 viewed = 0;
 "yy_status" = 1;
 "yysj_status" = 1;
 yyst = 1;
 */
@property(nonatomic,copy)NSString *avg_score;
@property(nonatomic,copy)NSString *bought;
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *comments;
@property(nonatomic,copy)NSString *delcare;
@property(nonatomic,copy)NSString *freight;
@property(nonatomic,copy)NSArray *huodong;
@property(nonatomic,copy)NSString *is_new;
@property(nonatomic,copy)NSString *is_refund;
@property(nonatomic,copy)NSString *is_ziti;
@property(nonatomic,copy)NSString *is_reduce_pei;         //是否有配送费减免活动
@property(nonatomic,copy)NSString *reduceEd_freight;
@property(nonatomic,copy)NSString *juli;
@property(nonatomic,copy)NSString *juli_label;
@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *lng;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *min_amount;
@property(nonatomic,copy)NSString *orderby;
@property(nonatomic,copy)NSString *orders;
@property(nonatomic,copy)NSString *pei_time;
@property(nonatomic,copy)NSString *pei_type;
@property(nonatomic,copy)NSDictionary *peiType;
@property(nonatomic,copy)NSArray *products;
@property(nonatomic,copy)NSString *score;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *viewed;
@property(nonatomic,copy)NSString *yy_status;
@property(nonatomic,copy)NSString *yysj_status;
@property(nonatomic,copy)NSString *yyst;
@property(nonatomic,copy)NSString *tips_label;
//
@property(nonatomic,copy)NSArray *huodongTitleArr;
//是否展开活动
@property(nonatomic,assign)BOOL showMoreHuodong;

@property(nonatomic,copy)NSArray *default_titleArr;
@end
