//
//  JHOrderBuyHongBaoCardCell.h
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderBuyHongBaoCardCell : YFBaseTableViewCell
@property(nonatomic,copy)MsgBlock chooesedBlock;
-(void)reloadCellWithInfo:(NSDictionary *)redPackageInfo selected:(BOOL)is_select;

@end

NS_ASSUME_NONNULL_END
