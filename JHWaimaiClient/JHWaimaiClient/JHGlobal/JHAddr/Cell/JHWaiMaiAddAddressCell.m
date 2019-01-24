//
//  JHWaiMaiAddAddressCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiAddAddressCell.h"

@implementation JHWaiMaiAddAddressCell

- (instancetype)init{
    if (self = [super init]) {
        [self setupView];
        self.backgroundColor = HEX(@"ffffff", 1.0);
    }
    return self;
}

- (void)setupView{
    self.titleL = [[UILabel alloc] initWithFrame:FRAME(12, 0, 62, 50)];
    self.titleL.font = FONT(14);
    self.titleL.textColor = HEX(@"333333", 1.0);
    [self addSubview:self.titleL];
    
    self.contentF = [[UITextField alloc] initWithFrame:FRAME(74, 0, WIDTH-84, 50)];
    self.contentF.font = FONT(14);
    self.contentF.textColor = HEX(@"666666", 1.0);
    [self addSubview:self.contentF];
    
    self.line = [[UIView alloc] initWithFrame:FRAME(12, 49.5, WIDTH-12, 0.5)];
    self.line.backgroundColor = HEX(@"e6eaed", 1.0);
    [self addSubview:self.line];
}

@end
