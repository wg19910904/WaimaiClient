//
//  WMMoreShopCartCellTableViewCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/18.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"
#import "JHWMShopCartModel.h"

@interface WMMoreShopCartCell : YFBaseTableViewCell
-(void)reloadCellWithModel:(JHWMShopCartModel *)model;
@property(nonatomic,copy)MsgBlock clickActionBlock;
@end
