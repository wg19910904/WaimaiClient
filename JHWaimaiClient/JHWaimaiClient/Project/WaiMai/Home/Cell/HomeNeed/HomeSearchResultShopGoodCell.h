//
//  HomeSearchResultShopCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/26.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"
#import "WMShopGoodModel.h"

@interface HomeSearchResultShopGoodCell : YFBaseTableViewCell
-(void)reloadCellWithModel:(WMShopGoodModel *)model withStr:(NSString *)str withColor:(NSString *)colorStr;
@end
