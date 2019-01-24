//
//  JHWMChooseFirstYouHuiCell.h
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/9/27.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"
#import "SevenSwitch.h"

@interface JHWMChooseFirstYouHuiCell : YFBaseTableViewCell
@property(nonatomic,weak)SevenSwitch *youhuiSwitch;
@property(nonatomic,copy)MsgBlock swChangeValueBlock;
@end

