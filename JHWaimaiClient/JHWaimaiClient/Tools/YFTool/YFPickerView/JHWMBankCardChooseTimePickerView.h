//
//  JHWMBankCardChooseTimePickerView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "YFPickerView.h"

typedef void(^TimeChooseBlock)(NSString *year,NSString *mouth);

@interface JHWMBankCardChooseTimePickerView : YFPickerView
@property(nonatomic,copy)TimeChooseBlock timeChooseBlock;
@end
