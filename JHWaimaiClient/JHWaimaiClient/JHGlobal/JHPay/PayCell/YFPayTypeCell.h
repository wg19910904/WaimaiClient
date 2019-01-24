//
//  YFPayTypeCell.h
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFPayTypeCell : YFBaseTableViewCell
@property(nonatomic,weak)UILabel *bankCardNameLab;
@property(nonatomic,weak)UILabel *moneyLab;

-(void)reloadCellWithDic:(NSDictionary *)dic payMoney:(NSString *)payMoney is_selected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
