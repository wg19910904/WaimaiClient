//
//  JHHomeADImageCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeADImageCell.h"

@implementation JHHomeADImageCell
{
    NSDictionary *_dataDic;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
@end
