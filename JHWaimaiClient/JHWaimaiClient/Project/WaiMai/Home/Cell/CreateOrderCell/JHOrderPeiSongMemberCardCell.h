//
//  JHOrderPeiSongMemberCardCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/31.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"

@interface JHOrderPeiSongMemberCardCell : YFBaseTableViewCell
@property(nonatomic,copy)MsgBlock chooesedBlock;
@property(nonatomic,copy)MsgBlock showPeiSongList;

-(void)reloadCellWithInfo:(NSDictionary *)cardInfo selected:(BOOL)is_select;

@end
