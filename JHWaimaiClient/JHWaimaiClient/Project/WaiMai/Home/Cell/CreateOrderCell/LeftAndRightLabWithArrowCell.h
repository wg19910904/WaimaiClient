//
//  LeftAndRightLabWithArrowCell.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"

@interface LeftAndRightLabWithArrowCell : YFBaseTableViewCell
@property(nonatomic,weak)UIImageView *arrowImgView;

-(void)reloadCell:(NSString *)leftStr rightStr:(NSString *)rightStr rightColor:(UIColor *)color is_money:(BOOL)is_money;
@end
