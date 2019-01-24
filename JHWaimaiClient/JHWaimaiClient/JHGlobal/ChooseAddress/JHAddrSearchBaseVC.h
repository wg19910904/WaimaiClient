//
//  JHAddrSearchBaseVC.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/1/8.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHAddrSearchBaseVC : JHBaseVC
@property(nonatomic,weak)JHBaseVC *superVC;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSString *city;
-(void)reloadData;
@end
