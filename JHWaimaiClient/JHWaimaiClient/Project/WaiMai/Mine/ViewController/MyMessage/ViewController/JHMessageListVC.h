//
//  JHMessageListVC.h
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/25.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHBaseVC.h"
typedef NS_ENUM(NSInteger, FromType)
{
    FromType1,//消息提醒
    FromType2,//温馨提示
};
NS_ASSUME_NONNULL_BEGIN

@interface JHMessageListVC : JHBaseVC
@property(nonatomic,assign)FromType type;
@end

NS_ASSUME_NONNULL_END
