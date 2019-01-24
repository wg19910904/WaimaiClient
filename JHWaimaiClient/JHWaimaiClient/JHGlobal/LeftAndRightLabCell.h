//
//  LeftAndRightLabCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftAndRightLabCell : UITableViewCell
@property(nonatomic,copy)MsgBlock clickQuestionBlock;

@property(nonatomic,strong)UIColor *textColor;

-(void)reloadCell:(NSString *)leftStr rightStr:(NSString *)rightStr;

-(void)reloadCellWithYouHuiDic:(NSDictionary *)dic;
@end
