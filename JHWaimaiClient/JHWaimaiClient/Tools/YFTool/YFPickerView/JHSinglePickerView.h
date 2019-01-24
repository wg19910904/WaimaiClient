//
//  JHPaoTuiSinglePickerView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2017/10/10.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "YFPickerView.h"

@interface JHSinglePickerView : YFPickerView
@property(nonatomic,assign)BOOL is_weight;// 选择价格还是重量
@property(nonatomic,copy)MsgBlock clickSureBlock;
@end
