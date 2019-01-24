//
//  XHImageView.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "XHImageView.h"

@implementation XHImageView
{
    UITapGestureRecognizer *ges;
    UILabel *_badgeL; //数量标签
}
- (instancetype)init{
    if (self = [super init]) {
        //设置模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}
#pragma mark - 添加手势

- (void)addGesture{
    
}

- (void)addTarget:(id)target action:(SEL)selector{
    self.userInteractionEnabled = YES;
    ges = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:ges];
}
- (void)setBadgeNum:(NSUInteger)badgeNum{
    [_badgeL removeFromSuperview];
    _badgeL = nil;
    if (badgeNum > 0) {
        _badgeL = [UILabel new];
        [self addSubview:_badgeL];
        [_badgeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -2;
            make.width.height.offset = 16;
            make.top.offset = -5;
        }];
        _badgeL.backgroundColor = HEX(@"FF9900",1.0);
        _badgeL.layer.cornerRadius = 8;
        _badgeL.clipsToBounds = YES;
        _badgeL.textAlignment = NSTextAlignmentCenter;
        _badgeL.font = FONT(12);
        _badgeL.textColor = HEX(@"ffffff", 1.0);
        _badgeL.text = @(badgeNum).stringValue;
    }
}
@end
