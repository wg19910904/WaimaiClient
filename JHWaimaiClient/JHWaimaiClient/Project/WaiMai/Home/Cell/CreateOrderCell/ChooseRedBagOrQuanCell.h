//
//  ChooseRedBagOrQuanCell.h
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/11/20.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseRedBagOrQuanCell : YFBaseTableViewCell
-(void)reloadCellWithModel:(NSDictionary *)dic is_redbag:(BOOL)is_redbag;
@end

NS_ASSUME_NONNULL_END
