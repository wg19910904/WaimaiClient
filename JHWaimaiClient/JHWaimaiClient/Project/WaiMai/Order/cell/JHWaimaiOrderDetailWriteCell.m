//
//  JHWaimaiOrderDetailWriteCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailWriteCell.h"
@interface JHWaimaiOrderDetailWriteCell()
@end
@implementation JHWaimaiOrderDetailWriteCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BACK_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self textView];
    }
    return self;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textColor = HEX(@"666666", 1);
        _textView.font = FONT(14);
        _textView.textContainerInset = UIEdgeInsetsMake(10, 12, 0, 12);
        _textView.text = NSLocalizedString(@"请输入投诉内容,客服会尽快和您联系,请耐心等待", nil);
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset = 0;
            make.top.offset = 10;
            make.bottom.offset = -10;
            make.height.offset  = 120;
        }];
    }
    return _textView;
}
@end
