//
//  JHWaiMaiAddressAddOrDeleteCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiAddressAddOrDeleteCell.h"

@implementation JHWaiMaiAddressAddOrDeleteCell
{
    void(^_saveBlock)();
    void(^_deleteBlock)();
}
- (instancetype)initWithSaveBlock:(void (^)())saveBlock deleteBlock:(void (^)())deleteBlock{
    
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.saveBtn];
        [self addSubview:self.deleteBtn];
        self.backgroundColor = BACK_COLOR;
        _saveBlock = saveBlock;
        _deleteBlock = deleteBlock;
    }
    return self;
}

- (void)clickSaveBtn:(UIButton *)sender{

    if (_saveBlock) _saveBlock();
}

- (void)clickDeleteBtn:(UIButton *)sender{
    if (_deleteBlock) _deleteBlock();
}

- (UIButton *)saveBtn{
    if (_saveBtn == nil) {
        _saveBtn = [[UIButton alloc] initWithFrame:FRAME(15, 15, WIDTH - 30, 40)];
        [_saveBtn setTitle:NSLocalizedString(@"保存", nil) forState:(UIControlStateNormal)];
        [_saveBtn setBackgroundColor:THEME_COLOR_Alpha(1.0) forState:(UIControlStateNormal)];
        [_saveBtn setTitleColor:HEX(@"ffffff", 1.0) forState:(UIControlStateNormal)];
        _saveBtn.titleLabel.font = FONT(16);
        [_saveBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _saveBtn;
}

- (UIButton *)deleteBtn{
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] initWithFrame:FRAME(15, 70, WIDTH - 30, 40)];
        [_deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:(UIControlStateNormal)];
        [_deleteBtn setBackgroundColor:HEX(@"ffffff", 1.0) forState:(UIControlStateNormal)];
        [_deleteBtn setTitleColor:HEX(@"ff3300", 1.0) forState:(UIControlStateNormal)];
        _deleteBtn.titleLabel.font = FONT(16);
        [_deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _deleteBtn;
}

@end
