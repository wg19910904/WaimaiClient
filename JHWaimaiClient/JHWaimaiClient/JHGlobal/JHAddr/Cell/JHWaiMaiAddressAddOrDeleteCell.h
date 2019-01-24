//
//  JHWaiMaiAddressAddOrDeleteCell.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWaiMaiAddressAddOrDeleteCell : UITableViewCell
@property(nonatomic,strong)UIButton *saveBtn; //保存的按钮
@property(nonatomic,strong)UIButton *deleteBtn; //删除的按钮

- (instancetype)initWithSaveBlock:(void(^)())saveBlock deleteBlock:(void (^)())deleteBlock;


@end
