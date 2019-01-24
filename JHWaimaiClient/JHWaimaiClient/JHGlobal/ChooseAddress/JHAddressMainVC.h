//
//  JHAddressMainVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^RefreshBlock)();
@interface JHAddressMainVC : JHBaseVC
@property(nonatomic, copy)RefreshBlock refreshBlock;
@end
