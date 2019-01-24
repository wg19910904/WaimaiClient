//
//  JHHomeSearchResultShopHeaderView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/26.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMShopModel.h"

@interface JHHomeSearchResultShopHeaderView : UITableViewHeaderFooterView

-(void)reloadViewWith:(WMShopModel *)shop withStr:(NSString *)str withColor:(NSString *)colorStr;

@property(nonatomic,copy)MsgBlock clickHeaderBlock;
@end
