//
//  YFPayMoneyCell.h
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFPayMoneyCell : YFBaseTableViewCell
@property(nonatomic,copy)MsgBlock timeOverBlock;
-(void)reloadCellWithMoney:(NSString *)money dateline:(NSInteger)dateline;
@end

NS_ASSUME_NONNULL_END
