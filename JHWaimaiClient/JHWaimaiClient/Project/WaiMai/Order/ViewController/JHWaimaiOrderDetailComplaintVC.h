//
//  JHWaimaiOrderDetailComplaintVC.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
#import "HZQChoseImage.h"
@interface JHWaimaiOrderDetailComplaintVC : JHBaseVC<HZQChoseImageDelegate>
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *staff_id;
@property(nonatomic,copy)NSString *mobile;
@end
