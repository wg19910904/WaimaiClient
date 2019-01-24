//
//  JHWaiMaiMySelfCellOne.h
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/24.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHWaiMaiMySelfCellOne : UITableViewCell
@property(nonatomic,copy)void(^clickBlock)(NSInteger index);
@property(nonatomic,strong)JHUserModel *userModel;
@end

NS_ASSUME_NONNULL_END
