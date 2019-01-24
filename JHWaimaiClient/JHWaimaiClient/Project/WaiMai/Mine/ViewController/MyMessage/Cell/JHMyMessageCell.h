//
//  JHMyMessageCell.h
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/25.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMyMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHMyMessageCell : UITableViewCell
@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,copy)JHMyMessageModel *model;
@end

NS_ASSUME_NONNULL_END
