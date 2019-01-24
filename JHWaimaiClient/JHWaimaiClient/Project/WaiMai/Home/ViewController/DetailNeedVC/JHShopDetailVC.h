//
//  JHShopDetailVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHShopDetailVC : JHBaseVC

@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)JHBaseVC *superVC;
@property(nonatomic,copy)NSString *shop_id;
//@property(nonatomic,strong)NSString *shopName;

-(void)getData;
@end
