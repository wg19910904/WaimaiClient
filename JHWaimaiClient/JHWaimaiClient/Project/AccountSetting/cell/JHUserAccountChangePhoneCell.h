//
//  JHUserAccountChangePhoneCell.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/3.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"
@interface JHUserAccountChangePhoneCell : UITableViewCell
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UITextField *textF;//输入框
@property(nonatomic,weak)JHBaseVC *superVC;
@end
