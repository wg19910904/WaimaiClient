//
//  JHHomeShopShaiXuanCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/26.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeShopShaiXuanCell.h"
#import "YFTypeBtn.h"
@implementation JHHomeShopShaiXuanCell
{
    UILabel *_titleL;
    JHHomeShaiXuanView *_shaiXuanV;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEX(@"ffffff", 1.0);
        [self setupUI];
        //筛选提交发生改变
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(shaixuanChanged:)
                                                     name:KNotification_Home_shaixuanChanged
                                                   object:nil];
    }
    return self;
}
#pragma mark - 布局
- (void)setupUI{
    _titleL = [UILabel new];
    [self.contentView addSubview:_titleL];
    _titleL.font = B_FONT(18);
    _titleL.textColor = HEX(@"333333", 1.0);
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.top.offset = 12;
        make.height.offset = 20;
    }];
    _titleL.font = B_FONT(18);
    _titleL.textColor = HEX(@"222222", 1.0);
    _titleL.text = NSLocalizedString(@"附近商家", nil);
    //
    _shaiXuanV = [JHHomeShaiXuanView new];
    [self.contentView addSubview:_shaiXuanV];
    [_shaiXuanV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 44;
        make.left.right.offset = 0;
        make.height.offset = 44;
        make.bottom.offset = 0;
    }];
    _shaiXuanV.titleArr = @[NSLocalizedString(@"全部分类   ",nil),
                             NSLocalizedString(@"排序   ",nil),
                             NSLocalizedString(@"筛选   ",nil)];

}

#pragma mark - 筛选条件发生改变,更新title
- (void)shaixuanChanged:(NSNotification *)noti{
    NSDictionary *filterDic = (NSDictionary *)noti.object;
    _shaiXuanV.titleArr = @[filterDic[@"title1"],
                            filterDic[@"title2"],
                            NSLocalizedString(@"筛选   ",nil)];
}
@end
