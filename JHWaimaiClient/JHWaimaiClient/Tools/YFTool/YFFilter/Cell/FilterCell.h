//
//  FilterCell.h
//  Lunch
//
//  Created by ios_yangfei on 17/3/21.
//  Copyright © 2017年 jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UITableViewCell
@property(nonatomic,assign)int type;// 1 cate 2 sort

@property(nonatomic,copy)NSString *titleStr;
@end
