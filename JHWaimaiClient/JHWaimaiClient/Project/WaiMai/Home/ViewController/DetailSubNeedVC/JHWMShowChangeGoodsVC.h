//
//  JHWMShowChangeGoodsVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/15.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHWMShowChangeGoodsVC : JHBaseVC

/*
 {
 "cate_id" = 3;
 "package_price" = "2.00";
 "product_id" = 2;
 "product_name" = "\U6d4b\U8bd5\U5546\U54c12";
 "product_number" = 3;
 "product_price" = "8.00";
 "spec_id" = 0;
 "spec_name" = "";
 "specification":good.choosed_proprety,
 ""
 }

 */
@property(nonatomic,strong)NSArray *changedGoodsArr;

@end
