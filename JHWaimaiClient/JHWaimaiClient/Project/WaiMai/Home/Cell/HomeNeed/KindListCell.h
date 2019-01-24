//
//  JHKindListCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/4/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickKindItem)(NSInteger index);

@interface KindListCell : UITableViewCell
@property(nonatomic,copy)ClickKindItem clickKindItem;
@property(nonatomic,assign)int lineOfItems;
-(void)reloadCellWithArr:(NSArray *)kindItemArr;

@end
