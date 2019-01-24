//
//  MineAddBankCardChooseBankCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickIndex)(NSInteger index);

@interface MineAddBankCardChooseBankCell : UITableViewCell
@property(nonatomic,copy)ClickIndex clickIndex;

-(void)reloadCellWithCartType:(int)type is_edit:(BOOL)is_edit;
@end
